import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

import 'grocery_list.dart';
import 'models/account.dart';
import 'models/menus.dart';
import 'models/notification_payload.dart';
import 'notification_handlers.dart';
import 'theme.dart';
import 'utilities.dart';

class MealSchedulingScreen extends StatefulWidget {
  @override
  _MealSchedulingScreenState createState() => _MealSchedulingScreenState();
}

class _MealSchedulingScreenState extends State<MealSchedulingScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final account = Provider.of<Account>(context);
    return Consumer<Menu>(
        builder: (context, menu, child) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ListView(children: [
                ...Iterable.generate(menu.recipes.length).map((e) {
                  final disabled = e <
                      menu.recipes.where((e) => e?.completed ?? false).length;
                  return IgnorePointer(
                      ignoring: disabled,
                      child: Opacity(
                          opacity: disabled ? 0.3 : 1,
                          child: TimeSelector(
                              day: e,
                              initialTime: account.getNotificationTime(e))));
                }).toList()
              ]),
            ));
  }

  @override
  bool get wantKeepAlive => true;
}

class TimeSelector extends StatelessWidget {
  final int day;
  final tz.TZDateTime initialTime;

  const TimeSelector({Key key, @required this.day, this.initialTime})
      : super(key: key);

  tz.TZDateTime get startTime =>
      initialTime?.toLocal() ??
      tz.TZDateTime.from(
          DateTime.now()
              .toLocal()
              .add(Duration(days: 1))
              .roundDown(delta: Duration(days: 1))
              .subtract(DateTime.now().timeZoneOffset)
              .add(Duration(days: day, hours: 18)),
          tz.local);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    NotificationHandler.showNotification(
        time: startTime, payload: NotificationPayload.mealTime(day));
    final account = Provider.of<Account>(context);
    account.scheduleNotification(day, startTime);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
            child: Text(false ? '' : "Meal ${day + 1}",
                style: Theme.of(context).textTheme.headline3),
          ),
          Container(
            width: size.width * 0.825,
            height: size.height * 0.1,
            child: CupertinoDatePicker(
              onDateTimeChanged: (time) {
                account.scheduleNotification(
                    day, tz.TZDateTime.from(time, tz.local));
                NotificationHandler.showNotification(
                    time: tz.TZDateTime.from(time, tz.local),
                    payload: NotificationPayload.mealTime(day));
              },
              initialDateTime: startTime,
              minimumDate: DateTime.now()
                  .toLocal()
                  .subtract(Duration(days: 7))
                  .roundUp(),
              maximumDate:
                  DateTime.now().toLocal().add(Duration(days: 7)).roundUp(),
              minuteInterval: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class ChooseRecipeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: (Text("Choose What to Cook",
            style: Theme.of(context).textTheme.headline2)),
      ),
      body: Center(
        child: Consumer<Menu>(
          builder: (context, menu, child) => Column(
              children: menu.recipes
                  .map((e) => Opacity(
                        opacity: e?.completed ?? false ? 0.6 : 1.0,
                        child: IgnorePointer(
                          ignoring: e.completed,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 24),
                            child: CuliRecipeCard(
                                isInsightGlobal: false,
                                recipe: e,
                                height: size.height * 0.15,
                                recipeInsightButtonText: 'Start now',
                                recipeInsightTap: () => Utils.changeScreens(
                                    routeName: '/recipe${e.recipeId}/gather',
                                    context: context,
                                    global: false,
                                    nextWidget: () =>
                                        GatherRecipeItemsScreen(recipe: e))),
                          ),
                        ),
                      ))
                  .toList()),
        ),
      ),
    );
  }
}

extension Rounding on DateTime {
  DateTime roundDown({Duration delta = const Duration(minutes: 15)}) {
    return DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch - millisecondsSinceEpoch % delta.inMilliseconds);
  }

  DateTime roundUp({Duration delta = const Duration(minutes: 15)}) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch +
        (delta.inMilliseconds - millisecondsSinceEpoch % delta.inMilliseconds));
  }
}
