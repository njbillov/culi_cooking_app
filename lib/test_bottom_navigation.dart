import 'package:flutter/material.dart';

import 'theme.dart';
import 'utilities.dart';

class TestIncrementScreen extends StatelessWidget {
  final int val;
  final GlobalKey<NavigatorState> navigatorKey;

  const TestIncrementScreen({Key key, this.val, this.navigatorKey})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Culi Community",
            style: Theme.of(context).textTheme.headline3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("This is screen $val"),
                CuliButton("Next Screen",
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => TestIncrementScreen(
                                key: key,
                                navigatorKey: navigatorKey,
                                val: val + 1)))),
              ]),
        ),
      ),
    );
  }
}

class TestBottomNavigation extends StatefulWidget {
  final List<Tab> tabs = <Tab>[
    Tab(text: "Crew"),
    Tab(text: "Explore"),
  ];

  @override
  State<StatefulWidget> createState() => _TestBottomNavigationState();
}

class _TestBottomNavigationState extends State<TestBottomNavigation> {
  int index = 0;

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
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text("Culi Community",
                            style: Theme.of(context).textTheme.headline3),
                        centerTitle: true,
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
                                nextWidget: () => TestIncrementScreen(val: 1),
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
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.closed_caption), label: "Crew"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.explore), label: "Explore")
              ],
              onTap: (index) {
                tabController.index = index;
                tabController.animateTo(index);
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

class TestBottomNavigation2 extends StatefulWidget {
  @override
  _TestBottomNavigationState2 createState() => _TestBottomNavigationState2();
}

class _TestBottomNavigationState2 extends State<TestBottomNavigation2> {
  int _selectedRoute = 0;
  List<Widget> pageList = <Widget>[];

  @override
  void initState() {
    pageList.add(TestIncrementScreen(val: 1));
    pageList.add(TestIncrementScreen(val: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(onGenerateRoute: (settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (context) => IndexedStack(
                  index: _selectedRoute,
                  children: pageList,
                ));
      }),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.smartphone), label: "First"),
            BottomNavigationBarItem(
                icon: Icon(Icons.smartphone), label: "Second")
          ],
          currentIndex: _selectedRoute,
          selectedItemColor: Culi.coral,
          onTap: (index) {
            setState(() {
              _selectedRoute = index;
            });
          }),
    );
  }
}

class TabNavigatorRoutes {
  static const String social = '/social';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  TabNavigator({this.navigatorKey});
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MultiPathBottomNavigator extends StatefulWidget {
  // final Widget body;
  // final AppBar appBar;
  // final int startIndex;

  // const MultiPathBottomNavigator({Key key, this.body, this.appBar, this.startIndex = 0}) : super(key: key);
  @override
  _MultiPathBottomNavigatorState createState() =>
      _MultiPathBottomNavigatorState();
}

class _MultiPathBottomNavigatorState extends State<MultiPathBottomNavigator> {
  List<GlobalKey<NavigatorState>> navigatorKeys = [];
  List<WidgetBuilder> routeBuilders = [
    (context) => TestIncrementScreen(val: 0),
    (context) => TestIncrementScreen(val: 0),
  ];

  _MultiPathBottomNavigatorState({this.navigatorKeys, this.routeBuilders});

  @override
  void initState() {
    if (navigatorKeys.isEmpty) {
      navigatorKeys
          .addAll(routeBuilders.map((builder) => GlobalKey<NavigatorState>()));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
