import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'culi_slider.dart';
import 'horizontal_card_list.dart';
import 'meal_scheduler.dart';
import 'models/account.dart';
import 'models/menus.dart';
import 'models/recipe.dart';
import 'navigation_bar_helpers.dart';
import 'theme.dart';
import 'utilities.dart';

class ChooseIntroStarter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CuliSplashImage(
      titleText: "You're in! And were excited to have you.",
      imageName: "assets/images/noun_party.png",
      bodyText:
          "The true benefit from cooking with Culi comes from repetition. "
          "If you're ready to dive right in, create a menu and get cooking. "
          "But if it's 5pm, you need dinner on the table in an hour, "
          "go ahead and create a sample menu to start your journey",
      contents: <Widget>[
        Container(
          height: size.height * 0.05,
        ),
        Container(
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: CuliButton(
                  "Create menu",
                  width: size.width * 0.45,
                  height: 75,
                  onPressed: () => Utils.changeScreens(
                      context: context, nextWidget: () => MenuScreen1()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Consumer<Account>(
                  builder: (context, account, child) => CuliButton(
                      "Sample recipe",
                      width: size.width * 0.45,
                      height: 75, onPressed: () async {
                    final recipes =
                        await Stream.fromIterable(Iterable.generate(4))
                            .asyncMap((event) => account.getRecipe(event + 1))
                            .toList();
                    Utils.changeScreens(
                        context: context,
                        nextWidget: () => IntroSampleRecipes(recipes: recipes));
                  }),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class MenuScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var menus = Provider.of<Menus>(context, listen: true);
    return CuliTopImage(
        imageName: "assets/images/create_menu.png",
        contents: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Help create your first menu",
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center),
          ),
          Container(
            height: 0.075 * size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/menu.png"))),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Let us know which of these potential menus looks better to you. The more you interact with the menus we offer the more personalized your menus will become!",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              )),
          Container(
            height: size.height * 0.195,
          ),
          Consumer<Account>(
            builder: (context, account, child) => CuliButton(
              "Take me in!",
              width: size.width * 0.9,
              height: 75,
              onPressed: () async {
                log('Checking to see whether to get new menus');
                if (menus?.menus?.isEmpty ?? true) {
                  log('Getting menus');

                  /// Making sure to copy all fields over
                  menus.menus = (await account.requestMenus()).menus;
                  await menus.notifyListeners();
                  log('New menus: ${menus.toJson().toString()}');
                }
                Utils.changeScreens(
                    context: context,
                    nextWidget: () => ChooseMenuScreen(),
                    squash: true,
                    routeName: '/menu/choose');
              },
            ),
          ),
        ]);
  }
}

