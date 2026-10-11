import 'dart:async';

import 'package:app_github/src/common/enums/repositories_enums.dart';
import 'package:app_github/src/common/patterns/state_pattern.dart';
import 'package:app_github/src/common/state_management/state_management.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';
import 'package:app_github/src/features/repositories/presentation/view_models/repositories_state.dart';

abstract class RepositoriesViewModel
    extends StateManagement<RepositoriesState> {
  Future<void> fetchRepositories();
  Future<void> loadMore();
  Future<void> refresh();
  void onQueryChanged(String query);
  Future<void> submitQuery(String query);
  Future<void> changeSort(SortType sort, OrderType order);
  Future<void> changeLanguage(String? language);
}

class RepositoriesViewModelImpl extends RepositoriesViewModel {
  final SearchRepositoriesUseCase searchRepositoriesUseCase;
  final Duration debounceDuration;

  RepositoriesViewModelImpl({
    required this.searchRepositoriesUseCase,
    this.debounceDuration = const Duration(milliseconds: 500),
  });

  Timer? _debounce;
  int _requestId = 0;

  @override
  RepositoriesState build() => const RepositoriesState();

  @override
  Future<void> fetchRepositories() async {
    final requestId = ++_requestId;
    final params = state.params.copyWith(page: 1);
    emitState(
      state.copyWith(
        status: const LoadingState(),
        params: params,
        isLoadingMore: false,
        loadMoreError: () => null,
      ),
    );

    final result = await searchRepositoriesUseCase(params);
    if (requestId != _requestId) return;

    result.fold(
      onSuccess: (page) => emitState(
        state.copyWith(
          status: SuccessState(data: page.items),
          items: page.items,
          totalCount: page.totalCount,
          hasMore: page.hasMore,
        ),
      ),
      onError: (error) => emitState(
        state.copyWith(
          status: ErrorState(error: error),
          items: const [],
          totalCount: 0,
          hasMore: false,
        ),
      ),
    );
  }

  @override
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    if (state.status is! SuccessState) return;

    final requestId = _requestId;
    final params = state.params.copyWith(page: state.params.page + 1);
    emitState(state.copyWith(isLoadingMore: true, loadMoreError: () => null));

    final result = await searchRepositoriesUseCase(params);
    if (requestId != _requestId) return;

    result.fold(
      onSuccess: (page) {
        final items = [...state.items, ...page.items];
        emitState(
          state.copyWith(
            status: SuccessState(data: items),
            params: params,
            items: items,
            totalCount: page.totalCount,
            hasMore: page.hasMore,
            isLoadingMore: false,
          ),
        );
      },
      onError: (error) => emitState(
        state.copyWith(isLoadingMore: false, loadMoreError: () => error),
      ),
    );
  }

  @override
  Future<void> refresh() => fetchRepositories();

  @override
  void onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(debounceDuration, () => submitQuery(query));
  }

  @override
  Future<void> submitQuery(String query) async {
    _debounce?.cancel();
    if (query.trim() == state.params.query.trim() &&
        state.status is! InitialState) {
      return;
    }
    emitState(state.copyWith(params: state.params.copyWith(query: query)));
    await fetchRepositories();
  }

  @override
  Future<void> changeSort(SortType sort, OrderType order) async {
    if (sort == state.params.sort && order == state.params.order) return;
    emitState(
      state.copyWith(
        params: state.params.copyWith(sort: sort, order: order),
      ),
    );
    await fetchRepositories();
  }

  @override
  Future<void> changeLanguage(String? language) async {
    final normalized = (language?.trim().isEmpty ?? true)
        ? null
        : language!.trim();
    if (normalized == state.params.language) return;
    emitState(
      state.copyWith(params: state.params.copyWith(language: () => normalized)),
    );
    await fetchRepositories();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
