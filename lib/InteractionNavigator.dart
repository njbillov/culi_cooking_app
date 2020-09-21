import 'package:app/MenuSelection.dart';
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
              Container(
                  width: 229,
                  height: 48,
                  child: FlatButton(
                    color: Salus.green,
                    onPressed: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignupIntroduction()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Salus.green, style: BorderStyle.solid),
                    ),
                    child: Text("SIGN UP SCREEN",  style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.white)),
                  )
              ),
            Container(
              height: 48,
            ),
              Container(
                  width: 229,
                  height: 48,
                  child: FlatButton(
                    color: Salus.green,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MenuIntroduction()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Salus.green, style: BorderStyle.solid),
                    ),
                    child: Text("MENU SCREEN",  style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.white)),
                  )
              )
            ],
          )
        )
    );
  }

}