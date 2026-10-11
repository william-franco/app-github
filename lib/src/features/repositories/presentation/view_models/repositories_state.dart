import 'package:app_github/src/common/patterns/state_pattern.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';

typedef RepositoriesStatus =
    StatePattern<List<RepositoryEntity>, RepositoryException>;

class RepositoriesState {
  final RepositoriesStatus status;
  final SearchParamsEntity params;
  final List<RepositoryEntity> items;
  final int totalCount;
  final bool hasMore;
  final bool isLoadingMore;
  final RepositoryException? loadMoreError;

  const RepositoriesState({
    this.status = const InitialState(),
    this.params = const SearchParamsEntity(),
    this.items = const [],
    this.totalCount = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  RepositoriesState copyWith({
    RepositoriesStatus? status,
    SearchParamsEntity? params,
    List<RepositoryEntity>? items,
    int? totalCount,
    bool? hasMore,
    bool? isLoadingMore,
    RepositoryException? Function()? loadMoreError,
  }) {
    return RepositoriesState(
      status: status ?? this.status,
      params: params ?? this.params,
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: loadMoreError != null
          ? loadMoreError()
          : this.loadMoreError,
    );
  }
}
