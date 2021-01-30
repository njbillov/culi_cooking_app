import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'choose_intro_path.dart';
import 'culi_slider.dart';
import 'horizontal_card_list.dart';
import 'models/account.dart';
import 'models/menus.dart';
import 'models/sign_up.dart';
import 'navigation_bar_helpers.dart';
import 'signup_form.dart';
import 'theme.dart';
import 'titled_text_field.dart';
import 'utilities.dart';

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
                    child: Text("Culi",
                        style: Theme.of(context).textTheme.headline1),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: 156,
                        child: Text("Welcome to Culi",
                            style: Theme.of(context).textTheme.headline2,
                            maxLines: 2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 206,
                      child: Text("Learning how to cook one night at a time.",
                          style: Theme.of(context).textTheme.bodyText1,
                          maxLines: 2),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    child: CuliButton(
                      "Sign up",
                      width: 150,
                      height: 50,
                      onPressed: () => Utils.changeScreens(
                          context: context, nextWidget: () => Onboarding1()),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: CuliButton(
                      "Sign in",
                      width: 150,
                      height: 50,
                      onPressed: () => Utils.changeScreens(
                          context: context, nextWidget: () => LoginScreen()),
                    ),
                  )
                ]),
          ),
        ));
  }
}

class Onboarding1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: SafeArea(
            child: Center(
                child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Culi",
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 36)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "We believe doing  is the best way to learn.",
              maxLines: 3,
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.headline2.copyWith(fontSize: 27),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 36),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/culi_icons.png"),
                        fit: BoxFit.contain),
                  ))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "That's why we are here to guide "
              "you through your personalized "
              "meals, helping you learn and eat.",
              maxLines: 4,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.10,
                width: 2.5,
                decoration: BoxDecoration(color: Colors.black),
              )),
          CuliButton(
            "Get Started",
            onPressed: () => Utils.changeScreens(
                context: context, nextWidget: () => Onboarding2()),
            height: 55,
            width: 155,
          )
        ]))));
  }
}

class Onboarding2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: size.height * 0.05,
        ),
        Expanded(
          child: HorizontalCardList(
              height: MediaQuery.of(context).size.height * 0.8,
              children: <Widget>[
                InformationalCardView(
                  headerText:
                      "Each week, we plan out your personalized meals and send you a comprehensive grocery list. This way you can choose where, when, and  how to do your shopping",
                  bodyText:
                      "This way you can choose where, when, and how you do your shopping",
                ),
                InformationalCardView(
                    headerText:
                        "Our unique AI plans menus that overlap in fresh produce, so by the end of the week, you'll be left with  zero waste.",
                    bodyText: "No more bell peppers to the garbage"),
                InformationalCardView(
                    headerText:
                        "We walk you through everything step-by-step, leaving no room for doubt. The more you cook with us, the more you'll learn.",
                    bodyText:
                        "You're not just getting dinner, you're gaining skills in the process."),
                InformationalCardView(
                    headerText:
                        "Now we just need your skill level and cooking preferences!",
                    bodyText: "You'll be cooking with us in no time!"),
              ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CuliButton(
            "Get Started",
            height: 75,
            width: size.width * 0.9,
            onPressed: () => Utils.changeScreens(
              context: context,
              nextWidget: () => SignupForm1(),
            ),
          ),
        )
      ],
    ))));
  }
}

class SignupForm1 extends StatelessWidget {
  final signup = SignUp();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider.value(
      value: signup,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Culi",
              style:
                  Theme.of(context).textTheme.headline1.copyWith(fontSize: 27)),
          shadowColor: Colors.white,
        ),
        body: SafeArea(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              CuliProgressBar(progress: 0.25),
              Container(
                height: height * 0.05,
              ),
              Container(
                height: height * 0.10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "What are your current cooking skills like?",
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
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: Consumer<SignUp>(
                    builder: (context, signup, child) => CuliCheckbox(
                        "Afraid of my kitchen",
                        selected: signup.level == SignUp.amateur,
                        onPressed: () => signup.level = SignUp.amateur)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: Consumer<SignUp>(
                    builder: (context, signup, child) => CuliCheckbox(
                        "Eggs and microwave, that's all",
                        selected: signup.level == SignUp.novice,
                        onPressed: () => signup.level = SignUp.novice)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: Consumer<SignUp>(
                    builder: (context, signup, child) => CuliCheckbox(
                        "Few meals in the rotation",
                        selected: signup.level == SignUp.intermediate,
                        onPressed: () => signup.level = SignUp.intermediate)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: Consumer<SignUp>(
                    builder: (context, signup, child) => CuliCheckbox(
                        "I can freestyle",
                        selected: signup.level == SignUp.expert,
                        onPressed: () => signup.level = SignUp.expert)),
              ),
              Expanded(
                child: Container(
                  width: width,
                ),
              ),
              Consumer<SignUp>(
                  builder: (context, signup, child) => AnimatedOpacity(
                        opacity: signup.level == 0 ? 0 : 1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: CuliButton(
                          "Next",
                          height: 75,
                          width: width * 0.9,
                          onPressed: () => Utils.changeScreens(
                              context: context,
                              value: signup,
                              nextWidget: () => SignupForm2()),
                        ),
                      )),
            ]),
          ),
        ),
      ),
    );
  }
}

