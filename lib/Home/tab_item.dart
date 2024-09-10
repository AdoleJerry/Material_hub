import 'package:flutter/material.dart';

enum TabItem {
  home,
  courses,

  account,
}

class TabitemData {
  const TabitemData(
    this.title,
    this.icon,
  );

  final String title;
  final IconData icon;

  static const Map<TabItem, TabitemData> allTabs = {
    TabItem.home: TabitemData('Home', Icons.house),
    TabItem.courses: TabitemData('Courses', Icons.book),
    TabItem.account: TabitemData('Account', Icons.person),
  };
}
