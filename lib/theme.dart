import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'models/recipe.dart';
import 'utilities.dart';
// import 'package:google_fonts/google_fonts.dart';

ThemeData culiTheme = ThemeData(
  // This is the theme of your application.
  //
  // Try running your application with "flutter run". You'll see the
  // application has a blue toolbar. Then, without quitting the app, try
  // changing the primarySwatch below to Colors.green and then invoke
  // "hot reload" (press "r" in the console where you ran "flutter run",
  // or simply save your changes to "hot reload" in a Flutter IDE).
  // Notice that the counter didn't reset back to zero; the application
  // is not restarted.
  // primarySwatch: Colors.green,
  appBarTheme: AppBarTheme(
      color: Colors.white,
      actionsIconTheme: IconThemeData(color: Culi.coral),
      iconTheme: IconThemeData(
        color: Culi.coral,
      )),
  textTheme: Culi.textTheme,
  backgroundColor: Culi.cream,
  // textTheme: ,
  // This makes the visual density adapt to the platform that you run
  // the app on. For desktop platforms, the controls will be smaller and
  // closer together (more dense) than on mobile platforms.
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

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
  static const Color cream = Color.fromRGBO(255, 227, 200, 1);
  static const Color darkCoral = Color.fromRGBO(225, 97, 83, 1);
  static const Color accentCoral = Color.fromRGBO(255, 135, 122, 1);
  static const Color lightCoral = Color.fromRGBO(255, 225, 222, 1);
  static const Color paleCoral = Color.fromRGBO(254, 209, 204, 1);
  static const Color white = Color.fromRGBO(229, 229, 229, 1);
  static const Color accentBlue = Color.fromRGBO(107, 142, 240, 1);
  static const Color accentGreen = Color.fromRGBO(163, 219, 132, 1);
  static const Color clear = Color.fromRGBO(255, 255, 255, 0);

  static const double letterSpacing = -0.3;

  static const TextStyle buttonTextStyle = TextStyle(
      fontFamily: "Circular Std Bold",
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: Colors.white);
  static const TextTheme textTheme = TextTheme(
    headline1: TextStyle(
        fontFamily: "Bergen Sans",
        fontWeight: FontWeight.w400,
        color: Culi.coral,
        fontSize: 85),
    headline2: TextStyle(
        fontFamily: "Circular Std Bold",
        fontWeight: FontWeight.normal,
        color: Culi.black,
        fontSize: 20.25),
    headline3: TextStyle(
        fontFamily: "Circular Std Bold",
        fontWeight: FontWeight.normal,
        color: Culi.black,
        fontSize: 19),
    headline4: TextStyle(
        fontFamily: "Apercu",
        fontWeight: FontWeight.normal,
        color: Culi.black,
        fontSize: 19),
    headline5: TextStyle(
        fontFamily: "Apercu",
        fontWeight: FontWeight.bold,
        color: Culi.black,
        fontSize: 16),
    bodyText1: TextStyle(
        fontFamily: "Apercu",
        fontWeight: FontWeight.normal,
        color: Culi.subtextGray,
        fontSize: 16),
  );
}

class CuliButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final double height;
  final double width;
  final Color color;
  final bool Function() enabled;

  static bool _defaultEnabled() => true;

  const CuliButton(this.text,
      {Key key,
      this.onPressed,
      this.height = 50,
      this.width = 300,
      this.color = Culi.coral,
      this.enabled = _defaultEnabled})
      : super(key: key);

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
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(height / 2),
                side: BorderSide(color: color, style: BorderStyle.solid),
              ),
            ),
            child: Text(text, style: Culi.buttonTextStyle),
          ),
        ));
  }
}

class CuliLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
  final Function() onPressed;
  final bool circular;
  final bool padded;

  static _defaultFunction() {}

  const CuliCheckbox(this.text,
      {Key key,
      this.selected = false,
      this.onPressed = _defaultFunction,
      this.circular = true,
      this.padded = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: 55,
        // width: size.width * 0.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(circular ? 41 : 0)),
          color: Colors.white,
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      reverseDuration: Duration(milliseconds: 300),
                      child: selected
                          ? Icon(Icons.check_circle,
                              color: Culi.black, size: 24)
                          : Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Culi.black, width: 2),
                                  borderRadius: BorderRadius.circular(12)),
                            ))),
              Container(
                width: padded ? size.width * 0.6 : size.width * 0.75,
                padding: const EdgeInsets.only(right: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('circular', circular));
  }
}

