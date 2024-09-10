import 'package:flutter/material.dart';
import 'package:material_hub/Home/account_page.dart';
import 'package:material_hub/Home/courses_page.dart';
import 'package:material_hub/Home/cupertino_home_scaffold.dart';
import 'package:material_hub/Home/home_page.dart';
import 'package:material_hub/Home/tab_item.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final TabItem _selectedIndex = TabItem.home;

  Map<TabItem, WidgetBuilder> get wigetBuilders {
    return {
      TabItem.home: (_) => const HomePage(),
      TabItem.courses: (_) => const CoursesPage(),
      TabItem.account: (_) => const AccountPage(),
    };
  }

  void _onItemTapped(TabItem tabitem) {
    if (tabitem == _selectedIndex) {
      navigatorKeys[tabitem]!.currentState?.popUntil((route) => route.isFirst);
    }
  }

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.courses: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_selectedIndex]!.currentState!.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _selectedIndex,
        onSelectTab: _onItemTapped,
        widgetBuilders: wigetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
