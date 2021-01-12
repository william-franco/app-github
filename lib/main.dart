import 'package:app_github/controllers/theme_controller.dart';
import 'package:app_github/routes/routes_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.lazyPut<ThemeController>(() => ThemeController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeController.to.getThemeModeFromPreferences();
    return GetMaterialApp(
      title: 'App GitHub',
      theme: ThemeData.light().copyWith(primaryColor: Colors.cyan),
      darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.purple),
      initialRoute: '/',
      getPages: RoutesApp.myRoutes,
    );
  }
}
