import 'dart:convert';

import 'package:app_github/src/common/constants/api_constant.dart';
import 'package:app_github/src/common/patterns/result_pattern.dart';
import 'package:app_github/src/common/services/connection_service.dart';
import 'package:app_github/src/common/services/http_service.dart';
import 'package:app_github/src/features/repositories/data/data_sources/repositories_data_source.dart';
import 'package:app_github/src/features/repositories/data/models/models.dart';
import 'package:app_github/src/features/repositories/domain/exceptions/exceptions.dart';

class RepositoriesRemoteDataSourceImpl implements RepositoriesDataSource {
  final ConnectionService connectionService;
  final HttpService httpService;

  RepositoriesRemoteDataSourceImpl({
    required this.connectionService,
    required this.httpService,
  });

  @override
  Future<SearchResult> searchRepositories({
    required String query,
    String? sort,
    required String order,
    required int page,
    required int perPage,
  }) {
    return _get(
      path: ApiConstant.searchRepositories,
      queryParameters: {
        'q': query,
        'sort': ?sort,
        'order': order,
        'page': page,
        'per_page': perPage,
      },
      parse: SearchResultModel.fromJson,
    );
  }

  @override
  Future<RepositoryModelResult> getRepository({required String fullName}) {
    return _get(
      path: ApiConstant.repository(fullName),
      parse: RepositoryModel.fromJson,
    );
  }

  Future<ResultPattern<T, RepositoryException>> _get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic> json) parse,
  }) async {
    try {
      await connectionService.checkConnection();

      if (!connectionService.isConnected) {
        return const ErrorResult(
          error: RepositoryException('No internet connection.'),
        );
      }

      final result = await httpService.getData(
        path: path,
        queryParameters: queryParameters,
      );

      if (result.statusCode == 200 && result.data != null) {
        final Map<String, dynamic> data = result.data is String
            ? jsonDecode(result.data) as Map<String, dynamic>
            : result.data as Map<String, dynamic>;
        return SuccessResult(value: parse(data));
      }

      return ErrorResult(error: _mapStatusCode(result.statusCode));
    } catch (error) {
      return ErrorResult(
        error: RepositoryException('Unexpected error: $error'),
      );
    }
  }

  RepositoryException _mapStatusCode(int? statusCode) {
    return switch (statusCode) {
      403 || 429 => const RepositoryException(
        'API rate limit exceeded. Please wait a minute and try again.',
      ),
      404 => const RepositoryException('Repository not found.'),
      422 => const RepositoryException('Invalid search query.'),
      _ => RepositoryException('Request failed. API code: $statusCode'),
    };
  }
}
