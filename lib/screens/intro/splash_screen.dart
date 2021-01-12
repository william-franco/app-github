import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      // Caso não seja a primeira vez que o app foi aberto, página inicial.
      Get.offNamed("/home");
    } else {
      prefs.setBool('seen', true);
      // Caso seja a primeira vez que o app foi aberto, slide apresentação.
      Get.offNamed("/intro");
    }
  }

  @override
  void initState() {
    super.initState();
    _checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}
