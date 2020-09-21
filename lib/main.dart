import 'package:app/InteractionNavigator.dart';
import 'package:app/SignupIntroduction.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'MenuSelection.dart';
import 'Theme.dart';
import 'models/SignUp.dart';

void main() {
  runApp(SalusInteractionNavigator());
}

class SalusInteractionNavigator extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salus Interaction Navigator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          actionsIconTheme: IconThemeData(
            color: Salus.green
          ),
          iconTheme: IconThemeData(
            color: Salus.green,
          )
        ),
        textTheme: Salus.textTheme,
        // textTheme: ,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InteractionNavigator(),
      routes: {
        '/selection': (context) => InteractionNavigator(),
        '/introduction': (context) => SignupIntroduction(),
        '/menuselection': (context) => MenuIntroduction(),
      }
    );
  }
}