class SignupForm2 extends StatelessWidget {
  const SignupForm2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Culi",
            style:
                Theme.of(context).textTheme.headline1.copyWith(fontSize: 27)),
        shadowColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          children: <Widget>[
            CuliProgressBar(progress: 0.5),
            Container(
              height: size.height * 0.05,
            ),
            Container(
              height: size.height * 0.10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "How many nights a week do you want to cook?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                  height: size.height * 0.05,
                  width: size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/big_pan.png"),
                      fit: BoxFit.fitHeight,
                    ),
                  )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Consumer<SignUp>(
                  builder: (context, signup, child) => CuliSlider(
                    sliderUpdate: (value) {
                      signup.frequency = value;
                      log("Changing signup frequency to $value");
                    },
                    min: 1,
                    max: 5,
                  ),
                ),
              ),
            ),
            CuliButton(
              "Next",
              height: 75,
              width: size.width * 0.9,
              onPressed: () => Utils.changeScreens(
                  context: context,
                  value: context.read<SignUp>(),
                  nextWidget: () => SignupForm3()),
            ),
          ],
        )),
      ),
    );
  }
}

class SignupForm3 extends StatelessWidget {
  const SignupForm3({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Culi",
              style:
                  Theme.of(context).textTheme.headline1.copyWith(fontSize: 27)),
          shadowColor: Colors.white,
        ),
        body: SafeArea(
          child: Center(
              child: Column(
            children: <Widget>[
              CuliProgressBar(progress: 0.75),
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
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: Consumer<SignUp>(
                    builder: (context, signup, child) => CuliCheckbox(
                        "Count me in!",
                        selected: signup.preferredNumberServings == 1,
                        onPressed: () => signup.preferredNumberServings = 1)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                child: Consumer<SignUp>(
                    builder: (context, signup, child) => CuliCheckbox(
                        "No, thank you",
                        selected: signup.preferredNumberServings == 2,
                        onPressed: () => signup.preferredNumberServings = 2)),
              ),
              Expanded(child: Container(width: width)),
              Consumer<SignUp>(
                  builder: (context, signup, child) => AnimatedOpacity(
                        opacity: signup.preferredNumberServings == 0 ? 0 : 1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: CuliButton(
                          "Next Screen",
                          height: 75,
                          width: width * 0.9,
                          onPressed: () => Utils.changeScreens(
                              context: context,
                              value: signup,
                              nextWidget: () => SignupForm4()),
                          // enabled: () => signup.frequency > 0,
                        ),
                      )),
            ],
          )),
        ));
  }
}

class SignupForm4 extends StatelessWidget {
  static RegExp emailRegEx = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  static String emailValidator(String email) {
    return emailRegEx.hasMatch(email) ? null : "Invalid email format";
  }

