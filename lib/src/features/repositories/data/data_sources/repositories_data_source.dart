import 'package:app_github/src/common/patterns/result_pattern.dart';
import 'package:app_github/src/features/repositories/data/models/models.dart';
import 'package:app_github/src/features/repositories/domain/exceptions/exceptions.dart';

typedef SearchResult = ResultPattern<SearchResultModel, RepositoryException>;
typedef RepositoryModelResult =
    ResultPattern<RepositoryModel, RepositoryException>;

abstract interface class RepositoriesDataSource {
  Future<SearchResult> searchRepositories({
    required String query,
    String? sort,
    required String order,
    required int page,
    required int perPage,
  });

  Future<RepositoryModelResult> getRepository({required String fullName});
}
