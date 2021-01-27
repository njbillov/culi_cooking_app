import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'culi_slider.dart';
import 'models/sign_up.dart';
import 'theme.dart';

class SignupSkills extends StatelessWidget {
  final SignUp signup = SignUp();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text("Skills", style: Theme.of(context).textTheme.headline3),
          backgroundColor: Colors.transparent,
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
            height: 0.015 * height,
          ),
          DotsIndicator(
            dotsCount: 3,
            position: 0.0,
            decorator: DotsDecorator(
              color: Culi.widgetInactiveColor,
              size: const Size.square(13),
              activeColor: Culi.widgetActiveColor,
              activeSize: const Size.square(16),
            ),
          ),
          Container(
            height: 0.05 * height,
          ),
          Container(
            height: 0.1 * height,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "What do your current skills allow?",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Container(
            height: height * 0.1,
            child: FractionallySizedBox(
                widthFactor: 0.885,
                child: RaisedButton(
                  child: Text("I'm genuinely afraid of my kitchen",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 18.0),
                      textAlign: TextAlign.center),
                  color: Culi.buttonBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  onPressed: () {
                    signup.level = SignUp.novice;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupFrequency(signup)));
                  },
                )),
          ),
          Container(
            height: 0.05 * height,
          ),
          Container(
            height: height * 0.1,
            child: FractionallySizedBox(
                widthFactor: 0.885,
                child: RaisedButton(
                  child: Text("I can make eggs and use my microwave",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 18.0),
                      textAlign: TextAlign.center),
                  color: Culi.buttonBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  onPressed: () {
                    signup.level = SignUp.amateur;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupFrequency(signup)));
                  },
                )),
          ),
          Container(
            height: 0.05 * height,
          ),
          Container(
            height: height * 0.1,
            child: FractionallySizedBox(
                widthFactor: 0.885,
                child: RaisedButton(
                  child: Text("I've got a few meals in my rotation",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 18.0),
                      textAlign: TextAlign.center),
                  color: Culi.buttonBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  onPressed: () {
                    signup.level = SignUp.intermediate;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupFrequency(signup)));
                  },
                )),
          ),
          Container(
            height: 0.05 * height,
          ),
          Container(
            height: height * 0.1,
            child: FractionallySizedBox(
                widthFactor: 0.885,
                child: RaisedButton(
                  child: Text("I can freestyle in the kitchen",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 18.0),
                      textAlign: TextAlign.center),
                  color: Culi.buttonBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  onPressed: () {
                    signup.level = SignUp.expert;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupFrequency(signup)));
                  },
                )),
          ),
        ])));
  }
}

class SignupFrequency extends StatelessWidget {
  final SignUp signup;

  SignupFrequency(this.signup) {
    print("Creating SignupFrequency page with ${signup.toJson()}");
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title:
              Text("Frequency", style: Theme.of(context).textTheme.headline3),
          backgroundColor: Colors.transparent,
        ),
        body: Center(
            child: Column(children: <Widget>[
          SizedBox(
            height: 0.015 * height,
          ),
          DotsIndicator(
            dotsCount: 3,
            position: 1.0,
            decorator: DotsDecorator(
              color: Culi.widgetInactiveColor,
              size: const Size.square(13),
              activeColor: Culi.widgetActiveColor,
              activeSize: const Size.square(16),
            ),
          ),
          Container(
            height: 0.05 * height,
          ),
          Container(
            height: 0.1 * height,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "How many nights a week do you want to cook?",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          Container(
            height: 0.2 * height,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                      child: CuliSlider(
                          min: 1,
                          max: 4,
                          sliderUpdate: (sliderValue) {
                            signup.frequency = sliderValue;
                            print("Updated signup to ${signup.toJson()}");
                          })),
                ],
              ),
            ),
          ),
          Container(
            height: 0.1 * height,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "We recommend cooking four nights a week in order to help optimize your grocery orders",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          Container(
            height: 0.1 * height,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Do you want leftovers for lunch?",
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Container(
            height: height * 0.1,
            child: FractionallySizedBox(
                widthFactor: 0.885,
                child: RaisedButton(
                  child: Text("No, thank you!",
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(fontSize: 18.0),
                      textAlign: TextAlign.center),
                  color: Culi.buttonBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  onPressed: () {
                    signup.preferredNumberServings = 1;
                    signup.frequency ??= 1.0;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignupUserInformation(signup)));
                  },
                )),
          ),
          Container(
            height: 0.05 * height,
          ),
          Container(
            height: height * 0.1,
            child: FractionallySizedBox(
                widthFactor: 0.885,
                child: RaisedButton(
                  child: Text("Couldn't hurt.",
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(fontSize: 18.0),
                      textAlign: TextAlign.center),
                  color: Culi.buttonBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  onPressed: () {
                    signup.preferredNumberServings = 2;
                    signup.frequency ??= 1.0;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SignupUserInformation(signup)));
                  },
                )),
          ),
        ])));
  }
}

class SignupUserInformation extends StatelessWidget {
  final SignUp signup;
  static RegExp emailRegEx = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  SignupUserInformation(this.signup) {
    print("Entering Sign Information screen with form ${signup.toJson()}");
  }

  static bool emailValidator(String email) {
    return emailRegEx.hasMatch(email);
  }

  static bool passwordValidator(String password) {
    return password.length > 8;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Account",
              style: Theme.of(context).textTheme.headline3),
          backgroundColor: Colors.transparent,
        ),
        body: Center(
            child: Column(children: <Widget>[
          Container(
            height: 0.015 * height,
          ),
          DotsIndicator(
            dotsCount: 3,
            position: 2.0,
            decorator: DotsDecorator(
              color: Culi.widgetInactiveColor,
              size: const Size.square(13),
              activeColor: Culi.widgetActiveColor,
              activeSize: const Size.square(16),
            ),
          ),
          Container(
            height: 0.025 * height,
          ),
          Container(
            height: 0.125 * height,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                "Now all you have to do is save your preferences and get started!",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          // ValidatedEntryForm(
          //   submitButtonText: "CREATE ACCOUNT",
          //   successPath: () => SignupDebugScreen(signup: signup),
          //   fields: [
          //     Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 16.0),
          //       child: TitledTextField(
          //           "Name",
          //           fieldUpdater: (String name) => {signup.name = name},
          //           validator: (name) => name.length > 0 ? null : "Invalid name length",
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 16.0),
          //       child: TitledTextField(
          //           "Email",
          //           fieldUpdater: (String email) => {signup.email = email},
          //           validator: (email) => emailValidator(email) ? null : "Invalid email",
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 16.0),
          //       child: TitledTextField(
          //           "Password",
          //           hidden: true,
          //           fieldUpdater: (String password) => {signup.password = password},
          //           validator: (password) => passwordValidator(password) ? null : "Invalid password",
          //       ),
          //   ),
          //   ]
          // ),
        ])));
  }
}

class SignupDebugScreen extends StatelessWidget {
  final SignUp signup;

  SignupDebugScreen({this.signup});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(signup.toJson().toString().replaceAll(",", "\n")),
        Container(
            width: 229,
            height: 48,
            child: FlatButton(
              color: Culi.green,
              onPressed: () {
                while (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: Culi.green, style: BorderStyle.solid),
              ),
              child: Text("GO TO SELECTION",
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(color: Colors.white)),
            ))
      ],
    )));
  }
}
