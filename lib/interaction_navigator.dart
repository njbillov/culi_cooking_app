import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'choose_intro_path.dart';
import 'groceries.dart';
import 'grocery_list.dart';
import 'image_picker_example.dart';
import 'menu_home.dart';
import 'models/account.dart';
import 'models/menus.dart';
import 'models/notification_payload.dart';
import 'models/recipe.dart';
import 'models/survey/choose_many.dart';
import 'models/survey/choose_one.dart';
import 'models/survey/free_response.dart';
import 'models/survey/star_rating.dart';
import 'models/survey/survey.dart';
import 'models/survey/yes_no.dart';
import 'navigation_bar_helpers.dart';
import 'notification_handlers.dart';
import 'profile.dart';
import 'recipe_overview.dart';
import 'signup_form.dart';
import 'signup_introduction.dart';
import 'social.dart';
import 'survey.dart';
import 'test_bottom_navigation.dart';
import 'test_db_caching.dart';
import 'test_screen.dart';
import 'theme.dart';
import 'upload_test.dart';
import 'utilities.dart';

/// A debugging interface to check how individual features work.
class InteractionNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final survey = Survey();
    final starRating = StarRating(
        title: "How much did you like the meal?",
        leftHint: 'did not like',
        rightHint: 'excellent');

    final chooseOne = ChooseOne(
        title: 'What was your favorite part of the meal?',
        options: ['chicken', 'tomato', 'mozzarella']);

    final yesNo = YesNo(
      title: 'Do you think we provide value to your kitchen?',
    );

    final freeResponse =
        FreeResponse(title: "What as your favorite part of the experience?");

    final chooseMany = ChooseMany(
        title: 'Which Ingredients do you think you would use again?',
        options: ['chicken', 'tomato', 'mozzarella']);

    survey.questions
        .addAll([starRating, chooseOne, yesNo, freeResponse, chooseMany]);

    return Scaffold(
        body: SafeArea(
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            CuliButton(
              "NEW SIGNUP SCREEN",
              onPressed: () => Utils.changeScreens(
                  context: context, nextWidget: () => NewSignupIntroduction()),
            ),
            CuliButton(
              "POST SIGNUP SCREEN",
              onPressed: () => Utils.changeScreens(
                  context: context, nextWidget: () => ChooseIntroStarter()),
            ),
            CuliButton(
              "GROCERY INTRO",
              onPressed: () => Utils.changeScreens(
                  context: context, nextWidget: () => GroceryIntro()),
            ),
            CuliButton(
              "SOCIAL INTRO",
              onPressed: () => Utils.changeScreens(
                  context: context, nextWidget: () => SocialIntro()),
            ),
            CuliButton(
              "CHEF NEXT",
              onPressed: () => Utils.changeScreens(
                  context: context, nextWidget: () => ChooseIntroStarter2()),
            ),
            Consumer<Account>(
              builder: (context, account, child) =>
                  CuliButton("RECIPE FINISHED", onPressed: () async {
                final recipe = await account.getRecipe(1);
                Utils.changeScreens(
                    context: context,
                    routeName: 'recipe/${recipe.recipeId}/finished',
                    nextWidget: () => RecipeFinishedScreen(recipe: recipe));
              }),
            ),
            CuliButton(
              "OLD SIGNUP SCREEN",
              onPressed: () => Utils.changeScreens(
                  context: context, nextWidget: () => SignupSkills()),
            ),
            // CuliButton(
            //   "RECIPE OVERVIEW",
            //   onPressed: () => Utils.changeScreens(
            //       context: context,
            //       nextWidget: () => RecipeOverview(Recipe )),
            // ),
            CuliButton(
              "TEST SCREEN",
              onPressed: () => Utils.changeScreens(
                  context: context, nextWidget: () => TestScreen()),
            ),
            CuliButton(
              "PROFILE",
              onPressed: () => Utils.changeScreens(
                  context: context, nextWidget: () => Profile()),
            ),
            CuliButton(
              "TEST UPLOAD",
              onPressed: () => Utils.changeScreens(
                  context: context, nextWidget: () => UploadTestScreen()),
            ),
            CuliButton(
              "BOTTOM NAVIGATION STATE",
              onPressed: () => Utils.changeScreens(
                context: context,
                nextWidget: () => TestBottomNavigation(),
                squash: true,
              ),
            ),
            CuliButton(
              "TEST SURVEY PAGE",
              onPressed: () => Utils.changeScreens(
                context: context,
                nextWidget: () => TestMultiQuestionSurvey(),
                routeName: '/survey/0',
              ),
            ),
            CuliButton(
              "IMAGE PICKER EXAMPLE",
              onPressed: () => Utils.changeScreens(
                context: context,
                nextWidget: () => ImagePickerExample(),
              ),
            ),
            CuliButton("MAIN NAVIGATOR",
                onPressed: () => Utils.changeScreens(
                    context: context,
                    nextWidget: () => NavigationRoot(
                          title: '/menu',
                        ),
                    routeName: "/")),
            CuliButton("TEST DATABASE CACHE",
                onPressed: () => Utils.changeScreens(
                    context: context,
                    nextWidget: () => TestDatabaseCachingScreen(),
                    routeName: "/databasecachetest")),
            CuliButton("LOGIN SCREEN",
                onPressed: () => Utils.changeScreens(
                    context: context,
                    nextWidget: () => LoginScreen(),
                    routeName: "/login")),
            Consumer<Menu>(
              builder: (context, menu, child) => CuliButton(
                "CLEAR MENU",
                onPressed: () async {
                  menu.recipes = <Recipe>[];
                  menu.index = 0;
                  await menu.purge();
                },
              ),
            ),
            Consumer<Menus>(
              builder: (context, menus, child) => CuliButton(
                'CLEAR MENUS',
                onPressed: () async {
                  menus.menus = <Menu>[];
                  await menus.purge();
                },
              ),
            ),
            // CuliButton("GROCERY LIST",
            //     onPressed: () => Utils.changeScreens(
            //         context: context,
            //         nextWidget: () => GroceryListScreen(
            //                 groceryList: GroceryList(
            //                     groceries: [
            //               'Fresh Ginger',
            //               'Fresh Garlic',
            //               '1 Head of Broccoli',
            //               '2 Chicken Thighs',
            //               'Red Chili Flakes',
            //               'Salt',
            //               'Pepper',
            //               'Olive Oil',
            //               'Honey',
            //               'Soy Sauce'
            //             ]
            //                         .map((e) => Ingredient(
            //                             quantity: 1,
            //                             quantityObtained: 0,
            //                             name: e,
            //                             unit: "Unit"))
            //                         .toList())),
            //         routeName: "/list")),
            CuliButton(
              "CREATE NOTIFICATION",
              onPressed: () => NotificationHandler.showNotification(
                  offset: Duration(seconds: 1),
                  payload: NotificationPayload(
                      type: NotificationType.mealTime,
                      title: "It's time to eat!",
                      body:
                          "Click in when you're ready to come to the kitchen!",
                      payload: survey.toJsonString())),
            ),
            CuliButton(
              "TIME SELECTION SCREEN",
              onPressed: () => Utils.changeScreens(
                  context: context,
                  nextWidget: () => MenuHomeScreen(),
                  routeName: '/menu'),
            ),
            Consumer<Account>(
                builder: (context, account, child) =>
                    CuliButton('SELECT MEAL SCREEN', onPressed: () async {
                      final recipe = await account.getRecipe(1);
                      log('${recipe.equipment}');
                      Utils.changeScreens(
                          context: context,
                          nextWidget: () =>
                              GatherRecipeItemsScreen(recipe: recipe));
                    }))
          ],
        ),
      )),
    ));
  }
}