class ChooseIntroStarter2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return CuliSplashImage(
      titleText: "Cooking with Culi is all about the progress",
      imageName: "assets/images/big_noun_chef.png",
      bodyText: "Cooking is rewarding, right? Providing for yourself, "
          "getting that meal on your table for on your own terms is exciting. "
          "But imagine being able to do what you did tonight in half the time. "
          "Imagine adding a homemade sauce that makes your mouth water. "
          "If you keep cooking with us, "
          "you'll develop these skills without even knowing it.",
      contents: <Widget>[
        Container(
          height: height * 0.05,
        ),
        Container(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: CuliButton(
                  "Home",
                  width: 200,
                  height: 75,
                  onPressed: () => Utils.changeScreens(
                      context: context, nextWidget: () => MenuScreen1()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Consumer<Account>(
                  builder: (context, account, child) =>
                      CuliButton("Sample recipe", width: 200, height: 75,
                          onPressed: () async {
                    final recipes =
                        await Stream.fromIterable(Iterable.generate(4))
                            .asyncMap((event) => account.getRecipe(event + 1))
                            .toList();
                    Utils.changeScreens(
                        context: context,
                        nextWidget: () => IntroSampleRecipes(recipes: recipes));
                  }),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class IntroSampleRecipes extends StatelessWidget {
  final List<Recipe> recipes;

  const IntroSampleRecipes({Key key, this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu", style: Theme.of(context).textTheme.headline3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
            child: Column(children: <Widget>[
          Container(
            height: size.height * 0.05,
          ),
          ...recipes
              .map(
                (e) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
                  child: CuliRecipeCard(
                    height: size.height * 0.15,
                    recipe: e,
                    isInsightGlobal: false,
                    recipeInsightButtonText: "I'm ready for my menu!",
                    recipeInsightTap: () async {
                      Utils.changeScreens(
                          context: context,
                          squash: true,
                          nextWidget: () => MenuScreen1(),
                          routeName: '/menu/intro');
                    },
                  ),
                ),
              )
              .toList(),
        ])),
      ),
    );
  }
}

class ChooseMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    log(Provider.of<Menus>(context).toJson().toString());
    return Scaffold(
        appBar: AppBar(
          title: Text("Menu", style: Theme.of(context).textTheme.headline3),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: size.height * 0.025,
                  ),
                  Consumer<Menus>(
                      builder: (context, menus, child) => HorizontalCardList(
                          height: size.height * 0.8,
                          dotsOnTop: true,
                          children: Iterable.generate(menus.menus.length)
                              .map((menuIndex) => Column(children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(1000),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal: 16.0),
                                            child: Text(
                                              "Menu #${menuIndex + 1}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  .copyWith(
                                                      fontSize: 14,
                                                      color: Culi.coral),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                    ),
                                    Container(
                                      height: size.height * 0.55,
                                      child: ListView(
                                        children: Iterable.generate(menus
                                                .menus[menuIndex]
                                                .recipes
                                                .length)
                                            .map(
                                              (recipe) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 24,
                                                        vertical: 8.0),
                                                child: CuliRecipeCard(
                                                  height: size.height * 0.15,
                                                  recipe: menus.menus[menuIndex]
                                                      .recipes[recipe],
                                                  // night: "Recipe 1",
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                    Consumer<Menu>(
                                      builder: (context, selectedMenu, child) =>
                                          CuliButton(
                                              [
                                                'Yum!',
                                                'I like this better!'
                                              ][menuIndex],
                                              height: 75,
                                              width: size.width * 0.9,
                                              color: Culi.accentBlue,
                                              onPressed: () async {
                                        log('Assigning menu');
                                        selectedMenu.copyFromJson(
                                            menus.menus[menuIndex].toJson());
                                        await selectedMenu.notifyListeners();
                                        Utils.changeScreens(
                                          context: context,
                                          nextWidget: () =>
                                              TimeSelectionScreen(),
                                          routeName: '/menu/schedule',
                                          squash: true,
                                        );
                                      }),
                                    )
                                  ]))
                              .toList())),
                ]),
          ),
        ));
  }
}

class TimeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Schedule Meals",
              style: Theme.of(context).textTheme.headline2)),
      body: SafeArea(
        child: Consumer<Menu>(
            builder: (context, menu, child) => Column(
                  children: [
                    Container(
                      height: size.height * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('When should we cook together?',
                          style: Theme.of(context).textTheme.headline2),
                    ),
                    Container(
                        height: size.height * 0.6,
                        child: ListView(
                            children:
                                Iterable.generate(menu.recipes.length).map((e) {
                          final disabled = e <
                              menu.recipes
                                  .where((e) => e?.completed ?? false)
                                  .length;
                          return IgnorePointer(
                              ignoring: disabled,
                              child: BackdropFilter(
                                  filter: disabled
                                      ? ImageFilter.blur()
                                      : ImageFilter.matrix(
                                          Matrix4.identity().storage),
                                  child: TimeSelector(day: e)));
                        }).toList())),
                    CuliButton(
                      "Continue",
                      height: 75,
                      width: size.width * 0.9,
                      onPressed: () => Utils.changeScreens(
                          context: context,
                          squash: true,
                          routeName: '/menu',
                          nextWidget: () => NavigationRoot(title: '/menu')),
                    )
                  ],
                )),
      ),
    );
  }
}

class UpdateMealCountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Update preferences",
            style: Theme.of(context).textTheme.headline3),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'How many recipes do you want this week?',
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<Account>(
                    builder: (context, account, child) => CuliSlider(
                      min: 1,
                      max: 5,
                      initialValue: account.mealsPerWeek,
                      sliderUpdate: (val) {
                        log(val.toString());
                        account.mealsPerWeek = val.round();
                      },
                    ),
                  ),
                ),
                Consumer<Menus>(
                  builder: (context, menus, child) =>
                      CuliButton('Continue', height: 75, onPressed: () async {
                    final account =
                        Provider.of<Account>(context, listen: false);
                    log('Requesting ${account.mealsPerWeek}');

                    /// Making sure to copy all fields over
                    menus.menus =
                        (await account.requestMenus(override: true)).menus;
                    await menus.notifyListeners();
                    // log('New menus: ${menus.toJson().toString()}');
                    Utils.changeScreens(
                        context: context,
                        nextWidget: () => ChooseMenuScreen(),
                        // squash: true,
                        routeName: '/menu/choose');
                  }),
                )
              ])),
        ),
      ),
    );
  }
}
