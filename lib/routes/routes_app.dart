import 'package:get/get.dart';

// routes
import 'package:app_github/screens/intro/splash_screen.dart';
import 'package:app_github/screens/intro/intro_screen.dart';
import 'package:app_github/screens/home_screen.dart';
import 'package:app_github/screens/settings/about_screen.dart';
import 'package:app_github/screens/settings/settings_screen.dart';
import 'package:app_github/screens/settings/theme_screen.dart';

class RoutesApp {
  static final animation = Transition.cupertino;

  static final myRoutes = [
    GetPage(name: '/', page: () => SplashScreen(), transition: animation),
    GetPage(name: '/intro', page: () => IntroScreen(), transition: animation),
    GetPage(name: '/home', page: () => HomeScreen(), transition: animation),
    GetPage(
      name: '/settings',
      page: () => SettingsScreen(),
      transition: animation,
    ),
    GetPage(name: '/theme', page: () => ThemeScreen(), transition: animation),
    GetPage(name: '/about', page: () => AboutScreen(), transition: animation)
    // GetPage(name: '/notfound', page: () => ErrorPage(), transition: animation),
  ];
}
