import 'dart:ffi';

import 'package:app/CuliSlider.dart';
import 'package:app/HorizontalCardList.dart';
import 'package:app/InteractionNavigator.dart';
import 'package:app/TitledTextField.dart';
import 'package:app/Utilities.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'SignupForm.dart';
import 'Theme.dart';

class NewSignupIntroduction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(37.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Culi", style: Theme.of(context).textTheme.headline1),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 156,
                    child: Text("Welcome to\nCuli", style: Theme.of(context).textTheme.headline2, maxLines: 2)
                  ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 206,
                  child: Text("Learning how to cook one night at a time.", style: Theme.of(context).textTheme.bodyText1, maxLines: 2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: CuliButton(
                  "Sign in",
                  width: 149,
                  height: 50,
                  onPressed: () => CuliUtils.changeScreens(context: context, nextWidget: () => Onboarding1()),
                ),
              )
            ]
          ),
        ),
      )
    );
  }
}

class Onboarding1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Culi", style:Theme.of(context).textTheme.headline1.copyWith(fontSize: 36)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("We believe doing\n is the best way\nto learn.",
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2.copyWith(fontSize: 27),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 36),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo.png"),
                        fit: BoxFit.contain
                      ),
                    )
                  )
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("That's why we are here to guide\n"
                       "you through your personalized\n"
                       "meals, helping you learn and\neat.",
                    maxLines: 4,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.10,
                    width: 2.5,
                    decoration: BoxDecoration(
                      color: Colors.black
                    ),
                  )
                ),
                CuliButton("Get Started",
                  onPressed: () => CuliUtils.changeScreens(context: context, nextWidget: () => Onboarding2()),
                  height: 55,
                  width: 155,
                )
              ]
            )
          )
        )
    );
  }

}

class Onboarding2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(
                  children: <Widget>[
                    HorizontalCardList(
                      height: MediaQuery.of(context).size.height * 0.73,
                      children: <Widget>[
                        InformationalCardView(
                            headerText: "Each week, we plan out your\npersonalized meals and send you a\ncomprehensive grocery list. This way\nyou can choose where, when, and\n how to do your shopping",
                            bodyText: "This way you can choose where, when, and how\nyou do your shopping",
                        ),
                        InformationalCardView(
                            headerText: "Our unique AI plans menus that\noverlap in fresh produce, so by the\nend of the week, you'll be left with\n zero waste.",
                            bodyText: "No more bell peppers to the garbage"
                        ),
                        InformationalCardView(
                            headerText: "We walk you through everything\nstep-by-step, leaving no room for\ndoubt. The more you cook with us,\nthe more you'll learn.",
                            bodyText: "You're not just getting dinner, you're gaining\nskills in the process."
                        ),
                        InformationalCardView(
                            headerText: "Now we just need your skill level and\ncooking preferences!",
                            bodyText: "You'll be cooking with us in no time!"
                        ),
                      ]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CuliButton("Get Started",
                        onPressed: () => CuliUtils.changeScreens(
                          context: context,
                          nextWidget: () => SignupForm1(),
                        ),
                        height: 55,
                        width: 155),
                    )
                  ],
                )
            )
        )
    );
  }
}

class SignupForm1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Culi", style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 27)),
        shadowColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CuliProgressBar(progress:0.25),
            Container(
              height: height * 0.05,
            ),
            Container(
              height: height * 0.10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "What are your current\ncooking skills like?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                height: height * 0.05,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/ChefHat.png"),
                    fit: BoxFit.fitHeight,
                  ),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: CuliCheckbox("Afraid of my kitchen", selected: true),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: CuliCheckbox("Eggs and microwave, that's all"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: CuliCheckbox("Few meals in the rotation", selected: false),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: CuliCheckbox("I can freestyle", selected: false),
            ),
            CuliButton(
              "Next Screen",
              onPressed: () => CuliUtils.changeScreens(context: context, nextWidget: () => SignupForm2()),
            ),
          ]
        ),
      ),
    );
  }
}

