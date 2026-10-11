import 'package:mockito/annotations.dart';
import 'package:app_github/src/common/services/connection_service.dart';
import 'package:app_github/src/common/services/http_service.dart';
import 'package:app_github/src/features/repositories/data/data_sources/repositories_data_source.dart';
import 'package:app_github/src/features/repositories/domain/repositories/repositories_repository.dart';
import 'package:app_github/src/features/repositories/domain/use_cases/get_repository_detail_use_case.dart';
import 'package:app_github/src/features/repositories/domain/use_cases/search_repositories_use_case.dart';

@GenerateMocks([
  ConnectionService,
  HttpService,
  RepositoriesDataSource,
  RepositoriesRepository,
  SearchRepositoriesUseCase,
  GetRepositoryDetailUseCase,
])
void main() {}
