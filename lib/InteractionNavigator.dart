import 'package:app/ChooseIntroPath.dart';
import 'package:app/Groceries.dart';
import 'package:app/MenuSelection.dart';
import 'package:app/SignupForm.dart';
import 'package:app/Social.dart';
import 'package:app/Utilities.dart';
import 'package:flutter/material.dart';

import 'SignupIntroduction.dart';
import 'Theme.dart';

class InteractionNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CuliButton(
                "NEW SIGNUP SCREEN",
                onPressed: () => CuliUtils.changeScreens(
                  context: context,
                  nextWidget: () => NewSignupIntroduction()
                ),
              ),
              CuliButton(
                "POST SIGNUP SCREEN",
                onPressed: () => CuliUtils.changeScreens(
                  context: context,
                  nextWidget: () => ChooseIntroStarter()
                ),
              ),
              CuliButton(
                "GROCERY INTRO",
                onPressed: () => CuliUtils.changeScreens(
                    context: context,
                    nextWidget: () => GroceryIntro()
                ),
              ),
              CuliButton(
                "SOCIAL INTRO",
                onPressed: () => CuliUtils.changeScreens(
                    context: context,
                    nextWidget: () => SocialIntro()
                ),
              ),
              CuliButton(
                "CHEF NEXT",
                onPressed: () => CuliUtils.changeScreens(
                    context: context,
                    nextWidget: () => ChooseIntroStarter2()
                ),
              ),
              CuliButton(
                "OLD SIGNUP SCREEN",
                onPressed: () => CuliUtils.changeScreens(
                  context: context,
                  nextWidget: () => SignupSkills()
                ),
              ),
              CuliButton(
                "MENU SCREEN",
                onPressed: () => CuliUtils.changeScreens(
                    context: context,
                    nextWidget: () => MenuIntroduction()
                ),
              ),
            ],
          )
        )
    );
  }

}