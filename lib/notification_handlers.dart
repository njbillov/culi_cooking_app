import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

import 'local_notifications_test.dart';
import 'meal_scheduler.dart';
import 'models/notification_payload.dart';
import 'models/survey/survey.dart';
import 'survey.dart';
import 'utilities.dart';

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

/// Notification handlers need bindings to the root system, which happens in the
/// ios/android directories outside of Flutter code.
class NotificationHandler {
  NotificationAppLaunchDetails appLaunchDetails;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  InitializationSettings _initializationSettings;

  bool isInitialized = false;

  // BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();

  Future<void> initializePlugin() async {
    await configureLocalTimeZone();

    appLaunchDetails = await _plugin.getNotificationAppLaunchDetails();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });
    const initializationSettingsMacOS = MacOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false);
    _initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    // await _plugin.initialize(initializationSettings,
    //     onSelectNotification: (payload) async {
    //       if (payload != null) {
    //         debugPrint('notification payload: $payload');
    //       }
    //       selectNotificationSubject.add(payload);
    //     });
    //     (payload) async {
    //   if (payload != null) {
    //     debugPrint('notification payload: $payload');
    //   }
    //   selectNotificationSubject.add(payload);
    // });
  }

  Future<void> initializeHandlers(BuildContext context) async {
    await _plugin.initialize(_initializationSettings,
        onSelectNotification: (payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      handleNotification(context, payload);
    });
  }

  static final NotificationHandler _instance = NotificationHandler._internal();

  static NotificationHandler get instance => _instance;

  factory NotificationHandler() {
    return _instance;
  }

  NotificationHandler._internal();

  static Future<void> showNotification(
      {@required NotificationPayload payload,
      tz.TZDateTime time,
      Duration offset = const Duration(seconds: 5)}) async {
    if (time == null && offset == null) {
      time ??= tz.TZDateTime.now(tz.local).add(offset);
    } else if (time != null) {
      if (time.isBefore(tz.TZDateTime.now(tz.local))) return;
    } else {
      time = tz.TZDateTime.now(tz.local).add(offset);
    }
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await instance._plugin.cancel(payload.id);
    await _instance._plugin.zonedSchedule(
        payload.id, payload.title, payload.body, time, platformChannelSpecifics,
        payload: payload.toJsonString(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  // void _configureSelectNotificationSubject() {
  //   selectNotificationSubject.stream.listen((payload) async {
  //     await Navigator.push(
  //       context,
  //       MaterialPageRoute<void>(
  //           builder: (context) => SecondScreen(payload)),
  //     );
  //   });
  // }
}

const Map<NotificationType, void Function(BuildContext, NotificationPayload)>
    routingTable = {
  NotificationType.makeSocialPost: unhandledNotification,
  NotificationType.survey: handleSurveyNotification,
  NotificationType.social: unhandledNotification,
  NotificationType.mealTime: handleMealTimeNotification,
};

void handleMealTimeNotification(
    BuildContext context, NotificationPayload payload) async {
  log('Loading Menu from cache');
  Utils.changeScreens(
    context: context,
    nextWidget: () => ChooseRecipeScreen(),
    routeName: '/recipe/choose',
    global: true,
  );
}

void handleSurveyNotification(
    BuildContext context, NotificationPayload payload) async {
  log('Opening up a survey');
  var survey;
  try {
    survey = Survey.fromJsonString(payload.payload);
  } on FormatException catch (e) {
    log(e.toString());
  }
  await changeSurveyScreens(context, survey);
}

void unhandledNotification(
    BuildContext context, NotificationPayload payload) async {
  log('This notification type (${payload.type} is not handled yet!');
}

Future handleNotification(BuildContext context, String payload) async {
  log('Handling payload: $payload and context is $context}');
  try {
    log('Incoming json: ${jsonDecode(payload)}');
    final notificationPayload =
        NotificationPayload.fromJson(jsonDecode(payload));
    final type = notificationPayload.type;
    log('Handling notification of type $type');
    routingTable[type](context, notificationPayload);
  } on FormatException catch (e) {
    log(e.toString());
  } on Exception catch (e) {
    log(e.toString());
  } catch (e) {
    log(e.toString());
  }
}
