import 'package:get_it/get_it.dart';
import 'package:app_github/src/common/services/connection_service.dart';
import 'package:app_github/src/common/services/http_service.dart';
import 'package:app_github/src/features/repositories/repositories.dart';

final locator = GetIt.instance;

void dependencyInjector() {
  _startConnectionService();
  _startHttpService();
  _startFeatureRepositories();
}

void _startConnectionService() {
  locator.registerLazySingleton<ConnectionService>(
    () => ConnectionServiceImpl(),
  );
}

void _startHttpService() {
  locator.registerLazySingleton<HttpService>(() => HttpServiceImpl());
}

void _startFeatureRepositories() {
  locator.registerCachedFactory<RepositoriesDataSource>(
    () => RepositoriesRemoteDataSourceImpl(
      connectionService: locator<ConnectionService>(),
      httpService: locator<HttpService>(),
    ),
  );
  locator.registerCachedFactory<RepositoriesRepository>(
    () => RepositoriesRepositoryImpl(
      dataSource: locator<RepositoriesDataSource>(),
    ),
  );
  locator.registerCachedFactory<SearchRepositoriesUseCase>(
    () => SearchRepositoriesUseCaseImpl(
      repositoriesRepository: locator<RepositoriesRepository>(),
    ),
  );
  locator.registerCachedFactory<GetRepositoryDetailUseCase>(
    () => GetRepositoryDetailUseCaseImpl(
      repositoriesRepository: locator<RepositoriesRepository>(),
    ),
  );
  locator.registerLazySingleton<RepositoriesViewModel>(
    () => RepositoriesViewModelImpl(
      searchRepositoriesUseCase: locator<SearchRepositoriesUseCase>(),
    ),
  );
  locator.registerFactory<RepositoryDetailViewModel>(
    () => RepositoryDetailViewModelImpl(
      getRepositoryDetailUseCase: locator<GetRepositoryDetailUseCase>(),
    ),
  );
}

void resetDependencies() {
  locator.reset();
}
