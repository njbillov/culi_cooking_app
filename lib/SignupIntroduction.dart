import 'package:app/HorizontalCardList.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'SignupForm.dart';
import 'Theme.dart';

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
                  color: Salus.green,
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
                    side: BorderSide(color: Salus.green, style: BorderStyle.solid),
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
    return Column(
        children: <Widget>[
          SizedBox(height: 17),
          SizedBox(
              width: 0.936 * width,
              child: Text(
                headerText,
                style: Theme.of(context).textTheme.headline1,
                maxLines: 2,
                textAlign: TextAlign.center,
              )
          ),
          SizedBox(height: 25),
          SizedBox(
              width: 0.788 * width,
              // constraints: BoxConstraints.expand(width: width * 0.9, height: height * 0.2),
              child: Text(
                bodyText,
                style: Theme.of(context).textTheme.bodyText1,
              )
          ),
        ]
    );
  }
}