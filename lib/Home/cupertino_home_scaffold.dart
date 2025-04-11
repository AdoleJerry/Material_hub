<<<<<<< HEAD
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_hub/Home/tab_item.dart';

class CupertinoHomeScaffold extends StatefulWidget {
  const CupertinoHomeScaffold({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
    required this.widgetBuilders,
    required this.navigatorKeys,
  });

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  _CupertinoHomeScaffoldState createState() => _CupertinoHomeScaffoldState();
}

class _CupertinoHomeScaffoldState extends State<CupertinoHomeScaffold> {
  Future<bool> _onWillPop() async {
    // If the current tab is not Home, switch to Home tab
    if (widget.currentTab != TabItem.home) {
      setState(() {
        widget.onSelectTab(TabItem.home);
      });
      return false; // Prevent the app from exiting
    } else {
      // If already on the Home tab, show the exit confirmation dialog
      return await _showExitConfirmationDialog(context) ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Intercept back button press
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            _buildItem(TabItem.home),
            _buildItem(TabItem.courses),
            _buildItem(TabItem.account),
          ],
          onTap: (index) {
            widget.onSelectTab(TabItem.values[index]);
          },
          activeColor: Colors.black,
          inactiveColor: Colors.grey,
        ),
        tabBuilder: (context, index) {
          final item = TabItem.values[index];
          return CupertinoTabView(
            navigatorKey: widget.navigatorKeys[item],
            builder: (context) => widget.widgetBuilders[item]!(context),
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabitemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(itemData!.icon),
      label: itemData.title,
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Close App'),
          content: const Text('Are you sure you want to close the app?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // Don't exit
              },
            ),
            CupertinoDialogAction(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // Exit the app
              },
            ),
          ],
        );
      },
    );
  }
}
=======
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_hub/Home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
    required this.widgetBuilders,
    required this.navigatorKeys,
  });

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            _buildItem(TabItem.home),
            _buildItem(TabItem.courses),
            _buildItem(TabItem.account),
          ],
          onTap: (index) => onSelectTab(TabItem.values[index]),
          activeColor: Colors.black,
          inactiveColor: Colors.grey,
        ),
        tabBuilder: (context, index) {
          final item = TabItem.values[index];
          return CupertinoTabView(
            navigatorKey: navigatorKeys[item],
            builder: (context) => widgetBuilders[item]!(context),
          );
        });
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabitemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(
        itemData!.icon,
      ),
      label: itemData.title,
    );
  }
}
>>>>>>> 8ddb56bed4ea68597595ff99aef8608671358442
