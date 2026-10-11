import 'package:go_router/go_router.dart';
import 'package:app_github/src/features/repositories/presentation/routes/repositories_routes.dart';

class Routes {
  static String get home => RepositoriesRoutes.repositories;

  GoRouter get routes => _routes;

  final GoRouter _routes = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: home,
    routes: [...RepositoriesRoutes().routes],
  );
}