class CuliProgressBar extends StatelessWidget {
  final double progress;
  final double height;

  const CuliProgressBar({Key key, this.progress, this.height = 5})
      : super(key: key);

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
              decoration: BoxDecoration(color: Culi.coral),
            ),
            Container(
              width: width * (1 - progress),
              decoration: BoxDecoration(
                color: Culi.lightCoral,
              ),
            )
          ],
        ));
  }
}

class CuliTopImage extends StatelessWidget {
  final String imageName;
  final List<Widget> contents;

  const CuliTopImage({Key key, this.imageName, this.contents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(children: <Widget>[
          Container(
            width: size.width,
            height: 0.35 * size.height,
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
        ])));
  }
}

class CuliSplashImage extends StatelessWidget {
  final String imageName;
  final String titleText;
  final String bodyText;
  final List<Widget> contents;

  const CuliSplashImage(
      {Key key, this.imageName, this.titleText, this.bodyText, this.contents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
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
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ...contents
        ]))));
  }
}

class CuliAnnotatedCircle extends StatelessWidget {
  final double diameter;
  final double innerDiameter;
  final double annotationDiameter;
  final Color annotationColor;
  final String imageName;
  final Widget annotation;
  final String labelText;
  final bool outlined;
  final double thickness;
  final Color outlineColor;
  final Color backgroundColor;
  final Function onTap;
  final Function onLongPress;
  final bool annotate;
  final double fontSize;
  final Color labelColor;
  final FontWeight fontWeight;

  static _defaultFunction() {}

  const CuliAnnotatedCircle(
      {Key key,
      this.imageName,
      this.annotation,
      this.diameter = 70,
      this.innerDiameter = 0,
      this.annotationDiameter = 25,
      this.annotationColor,
      this.labelText = "",
      this.outlined = true,
      this.backgroundColor = Colors.white,
      this.onTap = _defaultFunction,
      this.onLongPress = _defaultFunction,
      this.annotate = true,
      this.fontSize = 12,
      this.labelColor = Culi.black,
      this.fontWeight = FontWeight.normal,
      this.thickness = 2,
      this.outlineColor = Culi.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter / 0.6,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Stack(children: <Widget>[
            InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Container(
                height: diameter,
                width: diameter,
                padding: EdgeInsets.all(
                    (innerDiameter == 0) ? 0 : (diameter - innerDiameter) / 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(diameter / 2),
                  border: Border.all(
                    color: outlined ? outlineColor : Culi.clear,
                    width: thickness,
                  ),
                  color: backgroundColor,
                ),
                child: Container(
                    height: (innerDiameter == 0 ? diameter : innerDiameter),
                    width: (innerDiameter == 0 ? diameter : innerDiameter),
                    //     foregroundDecoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(diameter / 2),
                    //       color: foregroundColor,
                    //     ),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imageName),
                        fit: BoxFit.contain,
                      ),
                    )),
              ),
            ),
            if (annotate)
              Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      height: annotationDiameter,
                      width: annotationDiameter,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: annotationColor,
                        borderRadius:
                            BorderRadius.circular(annotationDiameter / 2),
                      ),
                      child: annotation))
          ]),
          if (labelText.isNotEmpty)
            Container(
              height: diameter / 5,
            ),
          if (labelText.isNotEmpty)
            Container(
              width: diameter,
              // height:  diameter / 5,
              alignment: Alignment.topCenter,
              child: Text(
                labelText,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: fontSize,
                    color: labelColor,
                    fontWeight: fontWeight),
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
  final Recipe recipe;
  final String night;
  final double radius;
  final Function recipeInsightTap;
  final bool isInsightGlobal;

  final String recipeInsightButtonText;

  static void _defaultTap() {}

  const CuliRecipeCard(
      {Key key,
      this.height,
      @required this.recipe,
      this.night = "",
      this.radius = 20,
      this.recipeInsightTap = _defaultTap,
      this.recipeInsightButtonText = "",
      this.isInsightGlobal = true})
      : super(key: key);

  static const String defaultThumbnail = 'assets/images/big_noun_chef.png';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => Utils.changeScreens(
          context: context,
          global: isInsightGlobal,
          routeName: '/recipe${recipe.recipeId}/insight',
          nextWidget: () => RecipeInsight(
                recipe: recipe,
                text: recipe?.description ?? '',
                buttonText: recipeInsightButtonText,
                onPressed: recipeInsightTap,
              )),
      child: Container(
        width: size.width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Flex(direction: Axis.horizontal, children: <Widget>[
          Flexible(
            flex: 1,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(radius),
                        bottomLeft: Radius.circular(radius)),
                    color: Colors.grey.shade300,
                    image: DecorationImage(
                        image: AssetImage(
                            recipe?.thumbnailUrl ?? defaultThumbnail),
                        // centerSlice: Rect.largest,
                        fit: BoxFit.contain))),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Flex(direction: Axis.vertical,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(recipe?.recipeName ?? '',
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontSize: 16)),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        night,
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Culi.coral, fontSize: 16),
                      ),
                    )
                  ]),
            ),
          )
        ]),
      ),
    );
  }
}

