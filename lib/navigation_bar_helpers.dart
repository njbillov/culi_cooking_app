import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'choose_intro_path.dart';
import 'grocery_list.dart';
import 'menu_home.dart';
import 'models/account.dart';
import 'models/menus.dart';
import 'notification_handlers.dart';
import 'profile.dart';
import 'theme.dart';

class CuliBottomNavigationBar extends StatelessWidget {
  final int index;

  CuliBottomNavigationBar(this.index);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // onTap: (tappedIndex) => {},
      selectedItemColor: Culi.black,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle:
          Theme.of(context).textTheme.bodyText1.copyWith(color: Culi.black),
      unselectedLabelStyle: Theme.of(context)
          .textTheme
          .bodyText1
          .copyWith(color: Culi.subtextGray),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.ballot_outlined),
            activeIcon: Icon(Icons.ballot),
            label: "Menu"),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: "Shop"),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: "Me"),
      ],
    );
  }
}

class NavigationRoot extends StatefulWidget {
  final String title;

  const NavigationRoot({this.title});

  @override
  _NavigationRootState createState() => _NavigationRootState();
}

class _NavigationRootState extends State<NavigationRoot> {
  Map<String, Widget Function(BuildContext)> tabs = {
    '/menu': (context) {
      final menu = Provider.of<Menu>(context);
      // log(menu.toJson().toString());
      if (menu?.recipes?.isEmpty ?? true) {
        final account = Provider.of<Account>(context);
        account.requestMenus(override: true);
        log('Going to choose menu screen');
        return ChooseMenuScreen();
      }
      log('Going to menu home screen');
      return MenuHomeScreen();
    },
    '/grocery': (context) => GroceryListScreen(),
    // '/social': (context) => SocialScreen(),
    '/profile': (context) => Profile()
  };

  int index = 0;

  @override
  void initState() {
    super.initState();
    NotificationHandler.instance.initializeHandlers(context);
    if (tabs.containsKey(widget.title)) {
      index = Iterable.generate(tabs.length)
          .firstWhere((element) => tabs.keys.toList()[element] == widget.title);
    } else {
      index = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Account>(context, listen: false);
    final menu = Provider.of<Menu>(context, listen: false);
    final menus = Provider.of<Menus>(context, listen: false);
    log("Updating menus");
    account.updateMenus(menus, menu).then((value) {
      if (value.isEmpty) return;
      showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: Text('Recipe Update'),
                content: Text(
                    'We noticed the ingredients in ${value.join(", ")} ${value.length == 1 ? "was" : "were"} incorrect, please check the shop tab for updates.'),
                actions: [
                  CupertinoDialogAction(
                    child: Text('OK'),
                    isDestructiveAction: false,
                    isDefaultAction: true,
                    onPressed: () async {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ],
              ));
      menu.notifyListeners();
    });
    ;
    return DefaultTabController(
        length: tabs.length,
        child: Builder(builder: (context) {
          final tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {}
          });
          return Scaffold(
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: tabs.values.map((tab) {
                  return Navigator(
                    onGenerateRoute: (routeSettings) =>
                        MaterialPageRoute<void>(builder: tab),
                  );
                }).toList(),
              ),
              bottomNavigationBar: BottomNavigationBar(
                onTap: (tappedIndex) => setState(() {
                  index = tappedIndex;
                  tabController.index = tappedIndex;
                }),
                selectedItemColor: Culi.black,
                unselectedItemColor: Colors.grey,
                showSelectedLabels: true,
                currentIndex: index,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Culi.black),
                unselectedLabelStyle: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Culi.subtextGray),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.ballot_outlined),
                      activeIcon: Icon(Icons.ballot),
                      label: "Menu"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart_outlined),
                      activeIcon: Icon(Icons.shopping_cart),
                      label: "Shop"),
                  // BottomNavigationBarItem(
                  //     icon: Icon(Icons.home_outlined),
                  //     activeIcon: Icon(Icons.home),
                  //     label: "Social"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle_outlined),
                      activeIcon: Icon(Icons.account_circle),
                      label: "Me"),
                ],
              ));
        }));
  }
}
