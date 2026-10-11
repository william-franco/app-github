import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:app_github/src/common/enums/repositories_enums.dart';
import 'package:app_github/src/common/patterns/result_pattern.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';

import '../../repositories_fixtures.dart';
import '../../repositories_mocks.mocks.dart';

void main() {
  setUpAll(registerDummies);

  late MockRepositoriesRepository mockRepository;

  setUp(() {
    mockRepository = MockRepositoriesRepository();
  });

  group('SearchRepositoriesUseCase', () {
    late SearchRepositoriesUseCaseImpl useCase;

    setUp(() {
      useCase = SearchRepositoriesUseCaseImpl(
        repositoriesRepository: mockRepository,
      );
      when(
        mockRepository.searchRepositories(
          query: anyNamed('query'),
          sort: anyNamed('sort'),
          order: anyNamed('order'),
          page: anyNamed('page'),
          perPage: anyNamed('perPage'),
        ),
      ).thenAnswer((_) async => SuccessResult(value: pageEntity()));
    });

    test('buildQuery uses default query when empty', () {
      expect(
        SearchRepositoriesUseCaseImpl.buildQuery(
          const SearchParamsEntity(query: '  '),
        ),
        'stars:>1000',
      );
    });

    test('buildQuery appends language qualifier', () {
      expect(
        SearchRepositoriesUseCaseImpl.buildQuery(
          const SearchParamsEntity(query: ' bloc ', language: 'Dart'),
        ),
        'bloc language:Dart',
      );
    });

    test('buildQuery quotes languages with spaces', () {
      expect(
        SearchRepositoriesUseCaseImpl.buildQuery(
          const SearchParamsEntity(query: 'ml', language: 'Jupyter Notebook'),
        ),
        'ml language:"Jupyter Notebook"',
      );
    });

    test('delegates to repository with params', () async {
      final result = await useCase(
        const SearchParamsEntity(
          query: 'flutter',
          sort: SortType.forks,
          order: OrderType.asc,
          page: 3,
        ),
      );

      expect(result, isA<SuccessResult>());
      verify(
        mockRepository.searchRepositories(
          query: 'flutter',
          sort: SortType.forks,
          order: OrderType.asc,
          page: 3,
          perPage: 30,
        ),
      ).called(1);
    });

    test('rejects invalid page', () async {
      final result = await useCase(const SearchParamsEntity(page: 0));

      expect(result, isA<ErrorResult>());
      verifyZeroInteractions(mockRepository);
    });
  });

  group('GetRepositoryDetailUseCase', () {
    late GetRepositoryDetailUseCaseImpl useCase;

    setUp(() {
      useCase = GetRepositoryDetailUseCaseImpl(
        repositoriesRepository: mockRepository,
      );
    });

    test('delegates valid full name', () async {
      when(mockRepository.getRepository(fullName: 'flutter/flutter'))
          .thenAnswer((_) async => SuccessResult(value: repositoryEntity()));

      final result = await useCase(' flutter/flutter ');

      expect(result, isA<SuccessResult>());
    });

    for (final invalid in ['', 'flutter', 'a/b/c', '/b', 'a/']) {
      test('rejects "$invalid"', () async {
        final result = await useCase(invalid);

        expect(result, isA<ErrorResult>());
        verifyZeroInteractions(mockRepository);
      });
    }
  });
}
