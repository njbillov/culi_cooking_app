import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class Utils {
  static void changeScreens<T extends ChangeNotifier>(
      {@required BuildContext context,
      @required Widget Function() nextWidget,
      bool restorable = false,
      bool squash = false,
      bool global = false,
      T value,
      String routeName}) async {
    final current = ModalRoute?.of(context)?.settings?.name ??
        context.widget.toStringShort();
    final next = routeName ?? nextWidget().toStringShort();
    print(
        'Moving from $current to $next${squash ? " and squashing history" : ""}');
    MaterialPageRoute route;
    final settings = RouteSettings(name: next);
    if (squash) {
      Navigator.popUntil(
          context,
          (route) =>
              false); //.then((v) => {print("Popping $next back to $current")});
    }
    if (value != null) {
      log("Creating route while passing value");
      route = MaterialPageRoute(
          settings: settings,
          builder: (context) =>
              ChangeNotifierProvider.value(value: value, child: nextWidget()));
    } else {
      route = MaterialPageRoute(
          settings: settings, builder: (context) => nextWidget());
    }
    Navigator.of(context, rootNavigator: global)
        .push(route)
        .then((v) => {print("Popping ${routeName ?? next} back to $current")});
  }
}
