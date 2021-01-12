import 'package:flutter/material.dart';

Widget getAppAbar(BuildContext context, String title, {List<Widget> actions, bool isSearch}) {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    leading: IconButton(
      icon: Icon(isSearch == true ? Icons.close : Icons.keyboard_arrow_left,
          size: 40.0),
      onPressed: () {
        Navigator.pop(context, null);
      },
    ),
    centerTitle: true,
    title: Text(title),
    actions: actions,
  );
}

// appbar with action button
Widget appBarWithAction(BuildContext context, String title, {List<Widget> actions}) {
  return AppBar(
    centerTitle: true,
    title: Text(title),
    actions: actions
  );
}

// appbar that show only the title
Widget appBarLite(BuildContext context, String title) {
  return AppBar(
    centerTitle: true,
    title: Text(title),
  );
}
