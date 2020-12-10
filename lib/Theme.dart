import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class Culi {
  static const Color green = Color.fromARGB(255, 108, 158, 79);
  static const Color lightGreen = Color.fromARGB(255, 189, 242, 113);
  static const Color widgetActiveColor = Color.fromARGB(255, 8, 92, 108);
  static const Color widgetInactiveColor = Color.fromRGBO(29, 91, 106, 0.58);
  static const Color sliderTickColor = Color.fromRGBO(29, 91, 106, 1);
  static const Color bodyTextGrey = Color.fromARGB(255, 72, 72, 72);
  static const Color headerTextBlue = Color.fromARGB(255, 47, 72, 88);
  static const Color buttonBackground = Color.fromARGB(255, 204, 221, 221);
  static const Color backgroundWhite = Color.fromRGBO(229, 229, 229, 0.43);

  static const Color coral = Color.fromRGBO(246, 111, 96, 1);
  static const Color subtextGray = Color.fromRGBO(133, 133, 132, 1);
  static const Color black = Color.fromRGBO(57, 57, 57, 1);
  static const Color cream = Color.fromRGBO(255,227,200,1);
  static const Color darkCoral = Color.fromRGBO(225, 97, 83, 1);
  static const Color accentCoral = Color.fromRGBO(255, 135, 122, 1);
  static const Color lightCoral = Color.fromRGBO(255, 225, 222, 1);
  static const Color paleCoral = Color.fromRGBO(254, 209, 204, 1);
  static const Color white = Color.fromRGBO(229, 229, 229, 1);
  static const Color accentBlue = Color.fromRGBO(107, 142, 240, 1);
  static const Color accentGreen = Color.fromRGBO(163, 219, 132, 1);
  static const Color clear = Color.fromRGBO(255, 255, 255, 0);

  static const double letterSpacing = -0.3;

  static const TextStyle buttonTextStyle = TextStyle(fontFamily: "Circular Std Bold", fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white);
  static const TextTheme textTheme = TextTheme(
      headline1: const TextStyle(fontFamily: "Bergen Sans", fontWeight: FontWeight.w400, color: Culi.coral, fontSize: 85),
      headline2: const TextStyle(fontFamily: "Circular Std Bold", fontWeight: FontWeight.normal, color: Culi.black, fontSize: 20.25),
      headline3: const TextStyle(fontFamily: "Circular Std Bold", fontWeight: FontWeight.normal, color: Culi.black, fontSize: 19),
      headline4: const TextStyle(fontFamily: "Apercu", fontWeight: FontWeight.normal, color: Culi.black, fontSize: 19),
      bodyText1: const TextStyle(fontFamily: "Apercu", fontWeight: FontWeight.normal, color: Culi.subtextGray, fontSize: 16),
  );

}

class CuliButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final double height;
  final double width;

  const CuliButton(this.text, {Key key, this.onPressed, this.height = 50, this.width = 300}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(
          onLongPress: () => print("Long pressed"),
          onPressed: onPressed,
          // shape: RoundedRectangleBorder(
          //   borderRadius:  BorderRadius.circular(height / 2),
          //   side: BorderSide(color: Culi.coral, style: BorderStyle.solid),
          // ),
          style: TextButton.styleFrom(
            backgroundColor: Culi.coral,
            shape: RoundedRectangleBorder(
              borderRadius:  BorderRadius.circular(height / 2),
              side: BorderSide(color: Culi.coral, style: BorderStyle.solid),
            ),
          ),
          child: Text(text, style: Culi.buttonTextStyle),
        ),
      )
    );
  }
}

class CuliLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/logo.png"),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }


}

class CuliCheckbox extends StatelessWidget {
  final String text;
  final bool selected;

