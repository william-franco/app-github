import 'package:app_github/src/common/enums/repositories_enums.dart';
import 'package:app_github/src/common/patterns/result_pattern.dart';
import 'package:app_github/src/features/repositories/domain/entities/entities.dart';
import 'package:app_github/src/features/repositories/domain/exceptions/exceptions.dart';

typedef PageResult = ResultPattern<PageEntity, RepositoryException>;
typedef RepositoryResult = ResultPattern<RepositoryEntity, RepositoryException>;

abstract interface class RepositoriesRepository {
  Future<PageResult> searchRepositories({
    required String query,
    SortType sort,
    OrderType order,
    required int page,
    required int perPage,
  });

  Future<RepositoryResult> getRepository({required String fullName});
}
