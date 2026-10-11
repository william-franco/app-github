import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:app_github/src/common/patterns/result_pattern.dart';
import 'package:app_github/src/features/repositories/data/data.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';

import '../../repositories_fixtures.dart';
import '../../repositories_mocks.mocks.dart';

void main() {
  setUpAll(registerDummies);

  late RepositoriesRemoteDataSourceImpl dataSource;
  late MockConnectionService mockConnectionService;
  late MockHttpService mockHttpService;

  setUp(() {
    mockConnectionService = MockConnectionService();
    mockHttpService = MockHttpService();
    dataSource = RepositoriesRemoteDataSourceImpl(
      connectionService: mockConnectionService,
      httpService: mockHttpService,
    );
    when(mockConnectionService.checkConnection()).thenAnswer((_) async {});
    when(mockConnectionService.isConnected).thenReturn(true);
  });

  void stubGet(int? statusCode, dynamic data) {
    when(
      mockHttpService.getData(
        path: anyNamed('path'),
        queryParameters: anyNamed('queryParameters'),
      ),
    ).thenAnswer(
      (_) async => (statusCode: statusCode, data: data, error: null),
    );
  }

  Future<SearchResult> search({String? sort = 'stars'}) =>
      dataSource.searchRepositories(
        query: 'flutter',
        sort: sort,
        order: 'desc',
        page: 2,
        perPage: 30,
      );

  String errorMessage(ResultPattern result) => result.fold(
    onSuccess: (_) => fail('expected error'),
    onError: (error) => (error as RepositoryException).message,
  );

  group('searchRepositories', () {
    test('returns models and sends query parameters', () async {
      stubGet(200, searchJson(total: 10, count: 2));

      final result = await search();

      expect(result, isA<SuccessResult>());
      expect((result as SuccessResult).value.items, hasLength(2));
      verify(
        mockHttpService.getData(
          path: '/search/repositories',
          queryParameters: {
            'q': 'flutter',
            'sort': 'stars',
            'order': 'desc',
            'page': 2,
            'per_page': 30,
          },
        ),
      ).called(1);
    });

    test('omits sort when null', () async {
      stubGet(200, searchJson());

      await search(sort: null);

      final captured =
          verify(
                mockHttpService.getData(
                  path: anyNamed('path'),
                  queryParameters: captureAnyNamed('queryParameters'),
                ),
              ).captured.single
              as Map<String, dynamic>;
      expect(captured.containsKey('sort'), isFalse);
    });

    test('decodes string payloads', () async {
      stubGet(200, jsonEncode(searchJson(count: 1)));

      final result = await search();

      expect((result as SuccessResult).value.items, hasLength(1));
    });

    test('returns error without connection', () async {
      when(mockConnectionService.isConnected).thenReturn(false);

      final result = await search();

      expect(errorMessage(result), 'No internet connection.');
      verifyNever(
        mockHttpService.getData(
          path: anyNamed('path'),
          queryParameters: anyNamed('queryParameters'),
        ),
      );
    });

    test('maps rate limit error', () async {
      stubGet(403, null);

      expect(errorMessage(await search()), contains('rate limit'));
    });

    test('maps invalid query error', () async {
      stubGet(422, null);

      expect(errorMessage(await search()), 'Invalid search query.');
    });

    test('maps generic error', () async {
      stubGet(500, null);

      expect(errorMessage(await search()), contains('500'));
    });

    test('handles unexpected exceptions', () async {
      when(mockConnectionService.checkConnection()).thenThrow(Exception('x'));

      expect(errorMessage(await search()), contains('Unexpected error'));
    });
  });

  group('getRepository', () {
    test('returns model', () async {
      stubGet(200, repositoryJson());

      final result = await dataSource.getRepository(
        fullName: 'flutter/flutter',
      );

      expect((result as SuccessResult).value.fullName, 'flutter/flutter');
      verify(mockHttpService.getData(path: '/repos/flutter/flutter')).called(1);
    });

    test('maps not found', () async {
      stubGet(404, null);

      final result = await dataSource.getRepository(fullName: 'a/b');

      expect(errorMessage(result), 'Repository not found.');
    });
  });
}
