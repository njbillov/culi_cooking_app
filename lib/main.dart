import 'package:app/SignupIntroduction.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      home: SignupIntroduction(),
      // home: SelectionScreen(title: 'Selection Screen'),
      routes: {
        '/selection': (context) => SelectionScreen(title: 'Selection Screen'),
        '/introduction': (context) => SignupIntroduction(),
      }
    );
  }
}

class SelectionScreen extends StatefulWidget {

  final String title;

  SelectionScreen({Key key, this.title}) : super(key: key);
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: RaisedButton(
                    onPressed: () => print("Pressed Button"),
                    child: Text("Text")
                  )
                ),
              ),
            ],
          ),
        ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text("Navigation button 1"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Navigation button 2"),
          ),
        ],
      ),
    );
  }

}