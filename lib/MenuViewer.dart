
import 'package:app/models/RecipeSchedule.dart';
import 'package:flutter/material.dart';

import 'Theme.dart';

class MenuViewer extends StatelessWidget {
  final List<RecipeSchedule> recipeSchedule;

  const MenuViewer({Key key, this.recipeSchedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        foregroundDecoration: BoxDecoration(
          border: Border.all(
            color: Colors.red[500],
          ),
          borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        child: Column(
          children: [
            for(var i = 0; i < recipeSchedule[0].recipeList.length; i++)
              Expanded(child: MenuItem(recipe: recipeSchedule[0].recipeList[i], recipeCount: recipeSchedule[0].recipeList.length, prerecipeText: "Night ${i + 1}: "))
          ]
        )
      )
    );
  }
}

class MenuItem extends StatelessWidget {
  final RecipeOverview recipe;
  final int recipeCount;
  final String prerecipeText;

  const MenuItem({Key key, this.recipe, this.recipeCount, this.prerecipeText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recipeCount <= 2) {
      return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(recipe.recipeImageResource),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withAlpha(0),
                  Colors.black12,
                  Colors.black87,
                ]
              )
            ),
            child: Text(
               prerecipeText + recipe.recipeName,
              style: Theme.of(context).textTheme.headline3.copyWith(color: Colors.white),
            ),
            // alignment: Alignment.bottomCenter,
          ),
        ]
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(recipe.recipeImageResource),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                padding: EdgeInsets.only(left: 16.0),
                alignment: Alignment.topCenter,
                child: Text(
                  prerecipeText + recipe.recipeName,
                  style: Theme.of(context).textTheme.headline3,
                )
              ),
            )
          ]
        ),
      );
    }
  }
}