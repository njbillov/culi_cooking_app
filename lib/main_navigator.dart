import 'package:flutter/material.dart';

import 'profile.dart';
import 'test_bottom_navigation.dart';
import 'theme.dart';
import 'utilities.dart';

class MainNavigator extends StatefulWidget {
  final List<Tab> tabs = <Tab>[
    Tab(text: "Crew"),
    Tab(text: "Explore"),
    Tab(text: "Me"),
    Tab(child: Profile())
  ];
  final int startIndex;

  MainNavigator({this.startIndex = 0});

  @override
  State<StatefulWidget> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    index = widget.startIndex;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {}
          });
          return Scaffold(
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: widget.tabs.map((tab) {
                return Navigator(
                  onGenerateRoute: (routeSettings) => MaterialPageRoute(
                    builder: (context) =>
                        tab.child ??
                        Scaffold(
                          appBar: AppBar(
                            title: Text("Culi Community",
                                style: Theme.of(context).textTheme.headline3),
                            centerTitle: true,
                            // bottom: TabBar(
                            //   tabs: tabs,
                            //   indicatorColor: Culi.coral,
                            //   labelStyle: Theme
                            //       .of(context)
                            //       .textTheme
                            //       .headline3
                            //       .copyWith(color: Culi.coral),
                            //   labelColor: Culi.coral,
                            //   unselectedLabelStyle: Theme
                            //       .of(context)
                            //       .textTheme
                            //       .headline3,
                            //   unselectedLabelColor: Colors.black,
                            // ),
                          ),
                          body: Center(
                              child: Column(
                            children: [
                              CuliButton(
                                "next local",
                                onPressed: () => Utils.changeScreens(
                                  context: context,
                                  nextWidget: () => TestIncrementScreen(val: 1),
                                ),
                              ),
                              CuliButton(
                                "next global",
                                onPressed: () => Utils.changeScreens(
                                    context: context,
                                    nextWidget: () =>
                                        TestIncrementScreen(val: 1),
                                    global: true),
                              ),
                            ],
                          )),
                        ),
                  ),
                );
              }).toList(),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Culi.coral,
              unselectedItemColor: Culi.black,
              items: [
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
              onTap: (index) async {
                tabController.animateTo(index,
                    duration: Duration(milliseconds: 300));
                tabController.index = index;
                await Future.delayed(Duration(milliseconds: 300));
                setState(() {
                  this.index = index;
                });
              },
              currentIndex: index,
            ),
          );
        },
      ),
    );
  }
}