  static String passwordValidator(String password) {
    return password.length > 8 ? null : "Password is too short";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Culi",
            style:
                Theme.of(context).textTheme.headline1.copyWith(fontSize: 27)),
        shadowColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Consumer<SignUp>(
            builder: (context, signup, child) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CuliProgressBar(progress: 1),
                  Container(
                    height: size.height * 0.05,
                  ),
                  Container(
                    height: size.height * 0.10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Now all you have to do is save your preferences and get started!",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  ),
                  ValidatedEntryForm(
                      fields: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TitledTextField<SignUp>(
                            "Name",
                            fieldUpdater: (signup) =>
                                (str) => signup.name = str,
                            validator: (str) =>
                                str.isNotEmpty ? null : "Enter your name",
                            textInputType: TextInputType.name,
                            hints: [AutofillHints.name],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TitledTextField<SignUp>(
                            "Email",
                            fieldUpdater: (signup) =>
                                (str) => signup.email = str,
                            validator: emailValidator,
                            textInputType: TextInputType.emailAddress,
                            hints: [AutofillHints.email],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TitledTextField<SignUp>(
                            "Password",
                            hidden: true,
                            fieldUpdater: (signup) =>
                                (str) => signup.password = str,
                            validator: passwordValidator,
                            textInputType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.join,
                            hints: [AutofillHints.password],
                          ),
                        ),
                      ],
                      text: "Create Account",
                      onPressed: () async {
                        final signup = context.read<SignUp>();
                        // final query =
                        //     "mutation CreateAccount(\$form: PasswordForm!){createAccount(passwordForm: \$form){ok, code, session}}";
                        // final results = await GraphQLWrapper.mutate(query,
                        //     variables: {"form": signup.createAccountJson});
                        // final accountResults = results['createAccount'];
                        // log("Query results $results");
                        final account =
                            Provider.of<Account>(context, listen: false);
                        log('Is account null: ${account == null ? "yes" : "no"}');
                        final accountResults =
                            await account.createAccount(signupForm: signup);
                        if (accountResults['ok']) {
                          log("Creating an account with ${signup.email} and new session: ${accountResults['session']}");
                          Utils.changeScreens(
                              context: context,
                              nextWidget: () => ChooseIntroStarter(),
                              squash: true);
                        } else {
                          log("Account results code: ${accountResults['code']}");
                          // set up the button
                          Widget okButton = CupertinoDialogAction(
                            child: Text("OK"),
                            onPressed: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(context),
                          );

                          // set up the AlertDialog
                          var alert = CupertinoAlertDialog(
                            title: Text("Error"),
                            content: Text(accountResults['code']),
                            actions: [
                              okButton,
                            ],
                          );

                          // show the dialog
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return alert;
                            },
                          );
                        }
                      }),
                ]),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  static RegExp emailRegEx = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  static String emailValidator(String email) {
    return emailRegEx.hasMatch(email) ? null : "Invalid email format";
  }

  static String passwordValidator(String password) {
    return password.length > 8 ? null : "Password is too short";
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final signup = SignUp();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider.value(
      value: signup,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Culi",
              style:
                  Theme.of(context).textTheme.headline1.copyWith(fontSize: 27)),
          shadowColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Consumer<SignUp>(
              builder: (context, signup, child) =>
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                      Widget>[
                // CuliProgressBar(progress: 1),
                Container(
                  height: size.height * 0.05,
                ),
                Consumer<Account>(
                  builder: (context, account, child) => Consumer<Menus>(
                    builder: (context, menus, child) => Consumer<Menu>(
                      builder: (context, menu, child) => ValidatedEntryForm(
                          fields: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TitledTextField<SignUp>(
                                "Email",
                                fieldUpdater: (signup) =>
                                    (str) => signup.email = str,
                                validator: LoginScreen.emailValidator,
                                textInputType: TextInputType.emailAddress,
                                hints: [AutofillHints.email],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TitledTextField<SignUp>(
                                "Password",
                                hidden: true,
                                fieldUpdater: (signup) =>
                                    (str) => signup.password = str,
                                validator: LoginScreen.passwordValidator,
                                textInputType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.join,
                                hints: [AutofillHints.password],
                              ),
                            ),
                          ],
                          text: "Login",
                          onPressed: () async {
                            setState(() {});
                            final results =
                                await account.login(login: signup.loginJson);
                            if (results['login']['ok']) {
                              log("Hi ${results['login']['account']['name']}");
                              menus.menus = (await account.getMenus()).menus;
                              menus.write();
                              menu.recipes = menus.menus.first.recipes;
                              menu.write();
                              Utils.changeScreens(
                                  context: context,
                                  nextWidget: () => NavigationRoot(),
                                  squash: true);
                            } else {
                              // set up the button
                              Widget okButton = CupertinoDialogAction(
                                child: Text("OK"),
                                onPressed: () =>
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(context),
                              );
                              // set up the AlertDialog
                              var alert = CupertinoAlertDialog(
                                title: Text("Error"),
                                content: Text(
                                    "Invalid email and password combination"),
                                actions: [
                                  okButton,
                                ],
                              );

                              // show the dialog
                              showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return alert;
                                },
                              );
                            }
                          }),
                    ),
                  ),
                ),
              ]),
            ),
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Salus",
          style: Theme.of(context).textTheme.headline2,
        ),
        backgroundColor: Colors.transparent,
        toolbarOpacity: 0.0,
        shadowColor: Colors.transparent,
      ),
      body: Center(
        child: Column(children: <Widget>[
          Container(
            height: size.height * 0.6,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/keto_avocado_bowl.jpeg"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          HorizontalCardList(children: [
            InformationalCardView(
              headerText: "Learning how to cook one night at a time.",
              bodyText:
                  "We believe doing is the best way to learn. So we're here to help you do, and when you do, you learn. And you eat! Win win win.",
            ),
            InformationalCardView(
              headerText: "Reduce waste through smart shopping.",
              bodyText:
                  "We tell you exactly what you'll need at the beginning of each week, so there's no more guessing at the grocery store and subsequent trashing later.",
            ),
            InformationalCardView(
              headerText: "Save money through meal planning.",
              bodyText:
                  "Salus has your meals planned before the week even begins. No more stressing over how or what to make for dinner.  Just follow our lead.",
            ),
          ]),
          SizedBox(height: 25),
          Divider(
            thickness: 1,
            color: Colors.grey,
            height: 1,
          ),
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
                      ));
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(color: Culi.green, style: BorderStyle.solid),
                ),
                child: Text("GET STARTED",
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(color: Colors.white)),
              ))
        ]),
      ),
    );
  }
}

class InformationalCardView extends StatelessWidget {
  final String headerText;
  final String bodyText;

  const InformationalCardView(
      {Key key, @required this.headerText, @required this.bodyText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
              child: Text(bodyText,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ],
    );
  }
}
