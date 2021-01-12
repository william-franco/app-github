import 'package:app_github/screens/settings/settings_screen.dart';
import 'package:app_github/screens/user/user_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  final appTitle = "App GitHub";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  PageController pageController;
  int _selectedIndex = 0;

  // pages
  List<Widget> pages = [];

  // bottom menu
  final List<TitledNavigationBarItem> items = [
    TitledNavigationBarItem(title: Text('Inicio'), icon: Icons.home),
    TitledNavigationBarItem(title: Text('Configurações'), icon: Icons.settings),
  ];

  @override
  void initState() {
    super.initState();

    pageController = new PageController(
      keepPage: true,
    );

    pages = <Widget>[
      UserListScreen(),
      SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: pages,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: TitledBottomNavigationBar(
        items: items,
        reverse: true,
        curve: Curves.easeInBack,
        inactiveColor: Colors.blueGrey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          pageController.jumpToPage(index);
        },
      ),
    );
  }
}
