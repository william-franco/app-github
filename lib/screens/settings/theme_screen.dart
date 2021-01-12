import 'package:app_github/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeScreen extends StatefulWidget {
  final appTitle = "Tema";

  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  ThemeMode _themeMode;

  @override
  Widget build(BuildContext context) {
    _themeMode = ThemeController.to.themeMode;
    print('${MediaQuery.of(context).platformBrightness}');
    print('${Theme.of(context).brightness}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.appTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 22),
            Text(
              'Seleciona o tema',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 5),
            RadioListTile(
              title: Text('Sistema'),
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: (value) {
                setState(() {
                  _themeMode = value;
                  ThemeController.to.setThemeMode(_themeMode);
                });
              },
            ),
            RadioListTile(
              title: Text('Escuro'),
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: (value) {
                setState(() {
                  _themeMode = value;
                  ThemeController.to.setThemeMode(_themeMode);
                });
              },
            ),
            RadioListTile(
              title: Text('Claro'),
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: (value) {
                setState(() {
                  _themeMode = value;
                  ThemeController.to.setThemeMode(_themeMode);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
