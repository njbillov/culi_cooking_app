import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'choose_intro_path.dart';
import 'grocery_list.dart';
import 'meal_scheduler.dart';
import 'models/menus.dart';
import 'theme.dart';
import 'utilities.dart';

class MenuHomeScreen extends StatefulWidget {
  @override
  _MenuHomeScreenState createState() => _MenuHomeScreenState();
}

class _MenuHomeScreenState extends State<MenuHomeScreen>
    with AutomaticKeepAliveClientMixin {
  final List<Tab> tabs = <Tab>[
    Tab(text: "Recipes"),
    Tab(text: "Schedule"),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final m = Provider.of<Menu>(context);
    log(m.recipes.length.toString());
    // log(m.recipes.map((e) => (e?.completed ?? false) ? 'completed' : 'not completed').join(', '));
    if (m?.recipes?.every((element) => element?.completed ?? false) ?? false) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Menu", style: Theme.of(context).textTheme.headline3),
          centerTitle: true,
        ),
        body: Center(
            child: CuliButton(
          'Create your next menu!',
          height: 75,
          onPressed: () => Utils.changeScreens(
              context: context,
              routeName: '/menu/updatepreferences',
              global: true,
              nextWidget: () => UpdateMealCountScreen()
          ),
          // onPressed: () => showCupertinoDialog(
          //     context: context,
          //     builder: (context) => CupertinoAlertDialog(
          //           title: Text('This has not been completed yet!'),
          //           content: Text("We'll get this in here soon."),
          //           actions: [
          //             CupertinoDialogAction(
          //               child: Text('Ok'),
          //               onPressed:
          //                   Navigator.of(context, rootNavigator: true).pop,
          //             )
          //           ],
          //         )),
        )),
      );
    }
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {}
          });
          return Scaffold(
            appBar: AppBar(
              title: Text("Menu", style: Theme.of(context).textTheme.headline3),
              centerTitle: true,
              bottom: TabBar(
                tabs: tabs,
                indicatorColor: Culi.coral,
                labelStyle: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: Culi.coral),
                labelColor: Culi.coral,
                unselectedLabelStyle: Theme.of(context).textTheme.headline3,
                unselectedLabelColor: Colors.black,
              ),
            ),
            body: TabBarView(
              children: tabs.map((tab) {
                if (tab.text == 'Schedule') {
                  return MealSchedulingScreen();
                } else if (tab.text == 'Recipes') {
                  return Consumer<Menu>(
                    builder: (context, menu, child) =>
                        ListView(shrinkWrap: true, children: [
                      // Container(
                      //   height: size.height * 0.05,
                      // ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ready to make',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      ...menu.recipes
                          .where((element) => !element.completed)
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 8.0),
                                child: CuliRecipeCard(
                                    isInsightGlobal: true,
                                    recipe: e,
                                    height: size.height * 0.15,
                                    recipeInsightButtonText: 'Start now',
                                    recipeInsightTap: () => Utils.changeScreens(
                                        routeName:
                                            '/recipe${e.recipeId}/gather',
                                        context: context,
                                        global: true,
                                        nextWidget: () =>
                                            GatherRecipeItemsScreen(
                                                recipe: e))),
                              ))
                          .toList(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Completed',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      ...menu.recipes
                          .where((element) => element.completed)
                          .map((e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 8.0),
                                child: Opacity(
                                  opacity: 0.5,
                                  child: CuliRecipeCard(
                                      isInsightGlobal: true,
                                      recipe: e,
                                      height: size.height * 0.15,
                                      recipeInsightButtonText: '',
                                      recipeInsightTap: () =>
                                          Utils.changeScreens(
                                              routeName:
                                                  '/recipe${e.recipeId}/gather',
                                              context: context,
                                              global: true,
                                              nextWidget: () =>
                                                  GatherRecipeItemsScreen(
                                                      recipe: e))),
                                ),
                              ))
                          .toList(),
                      Container(height: size.height * 0.05)
                    ]),
                  );
                }
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
