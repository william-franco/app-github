import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:app_github/src/common/enums/repositories_enums.dart';
import 'package:app_github/src/common/patterns/result_pattern.dart';
import 'package:app_github/src/features/repositories/data/data.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';

import '../../repositories_fixtures.dart';
import '../../repositories_mocks.mocks.dart';

void main() {
  setUpAll(registerDummies);

  late RepositoriesRepositoryImpl repository;
  late MockRepositoriesDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockRepositoriesDataSource();
    repository = RepositoriesRepositoryImpl(dataSource: mockDataSource);
  });

  void stubSearch(SearchResult result) {
    when(
      mockDataSource.searchRepositories(
        query: anyNamed('query'),
        sort: anyNamed('sort'),
        order: anyNamed('order'),
        page: anyNamed('page'),
        perPage: anyNamed('perPage'),
      ),
    ).thenAnswer((_) async => result);
  }

  SearchResult searchSuccess({required int total, required int count}) =>
      SuccessResult(
        value: SearchResultModel.fromJson(
          searchJson(total: total, count: count),
        ),
      );

  Future<PageEntity> searchPage(int page) async {
    final result = await repository.searchRepositories(
      query: 'q',
      sort: SortType.stars,
      order: OrderType.asc,
      page: page,
      perPage: 2,
    );
    return (result as SuccessResult<PageEntity, RepositoryException>).value;
  }

  group('searchRepositories', () {
    test('maps enums to api values', () async {
      stubSearch(searchSuccess(total: 10, count: 2));

      await searchPage(1);

      verify(
        mockDataSource.searchRepositories(
          query: 'q',
          sort: 'stars',
          order: 'asc',
          page: 1,
          perPage: 2,
        ),
      ).called(1);
    });

    test('hasMore is true while there are more results', () async {
      stubSearch(searchSuccess(total: 10, count: 2));

      final page = await searchPage(1);

      expect(page.hasMore, isTrue);
      expect(page.totalCount, 10);
      expect(page.page, 1);
    });

    test('hasMore is false on last page', () async {
      stubSearch(searchSuccess(total: 4, count: 2));

      expect((await searchPage(2)).hasMore, isFalse);
    });

    test('hasMore respects 1000 results API limit', () async {
      stubSearch(searchSuccess(total: 5000, count: 2));

      expect((await searchPage(500)).hasMore, isFalse);
    });

    test('propagates errors', () async {
      stubSearch(const ErrorResult(error: RepositoryException('fail')));

      final result = await repository.searchRepositories(
        query: 'q',
        page: 1,
        perPage: 2,
      );

      expect(result, isA<ErrorResult>());
    });
  });

  group('getRepository', () {
    test('returns entity', () async {
      when(mockDataSource.getRepository(fullName: 'a/b')).thenAnswer(
        (_) async =>
            SuccessResult(value: RepositoryModel.fromJson(repositoryJson())),
      );

      final result = await repository.getRepository(fullName: 'a/b');

      expect(result, isA<SuccessResult>());
    });

    test('propagates errors', () async {
      when(mockDataSource.getRepository(fullName: 'a/b')).thenAnswer(
        (_) async => const ErrorResult(error: RepositoryException('fail')),
      );

      final result = await repository.getRepository(fullName: 'a/b');

      expect(result, isA<ErrorResult>());
    });
  });
}