class CircleList<T> extends StatelessWidget {
  final List<T> list;
  final String Function(T) getLabel;
  final String Function(T) imageSupplier;
  final double height;
  final double innerDiameter;
  final double thickness;
  final Color backgroundColor;
  final Color outlineColor;
  final double horizontalPadding;

  static String defaultGetter(dynamic t) => "";

  const CircleList(
      {Key key,
      this.list,
      this.getLabel = defaultGetter,
      this.imageSupplier = defaultGetter,
      this.height = 150,
      this.innerDiameter = 35,
      this.thickness = 2,
      this.backgroundColor = Colors.white,
      this.outlineColor = Culi.black,
      this.horizontalPadding = 16.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: list
                .map((e) => Padding(
                    padding: EdgeInsets.only(
                        bottom: 8,
                        left: horizontalPadding,
                        right: horizontalPadding),
                    child: CuliAnnotatedCircle(
                      annotate: false,
                      imageName: imageSupplier(e),
                      labelText: getLabel(e).toCamelCase(),
                      innerDiameter: innerDiameter,
                      outlined: thickness != 0,
                      thickness: thickness,
                      outlineColor: outlineColor,
                      backgroundColor: backgroundColor,
                    )))
                .toList()),
      ),
    );
  }
}

class RecipeInsight extends StatelessWidget {
  final Recipe recipe;
  final String text;
  final String buttonText;
  final Function onPressed;

  static _defaultButtonPress() {}

  const RecipeInsight(
      {Key key,
      this.recipe,
      this.text,
      this.onPressed = _defaultButtonPress,
      this.buttonText = ""})
      : super(key: key);

  static const String defaultSplash = 'assets/images/eggfriedrice.png';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(recipe.recipeName,
              style: Theme.of(context).textTheme.headline3),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Center(
                child: Column(children: <Widget>[
          Container(
            width: size.width,
            height: 0.3 * size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(recipe.splashUrl ?? defaultSplash),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Container(
            height: size.height * 0.425,
            child: ListView(shrinkWrap: true, children: [
              Container(
                height: 0.025 * size.height,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CuliAnnotatedCircle(
                          imageName: "assets/images/pan.png",
                          annotationColor: Culi.accentCoral,
                          labelText: "Ingredients",
                          innerDiameter: 42,
                          annotation: Text(
                            recipe.ingredients.length.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 11, color: Colors.white),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CuliAnnotatedCircle(
                          imageName: "assets/images/knife.png",
                          annotationColor: Culi.accentGreen,
                          labelText: "Skills",
                          innerDiameter: 42,
                          annotation: Text(
                            recipe.steps
                                .expand((element) => element.steps
                                    .map((e) => e.skills.map((e) => e.name)))
                                .toSet()
                                .length
                                .toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 11, color: Colors.white),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CuliAnnotatedCircle(
                        imageName: "assets/images/pot.png",
                        annotationColor: Culi.accentBlue,
                        outlined: true,
                        labelText: "Minutes",
                        innerDiameter: 42,
                        annotation: Text(
                          recipe.timeEstimate?.toString() ?? '45',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 11, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 0.025 * size.height,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: 0.05 * size.height,
              ),
            ]),
          ),
          if (buttonText.isNotEmpty)
            CuliButton(
              "Let's cook!",
              height: 75,
              width: size.width * 0.9,
              onPressed: onPressed,
            )
        ]))));
  }
}

extension ToCamelCase on String {
  String toCamelCase() {
    return substring(0, 1).toUpperCase() + substring(1).toLowerCase();
  }
}
