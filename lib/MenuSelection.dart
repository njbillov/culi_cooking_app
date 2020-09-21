
import 'package:app/NavigationBarHelpers.dart';
import 'package:flutter/material.dart';

import 'Theme.dart';

class MenuIntroduction extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.6,
              width: size.width,
              decoration: BoxDecoration(
                color: Salus.lightGreen,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height * 0.325,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/noun_chef.png"),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Container(

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                "Help create your first menu",
                                style: Theme.of(context).textTheme.headline4,
                                maxLines: 2,
                              ),
                            ),
                            Container(
                                width: 112,
                                height: 44,
                                child: FlatButton(
                                  color: Salus.green,
                                  onPressed: () {
                                    // Navigator.push(context,
                                    //     MaterialPageRoute(builder: (context) => SignupIntroduction()));
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Salus.green, style: BorderStyle.solid),
                                  ),
                                  child: Text("Explore", softWrap: true, style: Theme.of(context).textTheme.headline1.copyWith(color: Colors.white)),
                                )
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              )
            ),
            Container(
              padding: EdgeInsets.all(36.0),
              alignment: Alignment.bottomCenter,
              child: Text(
                "We want you to be excited about the food you're cooking.  So in order for us to get a better sense of what really stirs your pot, preheats your oven, grills your buns (we could go all day), let us know which of these potential menus looks better to you.  The more you interact with the menus we offer, the more personalized your meals will become!",
                style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.5, fontWeight: FontWeight.w400),
                softWrap: true,
                maxLines: 9,
              )
            )
          ],
        )
      ),
      bottomNavigationBar: SalusBottomNavigationBar(1),
    );
  }
}