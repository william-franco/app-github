import 'dart:math';

import 'package:app_github/src/common/constants/api_constant.dart';
import 'package:app_github/src/common/enums/repositories_enums.dart';
import 'package:app_github/src/common/patterns/result_pattern.dart';
import 'package:app_github/src/features/repositories/data/data_sources/data_sources.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';

class RepositoriesRepositoryImpl implements RepositoriesRepository {
  final RepositoriesDataSource dataSource;

  RepositoriesRepositoryImpl({required this.dataSource});

  @override
  Future<PageResult> searchRepositories({
    required String query,
    SortType sort = SortType.bestMatch,
    OrderType order = OrderType.desc,
    required int page,
    required int perPage,
  }) async {
    final result = await dataSource.searchRepositories(
      query: query,
      sort: sort.apiValue,
      order: order.apiValue,
      page: page,
      perPage: perPage,
    );

    return result.fold<PageResult>(
      onSuccess: (search) {
        final reachable = min(search.totalCount, ApiConstant.maxResults);
        return SuccessResult(
          value: PageEntity(
            items: search.items,
            totalCount: search.totalCount,
            page: page,
            hasMore: search.items.isNotEmpty && page * perPage < reachable,
          ),
        );
      },
      onError: (error) => ErrorResult(error: error),
    );
  }

  @override
  Future<RepositoryResult> getRepository({required String fullName}) async {
    final result = await dataSource.getRepository(fullName: fullName);

    return result.fold<RepositoryResult>(
      onSuccess: (repository) => SuccessResult(value: repository),
      onError: (error) => ErrorResult(error: error),
    );
  }
}