class SignupForm2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Culi", style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 27)),
          shadowColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            CuliProgressBar(progress:0.5),
            Container(
              height: height * 0.05,
            ),
            Container(
              height: height * 0.10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "How many nights a week\ndo you want to cook?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                  height: height * 0.05,
                  width: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/big_pan.png"),
                      fit: BoxFit.fitHeight,
                    ),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CuliSlider(
                sliderUpdate: (value) => value,
                min: 1,
                max: 5,
              ),
            ),
            CuliButton(
              "Next Screen",
              onPressed: () => CuliUtils.changeScreens(context: context, nextWidget: () => SignupForm3()),
            ),
          ],
        )
      ),
    );
  }
}


class SignupForm3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Culi", style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 27)),
        shadowColor: Colors.white,
      ),
      body: Center(
      child: Column(
        children: <Widget>[
          CuliProgressBar(progress:0.75),
          Container(
            height: height * 0.05,
          ),
          Container(
            height: height * 0.10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Would you like leftovers",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2,
               ),
             ),
            ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
                height: height * 0.05,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/ChefHat.png"),
                    fit: BoxFit.fitHeight,
                  ),
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: CuliCheckbox("Count me in!", selected: true),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: CuliCheckbox("No, thank you", selected: false),
          ),
          CuliButton(
            "Next Screen",
            onPressed: () => CuliUtils.changeScreens(context: context, nextWidget: () => SignupForm4()),
          ),
          ],
        )
      )
    );
  }
}

class SignupForm4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("Culi", style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 27)),
          shadowColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CuliProgressBar(progress: 1),
              Container(
                height: height * 0.05,
              ),
              Container(
                height: height * 0.10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Now all you have to do is\nsave your preferences and\nget started!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TitledTextField("Name"),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TitledTextField("Email"),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TitledTextField("Password"),
              ),
            CuliButton(
                "Create Account",
                onPressed: () => CuliUtils.changeScreens(
                    context: context,
                    nextWidget: () => InteractionNavigator(),
                    squash: true
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}



class SignupIntroduction extends StatelessWidget {
  final insets = EdgeInsets.all(8.0);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(size);
    var height = size.height;
    var width = size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Salus",
          style: Theme.of(context).textTheme.headline2,
        ),
        backgroundColor: Colors.transparent,
        toolbarOpacity: 0.0,
        shadowColor: Colors.transparent,
        ),
      body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: height * 0.6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/keto_avocado_bowl.jpeg"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
               HorizontalCardList(
                   children: [
                    InformationalCardView(
                        headerText: "Learning how to cook one night at a time.",
                        bodyText: "We believe doing is the best way to learn. So we're here to help you do, and when you do, you learn. And you eat! Win win win.",
                    ),
                   InformationalCardView(
                       headerText: "Reduce waste through smart shopping.",
                       bodyText: "We tell you exactly what you'll need at the beginning of each week, so there's no more guessing at the grocery store and subsequent trashing later.",
                   ),
                   InformationalCardView(
                       headerText: "Save money through meal planning.",
                       bodyText: "Salus has your meals planned before the week even begins. No more stressing over how or what to make for dinner.  Just follow our lead.",
                   ),
               ]),
              SizedBox(height: 25),
              Divider(thickness: 1, color: Colors.grey, height: 1,),
              SizedBox(height: 12),
              SizedBox(
                width: 229,
                height: 48,
                child: FlatButton(
                  color: Culi.green,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupSkills(),
                      )
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Culi.green, style: BorderStyle.solid),
                  ),
                  child: Text("GET STARTED",  style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.white)),
                )
              )
             ]
          ),
      ),
    );

  }

}

class InformationalCardView extends StatelessWidget {
  final String headerText;
  final String bodyText;

  const InformationalCardView({Key key, @required this.headerText, @required this.bodyText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Column(
          children: [
            Container(
              height: height * 0.15,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  headerText,
                  style: Culi.textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              width: width,
              height: height * 0.5,
              decoration: BoxDecoration(),
            ),
            Container(
              height: height * 0.05,
              child: Text(
                bodyText,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center
              ),
            ),
          ],
        ),
      ],
    );
  }
}