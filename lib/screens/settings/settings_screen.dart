import 'package:app_github/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  final appTitle = "Configurações";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final myTextStyle = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarLite(context, 'Configurações'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text("Tema", style: myTextStyle),
              subtitle: Text("Escolha um tema para o app."),
              leading: Icon(Icons.brightness_6, size: 28.0),
              onTap: () => Get.toNamed("/theme"),
            ),
            ListTile(
              title: Text('Sobre', style: myTextStyle),
              subtitle: Text("Sobre o app."),
              leading: Icon(Icons.error_outline, size: 28.0),
              onTap: () => {
                Get.back(),
                Get.toNamed("/about"),
              },
            ),
          ],
        ),
      ),
    );
  }
}
