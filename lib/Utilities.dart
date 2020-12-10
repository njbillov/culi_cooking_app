
import 'package:flutter/material.dart';

abstract class CuliUtils {
  static void changeScreens({BuildContext context, Widget Function() nextWidget, bool squash = false}) {
    final current = context.widget.toStringShort();
    final next = nextWidget().toStringShort();
    print("Moving from $current to $next" + (squash ? " and squashing history":""));
    if(squash) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => nextWidget()),
          (context) => false)
      .then((value) => {print("Popping $next back to $current")});
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextWidget(),
      )
    ).then((value) => {print("Popping $next back to $current")});
  }
}