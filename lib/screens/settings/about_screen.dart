import 'package:app_github/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final titleStyle = TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold);
  final subTitleStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarLite(context, "Sobre"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 35),
              Text("App GitHub", style: titleStyle),
              SizedBox(height: 50),
              Text("Desenvolvido por William Franco.", style: subTitleStyle),
              SizedBox(height: 15),
              Text("williamff@outlook.com", style: subTitleStyle),
              SizedBox(height: 60),
              Image.asset(
                "assets/logo/octocat-1.png",
                fit: BoxFit.cover,
                height: 210,
                width: 210,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
