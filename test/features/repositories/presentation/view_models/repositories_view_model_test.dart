import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:app_github/src/common/enums/repositories_enums.dart';
import 'package:app_github/src/common/patterns/result_pattern.dart';
import 'package:app_github/src/common/patterns/state_pattern.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';
import 'package:app_github/src/features/repositories/presentation/view_models/view_models.dart';

import '../../repositories_fixtures.dart';
import '../../repositories_mocks.mocks.dart';

void main() {
  setUpAll(registerDummies);

  late RepositoriesViewModelImpl viewModel;
  late MockSearchRepositoriesUseCase mockUseCase;
  late List<SearchParamsEntity> requested;

  setUp(() {
    requested = [];
    mockUseCase = MockSearchRepositoriesUseCase();
    viewModel = RepositoriesViewModelImpl(
      searchRepositoriesUseCase: mockUseCase,
      debounceDuration: const Duration(milliseconds: 10),
    );
    when(mockUseCase(any)).thenAnswer((invocation) async {
      final params = invocation.positionalArguments.first as SearchParamsEntity;
      requested.add(params);
      return SuccessResult(value: pageEntity(page: params.page));
    });
  });

  tearDown(() => viewModel.dispose());

  SearchParamsEntity lastParams() => requested.last;

  test('initial state', () {
    expect(viewModel.state.status, isA<InitialState>());
    expect(viewModel.state.items, isEmpty);
  });

  test('fetchRepositories emits loading then success', () async {
    final statuses = <Type>[];
    viewModel.addListener(
      () => statuses.add(viewModel.state.status.runtimeType),
    );

    await viewModel.fetchRepositories();

    expect(statuses.first.toString(), startsWith('LoadingState'));
    expect(viewModel.state.status, isA<SuccessState>());
    expect(viewModel.state.items, hasLength(2));
    expect(viewModel.state.totalCount, 100);
    expect(viewModel.state.hasMore, isTrue);
  });

  test('fetchRepositories emits error', () async {
    when(mockUseCase(any)).thenAnswer(
      (_) async => const ErrorResult(error: RepositoryException('boom')),
    );

    await viewModel.fetchRepositories();

    final status = viewModel.state.status;
    expect(status, isA<ErrorState>());
    expect(
      ((status as ErrorState).error as RepositoryException).message,
      'boom',
    );
  });

  group('loadMore', () {
    test('appends next page', () async {
      await viewModel.fetchRepositories();
      await viewModel.loadMore();

      expect(viewModel.state.items, hasLength(4));
      expect(viewModel.state.params.page, 2);
      expect(lastParams().page, 2);
    });

    test('does nothing when there is no more data', () async {
      when(mockUseCase(any)).thenAnswer(
        (_) async => SuccessResult(value: pageEntity(hasMore: false)),
      );
      await viewModel.fetchRepositories();
      clearInteractions(mockUseCase);

      await viewModel.loadMore();

      verifyNever(mockUseCase(any));
    });

    test('does nothing before first load', () async {
      await viewModel.loadMore();

      verifyNever(mockUseCase(any));
    });

    test('keeps items and exposes error on failure', () async {
      await viewModel.fetchRepositories();
      when(mockUseCase(any)).thenAnswer(
        (_) async => const ErrorResult(error: RepositoryException('fail')),
      );

      await viewModel.loadMore();

      expect(viewModel.state.items, hasLength(2));
      expect(viewModel.state.loadMoreError?.message, 'fail');
      expect(viewModel.state.isLoadingMore, isFalse);
      expect(viewModel.state.params.page, 1);
    });

    test('ignores concurrent calls', () async {
      await viewModel.fetchRepositories();
      clearInteractions(mockUseCase);
      final completer = Completer<PageResult>();
      when(mockUseCase(any)).thenAnswer((_) => completer.future);

      final first = viewModel.loadMore();
      await viewModel.loadMore();
      completer.complete(SuccessResult(value: pageEntity(page: 2)));
      await first;

      verify(mockUseCase(any)).called(1);
    });

    test('discards stale page after new search', () async {
      await viewModel.fetchRepositories();
      final completer = Completer<PageResult>();
      when(mockUseCase(any)).thenAnswer((_) => completer.future);
      final pending = viewModel.loadMore();

      when(mockUseCase(any))
          .thenAnswer((_) async => SuccessResult(value: pageEntity(count: 1)));
      await viewModel.submitQuery('dart');
      completer.complete(SuccessResult(value: pageEntity(page: 2)));
      await pending;

      expect(viewModel.state.items, hasLength(1));
      expect(viewModel.state.params.query, 'dart');
    });
  });

  test('submitQuery resets to first page', () async {
    await viewModel.fetchRepositories();
    await viewModel.loadMore();

    await viewModel.submitQuery('riverpod');

    expect(lastParams().query, 'riverpod');
    expect(lastParams().page, 1);
    expect(viewModel.state.items, hasLength(2));
  });

  test('submitQuery ignores same query', () async {
    await viewModel.submitQuery('bloc');
    clearInteractions(mockUseCase);

    await viewModel.submitQuery(' bloc ');

    verifyNever(mockUseCase(any));
  });

  test('onQueryChanged debounces', () async {
    viewModel.onQueryChanged('f');
    viewModel.onQueryChanged('fl');
    viewModel.onQueryChanged('flutter');
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final captured = verify(mockUseCase(captureAny)).captured;
    expect(captured, hasLength(1));
    expect((captured.single as SearchParamsEntity).query, 'flutter');
  });

  test('changeSort refetches with new sort', () async {
    await viewModel.changeSort(SortType.stars, OrderType.asc);

    expect(lastParams().sort, SortType.stars);
    expect(lastParams().order, OrderType.asc);
  });

  test('changeSort ignores same values', () async {
    await viewModel.changeSort(SortType.bestMatch, OrderType.desc);

    verifyNever(mockUseCase(any));
  });

  test('changeLanguage sets and clears filter', () async {
    await viewModel.changeLanguage('Dart');
    expect(lastParams().language, 'Dart');

    await viewModel.changeLanguage(null);
    expect(viewModel.state.params.language, isNull);
  });

  test('refresh refetches first page', () async {
    await viewModel.fetchRepositories();
    await viewModel.loadMore();

    await viewModel.refresh();

    expect(lastParams().page, 1);
    expect(viewModel.state.items, hasLength(2));
  });
}
