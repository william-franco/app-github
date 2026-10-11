import 'package:flutter/material.dart';
import 'package:app_github/src/common/dependency_injectors/dependency_injector.dart';
import 'package:app_github/src/common/design/theme_design.dart';
import 'package:app_github/src/common/routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  dependencyInjector();
  final Routes appRoutes = Routes();
  runApp(MyApp(appRoutes: appRoutes));
}

class MyApp extends StatelessWidget {
  final Routes appRoutes;

  const MyApp({super.key, required this.appRoutes});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GitHub Repos',
      debugShowCheckedModeBanner: false,
      theme: ThemeDesign.light,
      darkTheme: ThemeDesign.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRoutes.routes,
    );
  }
}
