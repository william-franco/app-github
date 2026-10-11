import 'package:app_github/src/common/constants/api_constant.dart';
import 'package:app_github/src/common/patterns/result_pattern.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';

abstract interface class SearchRepositoriesUseCase {
  Future<PageResult> call(SearchParamsEntity params);
}

class SearchRepositoriesUseCaseImpl implements SearchRepositoriesUseCase {
  final RepositoriesRepository repositoriesRepository;

  SearchRepositoriesUseCaseImpl({required this.repositoriesRepository});

  @override
  Future<PageResult> call(SearchParamsEntity params) async {
    if (params.page < 1) {
      return const ErrorResult(error: RepositoryException('Invalid page.'));
    }

    return repositoriesRepository.searchRepositories(
      query: buildQuery(params),
      sort: params.sort,
      order: params.order,
      page: params.page,
      perPage: ApiConstant.perPage,
    );
  }

  static String buildQuery(SearchParamsEntity params) {
    final terms = <String>[];
    final query = params.query.trim();
    terms.add(query.isEmpty ? ApiConstant.defaultQuery : query);

    final language = params.language?.trim();
    if (language != null && language.isNotEmpty) {
      terms.add(
        'language:${language.contains(' ') ? '"$language"' : language}',
      );
    }
    return terms.join(' ');
  }
}
