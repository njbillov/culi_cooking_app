
import 'package:app/Theme.dart';
import 'package:flutter/material.dart';

class SocialIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CuliTopImage(
      imageName: "assets/images/social_feature.png",
      contents: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Alone together",
            style: Theme.of(context).textTheme.headline2,
            textAlign: TextAlign.center,
          )
        ),
        Container(
          height: 0.3 * size.height,
        ),
        CuliButton(
          "Explore",
          height: 75,
          width: 0.8 * size.width,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CuliAnnotatedCircle(
                  imageName: "assets/images/pan.png",
                  annotationColor: Culi.accentCoral,
                  labelText: "Ingredients",
                  annotation: Text(
                    "9",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 11, color: Culi.white),
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CuliAnnotatedCircle(
                imageName: "assets/images/knife.png",
                annotationColor: Culi.accentGreen,
                labelText: "Skills",
                annotation: Text(
                  "6",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 11, color: Culi.white),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CuliAnnotatedCircle(
                imageName: "assets/images/pot.png",
                annotationColor: Culi.accentBlue,
                backgroundColor: Culi.paleCoral,
                outlined: false,
                labelText: "Minutes",
                annotation: Text(
                  "54",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 11, color: Culi.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
