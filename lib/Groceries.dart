

import 'package:app/Theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroceryIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CuliTopImage(
      imageName: "assets/images/groceries.png",
      contents: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text("A grocery experience\nmade easy",
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center),
        ),
        Container(
          height: 0.075 * size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/shopping_cart.png")
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
      ],
    );
  }
}
