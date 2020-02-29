import 'package:canknow_flutter_ui/components/applicationBottomNavigationBar/ApplicationBottomNavigationBarItem.dart';

class MenuConfig {
  static List<ApplicationBottomNavigationBarItem> bottomMenus = [
    ApplicationBottomNavigationBarItem(title: "bottomNavigation.home", icon: "home",),
    ApplicationBottomNavigationBarItem(title: "bottomNavigation.message", icon: "message",),
    ApplicationBottomNavigationBarItem(title: "bottomNavigation.picture", icon: "picture",),
    ApplicationBottomNavigationBarItem(title: "bottomNavigation.user", icon: "user" ),
  ];
}