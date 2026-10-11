import 'package:go_router/go_router.dart';
import 'package:app_github/src/common/dependency_injectors/dependency_injector.dart';
import 'package:app_github/src/features/repositories/domain/domain.dart';
import 'package:app_github/src/features/repositories/presentation/view_models/view_models.dart';
import 'package:app_github/src/features/repositories/presentation/views/views.dart';

class RepositoriesRoutes {
  static String get repositories => '/repositories';
  static String get repositoryDetail => '/repository-detail';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: repositories,
      builder: (context, state) => RepositoriesView(
        repositoriesViewModel: locator<RepositoriesViewModel>(),
      ),
    ),
    GoRoute(
      path: repositoryDetail,
      builder: (context, state) => RepositoryDetailView(
        repository: state.extra as RepositoryEntity,
        viewModel: locator<RepositoryDetailViewModel>(),
      ),
    ),
  ];
}