  const CuliCheckbox(this.text, {Key key, this.selected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(41)),
        color: Colors.white,
      ),
      child: TextButton(
        onPressed: () => {print("pressed button!")},
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Icon(selected ? Icons.check_circle:Icons.arrow_drop_down_circle_outlined, color: Culi.black),
            ),
            Text(text, style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 16))
          ],
        ),
      )
    );
  }
}

class CuliProgressBar extends StatelessWidget {
  final double progress;
  final double height;

  const CuliProgressBar({Key key, this.progress, this.height = 5}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: width * progress,
            decoration: BoxDecoration(
              color: Culi.coral
            ),
          ),
          Container(
            width: width * (1 - progress),
            decoration: BoxDecoration(
              color: Culi.lightCoral,
            ),
          )
        ],
      )
    );
  }
}

class CuliTopImage extends StatelessWidget {

  final String imageName;
  final List<Widget> contents;

  const CuliTopImage({Key key, this.imageName, this.contents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        backgroundColor: Culi.white,
        body: SafeArea(
            child: Center(
                child: Column(
                    children: <Widget>[
                      Container(
                        width: size.width,
                        height: 0.3 * size.height,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(imageName),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Container(
                        height: 0.05 * size.height,
                      ),
                      ...contents,
                    ]
                )
            )
        )
    );
  }
}

class CuliSplashImage extends StatelessWidget {
  final String imageName;
  final String titleText;
  final String bodyText;
  final List<Widget> contents;

  const CuliSplashImage({Key key, this.imageName, this.titleText, this.bodyText, this.contents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Culi.white,
        body: SafeArea(
            child: Center(
                child: Column(children: <Widget>[
            Container(
              height: 0.05 * height,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                titleText,
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageName),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Container(
              height: height * 0.2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  bodyText,
                  style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ...contents
          ]
          )
        )
      )
    );
  }
}

class CuliAnnotatedCircle extends StatelessWidget {
  final double diameter;
  final double annotationDiameter;
  final Color annotationColor;
  final String imageName;
  final Widget annotation;
  final String labelText;
  final bool outlined;
  final Color backgroundColor;

  const CuliAnnotatedCircle({Key key, this.imageName, this.annotation, this.diameter = 70, this.annotationDiameter = 25, this.annotationColor, this.labelText = "", this.outlined = true, this.backgroundColor = Culi.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(children: <Widget>[
            Container(
                height: diameter,
                width: diameter,
            //     foregroundDecoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(diameter / 2),
            //       color: foregroundColor,
            //     ),
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(imageName)),
                    borderRadius: BorderRadius.circular(diameter / 2),
                    border: Border.all(
                      color: outlined ? Culi.black : Culi.clear,
                      width: 2,
                    ),
                    color: backgroundColor)
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: annotationDiameter,
                width: annotationDiameter,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: annotationColor,
                  borderRadius: BorderRadius.circular(annotationDiameter / 2),
                ),
                child: annotation
              )
            )
          ]),
          Container(
            height: diameter / 5,
          ),
          Container(
            width: diameter,
            alignment: Alignment.bottomCenter,
            child: Text(
              labelText,
              style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 11, color: Culi.black),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class CuliRecipeCard extends StatelessWidget {
  final double height;
  final String recipeName;
  final String night;
  final String imageName;
  final double radius;
  final Function onTap;

  static void _defaultTap() {}

  const CuliRecipeCard({Key key, this.height, this.recipeName, this.night = "", this.imageName, this.radius = 20, this.onTap = _defaultTap}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: size.width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget> [
            Flexible(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(radius), bottomLeft: Radius.circular(radius)),
                  image: DecorationImage(
                    image: AssetImage(imageName),
                    centerSlice: Rect.largest,
                  )
                )
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Flex(
                  direction: Axis.vertical,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          recipeName,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 16)
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          night,
                          style: Theme.of(context).textTheme.headline4.copyWith(color: Culi.coral, fontSize: 16),
                        ),
                      ),
                    )
                  ]
                ),
              ),
            )
          ]
        ),
      ),
    );
  }
}
