

import 'package:app/Theme.dart';
import 'package:app/Utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChooseIntroStarter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return CuliSplashImage(
      titleText: "You're in! And were excited to have\nyou.",
      imageName: "assets/images/noun_party.png",
      bodyText: "The true benefit from cooking with Culi\ncomes from repetition. If you're ready to\ndive right in, create a menu and get cooking.\nBut if it's 5pm, you need dinner on the table\nin an hour, go ahead and create a sample\nmenu to start your journey",
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
                  "Create menu",
                  width: 200,
                  height: 75,
                  onPressed: () => CuliUtils.changeScreens(
                      context: context,
                      nextWidget: () => MenuScreen1()
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: CuliButton(
                  "Sample recipe",
                  width: 200,
                  height: 75,
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
    return CuliTopImage(
      imageName: "assets/images/create_menu.png",
      contents: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Help create your first\nmenu", style: Theme.of(context).textTheme.headline2, textAlign: TextAlign.center),
        ),
        Container(
          height: 0.075 * size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/menu.png")
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Let us know which of these potential menus\nlooks better to you. The more you interact\n with the menus we offer the more\npersonalized your menus will become!",
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          )
        ),
        CuliButton("Explore", width: size.width * 0.8, height: 75),
      ]
    );
  }
}

class ChooseIntroStarter2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return CuliSplashImage(
      titleText: "Cooking with Culi is all about\nthe progress",
      imageName: "assets/images/big_noun_chef.png",
      bodyText: "Cooking is rewarding, right? Providing for\nyourself, getting that meal on your table for on\nyour own terms is exciting. But imagine being\n able to do what you did tonight in half the time.\nImagine adding a homemade sauce that makes\nyour mouth water. If you keep cooking with us,\nyou'll develop these skills without even knowing\nit.",
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
                  "Create menu",
                  width: 200,
                  height: 75,
                  onPressed: () => CuliUtils.changeScreens(
                      context: context,
                      nextWidget: () => MenuScreen1()
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: CuliButton(
                  "Sample recipe",
                  width: 200,
                  height: 75,
                  onPressed: () => CuliUtils.changeScreens(
                    context: context,
                    nextWidget: () => IntroSampleRecipes(),
                  ),
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
          child: Column(
            children: <Widget>[
              Container(
                height: size.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
                child: CuliRecipeCard(
                  height: size.height * 0.15,
                  recipeName: "Honey-Soy Chicken & Ramen",
                  imageName: "assets/images/honeysoychickenandramen.png",
                  night: "Night 1",
                  onTap: () => {
                    print("Tapped Honey-Soy Chicken & Ramen")
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
                child: CuliRecipeCard(
                  height: size.height * 0.15,
                  recipeName: "Charred Lime Steak",
                  imageName: "assets/images/charredlimesteak.png",
                  night: "Night 2",
                  onTap: () => {
                    print("Tapped Charred Lime Steak")
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
                child: CuliRecipeCard(
                  height: size.height * 0.15,
                  recipeName: "Chickpea Stew",
                  imageName: "assets/images/chickpea_stew.png",
                  night: "Night 3",
                  onTap: () => {
                    print("Tapped Chickpea Stew")
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
                child: CuliRecipeCard(
                  height: size.height * 0.15,
                  recipeName: "Egg Fried Rice",
                  imageName: "assets/images/eggfriedrice.png",
                  night: "Night 4",
                  onTap: () => {
                    print("Tapped Egg Fried Rice")
                  },
                ),
              ),
            ]
          )
        ),
      ),
    );
  }
}

