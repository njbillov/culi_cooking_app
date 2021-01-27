import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

const MethodChannel platform = MethodChannel('culi_notifications');

class ReceivedNotification {
  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}

/// IMPORTANT: running the following code on its own won't work as there is
/// setup required for each platform head project.
///
/// Please download the complete example app from the GitHub repository where
/// all the setup has been done
Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  await configureLocalTimeZone();

  final notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

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
  final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectNotificationSubject.add(payload);
  });
  runApp(
    MaterialApp(
      home: HomePage(
        notificationAppLaunchDetails,
      ),
    ),
  );
}

Future<void> configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final timeZoneName = await platform.invokeMethod('getTimeZoneName');
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

class PaddedRaisedButton extends StatelessWidget {
  const PaddedRaisedButton({
    @required this.buttonText,
    @required this.onPressed,
    Key key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: RaisedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      );
}

class HomePage extends StatefulWidget {
  const HomePage(
    this.notificationAppLaunchDetails, {
    Key key,
  }) : super(key: key);

  final NotificationAppLaunchDetails notificationAppLaunchDetails;
  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    FlutterAppBadger.removeBadge();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((receivedNotification) async {
      await showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) =>
                        SecondScreen(receivedNotification.payload),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((payload) async {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
      );
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Text(
                          'Tap on a notification when it appears to trigger'
                          ' navigation'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            const TextSpan(
                              text: 'Did notification launch app? ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: '${widget.didNotificationLaunchApp}',
                            )
                          ],
                        ),
                      ),
                    ),
                    if (widget.didNotificationLaunchApp)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              const TextSpan(
                                text: 'Launch notification payload: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    widget.notificationAppLaunchDetails.payload,
                              )
                            ],
                          ),
                        ),
                      ),
                    PaddedRaisedButton(
                      buttonText: 'Show plain notification with payload',
                      onPressed: () async {
                        await _showNotification();
                      },
                    ),
                    PaddedRaisedButton(
                      buttonText:
                          'Show plain notification that has no title with '
                          'payload',
                      onPressed: () async {
                        await _showNotificationWithNoTitle();
                      },
                    ),
                    PaddedRaisedButton(
                      buttonText:
                          'Show plain notification that has no body with '
                          'payload',
                      onPressed: () async {
                        await _showNotificationWithNoBody();
                      },
                    ),
                    PaddedRaisedButton(
                      buttonText: 'Show another page'
                          'payload',
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Scaffold(body: Text('Third Screen'))));
                      },
                    ),
                    PaddedRaisedButton(
                      buttonText: 'Show notification with custom sound',
                      onPressed: () async {
                        await _showNotificationCustomSound();
                      },
                    ),
                    PaddedRaisedButton(
                      buttonText:
                          'Schedule notification to appear in 5 seconds based '
                          'on local time zone',
                      onPressed: () async {
                        await _zonedScheduleNotification();
                      },
                    ),
                    PaddedRaisedButton(
                      buttonText: 'Repeat notification every minute',
                      onPressed: () async {
                        await _repeatNotification();
                      },
                    ),
                    PaddedRaisedButton(
                      buttonText:
                          'Schedule daily 10:00:00 am notification in your '
                          'local time zone',
                      onPressed: () async {
                        await _scheduleDailyTenAMNotification();
                      },
                    ),
                    PaddedRaisedButton(
                      buttonText:
                          'Schedule weekly 10:00:00 am notification in your '
                          'local time zone',
                      onPressed: () async {
                        await _scheduleWeeklyTenAMNotification();
                      },
                    ),
                    PaddedRaisedButton(
                      buttonText:
                          'Schedule weekly Monday 10:00:00 am notification in '
                          'your local time zone',
                      onPressed: () async {
                        await _scheduleWeeklyMondayTenAMNotification();
                      },
                    ),
                    PaddedRaisedButton(
                      buttonText: 'Show notification with no sound',
                      onPressed: () async {
                        await _showNotificationWithNoSound();
                      },
                    ),
                    PaddedRaisedButton(
                      buttonText: 'Check pending notifications',
                      onPressed: () async {
                        await _checkPendingNotificationRequests();
                      },
                    ),
                    PaddedRaisedButton(
                      buttonText: 'Cancel notification',
                      onPressed: () async {
                        await _cancelNotification();
                      },
                    ),
                    PaddedRaisedButton(
                      buttonText: 'Cancel all notifications',
                      onPressed: () async {
                        await _cancelAllNotifications();
                      },
                    ),
                    if (Platform.isAndroid) ...<Widget>[
                      const Text(
                        'Android-specific examples',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      PaddedRaisedButton(
                        buttonText:
                            'Show plain notification with payload and update '
                            'channel description',
                        onPressed: () async {
                          await _showNotificationUpdateChannelDescription();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText:
                            'Show plain notification as public on every '
                            'lockscreen',
                        onPressed: () async {
                          await _showPublicNotification();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText:
                            'Show notification with custom vibration pattern, '
                            'red LED and red icon',
                        onPressed: () async {
                          await _showNotificationCustomVibrationIconLed();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show notification using Android Uri sound',
                        onPressed: () async {
                          await _showSoundUriNotification();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText:
                            'Show notification that times out after 3 seconds',
                        onPressed: () async {
                          await _showTimeoutNotification();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show insistent notification',
                        onPressed: () async {
                          await _showInsistentNotification();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show big picture notification',
                        onPressed: () async {
                          await _showBigPictureNotification();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText:
                            'Show big picture notification, hide large icon '
                            'on expand',
                        onPressed: () async {
                          await _showBigPictureNotificationHiddenLargeIcon();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show media notification',
                        onPressed: () async {
                          await _showNotificationMediaStyle();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show big text notification',
                        onPressed: () async {
                          await _showBigTextNotification();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show inbox notification',
                        onPressed: () async {
                          await _showInboxNotification();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show messaging notification',
                        onPressed: () async {
                          await _showMessagingNotification();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show grouped notifications',
                        onPressed: () async {
                          await _showGroupedNotifications();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show ongoing notification',
                        onPressed: () async {
                          await _showOngoingNotification();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText:
                            'Show notification with no badge, alert only once',
                        onPressed: () async {
                          await _showNotificationWithNoBadge();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText:
                            'Show progress notification - updates every second',
                        onPressed: () async {
                          await _showProgressNotification();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show indeterminate progress notification',
                        onPressed: () async {
                          await _showIndeterminateProgressNotification();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show notification without timestamp',
                        onPressed: () async {
                          await _showNotificationWithoutTimestamp();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show notification with custom timestamp',
                        onPressed: () async {
                          await _showNotificationWithCustomTimestamp();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show notification with chronometer',
                        onPressed: () async {
                          await _showNotificationWithChronometer();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show full-screen notification',
                        onPressed: () async {
                          await _showFullScreenNotification();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Create grouped notification channels',
                        onPressed: () async {
                          await _createNotificationChannelGroup();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Delete notification channel group',
                        onPressed: () async {
                          await _deleteNotificationChannelGroup();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Create notification channel',
                        onPressed: () async {
                          await _createNotificationChannel();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Delete notification channel',
                        onPressed: () async {
                          await _deleteNotificationChannel();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Get active notifications',
                        onPressed: () async {
                          await _getActiveNotifications();
                        },
                      ),
                    ],
                    if (Platform.isIOS || Platform.isMacOS) ...<Widget>[
                      const Text(
                        'iOS and macOS-specific examples',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show notification with subtitle',
                        onPressed: () async {
                          await _showNotificationWithSubtitle();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show notification with icon badge',
                        onPressed: () async {
                          await _showNotificationWithIconBadge();
                        },
                      ),
                      PaddedRaisedButton(
                        buttonText: 'Show notification with attachment',
                        onPressed: () async {
                          await _showNotificationWithAttachment();
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Future<void> _showNotification() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showFullScreenNotification() async {
    await showDialog(
        context: context,
        // ignore: deprecated_member_use
        child: AlertDialog(
          title: const Text('Turn off your screen'),
          content: const Text(
              'to see the full-screen intent in 5 seconds, press OK and TURN '
              'OFF your screen'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            FlatButton(
              onPressed: () async {
                await flutterLocalNotificationsPlugin.zonedSchedule(
                    0,
                    'scheduled title',
                    'scheduled body',
                    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
                    const NotificationDetails(
                        android: AndroidNotificationDetails(
                            'full screen channel id',
                            'full screen channel name',
                            'full screen channel description',
                            priority: Priority.high,
                            importance: Importance.high,
                            fullScreenIntent: true)),
                    androidAllowWhileIdle: true,
                    uiLocalNotificationDateInterpretation:
                        UILocalNotificationDateInterpretation.absoluteTime);

                Navigator.pop(context);
              },
              child: const Text('OK'),
            )
          ],
        ));
  }

  Future<void> _showNotificationWithNoBody() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', null, platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotificationWithNoTitle() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
        0, null, 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> _showNotificationCustomSound() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
      sound: RawResourceAndroidNotificationSound('slow_spring_board'),
    );
    const iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    const macOSPlatformChannelSpecifics =
        MacOSNotificationDetails(sound: 'slow_spring_board.aiff');
    const platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
        macOS: macOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'custom sound notification title',
        'custom sound notification body',
        platformChannelSpecifics);
  }

  Future<void> _showNotificationCustomVibrationIconLed() async {
    final vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'other custom channel id',
        'other custom channel name',
        'other custom channel description',
        icon: 'secondary_icon',
        largeIcon: const DrawableResourceAndroidBitmap('sample_large_icon'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);

    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'title of notification with custom vibration pattern, LED and icon',
        'body of notification with custom vibration pattern, LED and icon',
        platformChannelSpecifics);
  }

  Future<void> _zonedScheduleNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> _showNotificationWithNoSound() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'silent channel id',
        'silent channel name',
        'silent channel description',
        playSound: false,
        styleInformation: DefaultStyleInformation(true, true));
    const iOSPlatformChannelSpecifics =
        IOSNotificationDetails(presentSound: false);
    const macOSPlatformChannelSpecifics =
        MacOSNotificationDetails(presentSound: false);
    const platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
        macOS: macOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, '<b>silent</b> title',
        '<b>silent</b> body', platformChannelSpecifics);
  }

  Future<void> _showSoundUriNotification() async {
    /// this calls a method over a platform channel implemented within the
    /// example app to return the Uri for the default alarm sound and uses
    /// as the notification sound
    final alarmUri = await platform.invokeMethod('getAlarmUri');
    final uriSound = UriAndroidNotificationSound(alarmUri);
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'uri channel id', 'uri channel name', 'uri channel description',
        sound: uriSound,
        styleInformation: const DefaultStyleInformation(true, true));
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'uri sound title', 'uri sound body', platformChannelSpecifics);
  }

  Future<void> _showTimeoutNotification() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'silent channel id',
        'silent channel name',
        'silent channel description',
        timeoutAfter: 3000,
        styleInformation: DefaultStyleInformation(true, true));
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'timeout notification',
        'Times out after 3 seconds', platformChannelSpecifics);
  }

  Future<void> _showInsistentNotification() async {
    // This value is from: https://developer.android.com/reference/android/app/Notification.html#FLAG_INSISTENT
    const insistentFlag = 4;
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        additionalFlags: Int32List.fromList(<int>[insistentFlag]));
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'insistent title', 'insistent body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(url);
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> _showBigPictureNotification() async {
    final largeIconPath = await _downloadAndSaveFile(
        'https://via.placeholder.com/48x48', 'largeIcon');
    final bigPicturePath = await _downloadAndSaveFile(
        'https://via.placeholder.com/400x800', 'bigPicture');
    final bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        styleInformation: bigPictureStyleInformation);
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  Future<void> _showBigPictureNotificationHiddenLargeIcon() async {
    final largeIconPath = await _downloadAndSaveFile(
        'https://via.placeholder.com/48x48', 'largeIcon');
    final bigPicturePath = await _downloadAndSaveFile(
        'https://via.placeholder.com/400x800', 'bigPicture');
    final bigPictureStyleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        hideExpandedLargeIcon: true,
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        styleInformation: bigPictureStyleInformation);
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  Future<void> _showNotificationMediaStyle() async {
    final largeIconPath = await _downloadAndSaveFile(
        'https://via.placeholder.com/128x128/00FF00/000000', 'largeIcon');
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      'media channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: const MediaStyleInformation(),
    );
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'notification title', 'notification body', platformChannelSpecifics);
  }

  Future<void> _showBigTextNotification() async {
    const bigTextStyleInformation = BigTextStyleInformation(
      'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      htmlFormatBigText: true,
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true,
    );
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        styleInformation: bigTextStyleInformation);
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  Future<void> _showInboxNotification() async {
    final lines = <String>['line <b>1</b>', 'line <i>2</i>'];
    final inboxStyleInformation = InboxStyleInformation(lines,
        htmlFormatLines: true,
        contentTitle: 'overridden <b>inbox</b> context title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'inbox channel id', 'inboxchannel name', 'inbox channel description',
        styleInformation: inboxStyleInformation);
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'inbox title', 'inbox body', platformChannelSpecifics);
  }

  Future<void> _showMessagingNotification() async {
    // use a platform channel to resolve an Android drawable resource to a URI.
    // This is NOT part of the notifications plugin. Calls made over this
    /// channel is handled by the app
    final imageUri = await platform.invokeMethod('drawableToUri', 'food');

    /// First two person objects will use icons that part of the Android app's
    /// drawable resources
    const me = Person(
      name: 'Me',
      key: '1',
      uri: 'tel:1234567890',
      icon: DrawableResourceAndroidIcon('me'),
    );
    const coworker = Person(
      name: 'Coworker',
      key: '2',
      uri: 'tel:9876543210',
      icon: FlutterBitmapAssetAndroidIcon('icons/coworker.png'),
    );
    // download the icon that would be use for the lunch bot person
    final largeIconPath = await _downloadAndSaveFile(
        'https://via.placeholder.com/48x48', 'largeIcon');
    // this person object will use an icon that was downloaded
    final lunchBot = Person(
      name: 'Lunch bot',
      key: 'bot',
      bot: true,
      icon: BitmapFilePathAndroidIcon(largeIconPath),
    );
    final messages = <Message>[
      Message('Hi', DateTime.now(), null),
      Message("What's up?", DateTime.now().add(const Duration(minutes: 5)),
          coworker),
      Message('Lunch?', DateTime.now().add(const Duration(minutes: 10)), null,
          dataMimeType: 'image/png', dataUri: imageUri),
      Message('What kind of food would you prefer?',
          DateTime.now().add(const Duration(minutes: 10)), lunchBot),
    ];
    final messagingStyle = MessagingStyleInformation(me,
        groupConversation: true,
        conversationTitle: 'Team lunch',
        htmlFormatContent: true,
        htmlFormatTitle: true,
        messages: messages);
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'message channel id',
        'message channel name',
        'message channel description',
        category: 'msg',
        styleInformation: messagingStyle);
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'message title', 'message body', platformChannelSpecifics);

    // wait 10 seconds and add another message to simulate another response
    await Future<void>.delayed(const Duration(seconds: 10), () async {
      messages.add(Message(
          'Thai', DateTime.now().add(const Duration(minutes: 11)), null));
      await flutterLocalNotificationsPlugin.show(
          0, 'message title', 'message body', platformChannelSpecifics);
    });
  }

  Future<void> _showGroupedNotifications() async {
    const groupKey = 'com.android.example.WORK_EMAIL';
    const groupChannelId = 'grouped channel id';
    const groupChannelName = 'grouped channel name';
    const groupChannelDescription = 'grouped channel description';
    // example based on https://developer.android.com/training/notify-user/group.html
    const firstNotificationAndroidSpecifics = AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: groupKey);
    const firstNotificationPlatformSpecifics =
        NotificationDetails(android: firstNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(1, 'Alex Faarborg',
        'You will not believe...', firstNotificationPlatformSpecifics);
    const secondNotificationAndroidSpecifics = AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: groupKey);
    const secondNotificationPlatformSpecifics =
        NotificationDetails(android: secondNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(
        2,
        'Jeff Chang',
        'Please join us to celebrate the...',
        secondNotificationPlatformSpecifics);

    // Create the summary notification to support older devices that pre-date
    /// Android 7.0 (API level 24).
    ///
    /// Recommended to create this regardless as the behaviour may vary as
    /// mentioned in https://developer.android.com/training/notify-user/group
    const lines = <String>[
      'Alex Faarborg  Check this out',
      'Jeff Chang    Launch Party'
    ];
    const inboxStyleInformation = InboxStyleInformation(lines,
        contentTitle: '2 messages', summaryText: 'janedoe@example.com');
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        styleInformation: inboxStyleInformation,
        groupKey: groupKey,
        setAsGroupSummary: true);
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        3, 'Attention', 'Two messages', platformChannelSpecifics);
  }

  Future<void> _checkPendingNotificationRequests() async {
    final pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content:
            Text('${pendingNotificationRequests.length} pending notification '
                'requests'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _showOngoingNotification() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ongoing: true,
        autoCancel: false);
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'ongoing notification title',
        'ongoing notification body', platformChannelSpecifics);
  }

  Future<void> _repeatNotification() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeating channel id',
        'repeating channel name',
        'repeating description');
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
        'repeating body', RepeatInterval.everyMinute, platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }

  Future<void> _scheduleDailyTenAMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'daily scheduled notification title',
        'daily scheduled notification body',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id',
              'daily notification channel name',
              'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> _scheduleWeeklyTenAMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'weekly scheduled notification title',
        'weekly scheduled notification body',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'weekly notification channel id',
              'weekly notification channel name',
              'weekly notificationdescription'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  Future<void> _scheduleWeeklyMondayTenAMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'weekly scheduled notification title',
        'weekly scheduled notification body',
        _nextInstanceOfMondayTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'weekly notification channel id',
              'weekly notification channel name',
              'weekly notificationdescription'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfMondayTenAM() {
    var scheduledDate = _nextInstanceOfTenAM();
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _showNotificationWithNoBadge() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'no badge channel', 'no badge name', 'no badge description',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true);
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'no badge title', 'no badge body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showProgressNotification() async {
    const maxProgress = 5;
    for (var i = 0; i <= maxProgress; i++) {
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'progress channel',
            'progress channel',
            'progress channel description',
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: maxProgress,
            progress: i);
        final platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            'progress notification title',
            'progress notification body',
            platformChannelSpecifics,
            payload: 'item x');
      });
    }
  }

  Future<void> _showIndeterminateProgressNotification() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'indeterminate progress channel',
        'indeterminate progress channel',
        'indeterminate progress channel description',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        indeterminate: true);
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'indeterminate progress notification title',
        'indeterminate progress notification body',
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotificationUpdateChannelDescription() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        'your updated channel description',
        importance: Importance.max,
        priority: Priority.high,
        channelAction: AndroidNotificationChannelAction.update);
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'updated notification channel',
        'check settings to see updated channel description',
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showPublicNotification() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        visibility: NotificationVisibility.public);
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'public notification title',
        'public notification body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotificationWithSubtitle() async {
    const iOSPlatformChannelSpecifics =
        IOSNotificationDetails(subtitle: 'the subtitle');
    const macOSPlatformChannelSpecifics =
        MacOSNotificationDetails(subtitle: 'the subtitle');
    const platformChannelSpecifics = NotificationDetails(
        iOS: iOSPlatformChannelSpecifics, macOS: macOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'title of notification with a subtitle',
        'body of notification with a subtitle',
        platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotificationWithIconBadge() async {
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(badgeNumber: 1);
    const macOSPlatformChannelSpecifics =
        MacOSNotificationDetails(badgeNumber: 1);
    const platformChannelSpecifics = NotificationDetails(
        iOS: iOSPlatformChannelSpecifics, macOS: macOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'icon badge title', 'icon badge body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotificationWithoutTimestamp() async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high, showWhen: false);
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotificationWithCustomTimestamp() async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
    );
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotificationWithChronometer() async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
      usesChronometer: true,
    );
    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> _showNotificationWithAttachment() async {
    final bigPicturePath = await _downloadAndSaveFile(
        'https://via.placeholder.com/600x200', 'bigPicture.jpg');
    final iOSPlatformChannelSpecifics = IOSNotificationDetails(
        attachments: <IOSNotificationAttachment>[
          IOSNotificationAttachment(bigPicturePath)
        ]);
    final macOSPlatformChannelSpecifics = MacOSNotificationDetails(
        attachments: <MacOSNotificationAttachment>[
          MacOSNotificationAttachment(bigPicturePath)
        ]);
    final notificationDetails = NotificationDetails(
        iOS: iOSPlatformChannelSpecifics, macOS: macOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'notification with attachment title',
        'notification with attachment body',
        notificationDetails);
  }

  Future<void> _createNotificationChannelGroup() async {
    const channelGroupId = 'your channel group id';
    // create the group first
    const androidNotificationChannelGroup = AndroidNotificationChannelGroup(
        channelGroupId, 'your channel group name',
        description: 'your channel group description');
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        .createNotificationChannelGroup(androidNotificationChannelGroup);

    // create channels associated with the group
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        .createNotificationChannel(const AndroidNotificationChannel(
            'grouped channel id 1',
            'grouped channel name 1',
            'grouped channel description 1',
            groupId: channelGroupId));

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        .createNotificationChannel(const AndroidNotificationChannel(
            'grouped channel id 2',
            'grouped channel name 2',
            'grouped channel description 2',
            groupId: channelGroupId));

    await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              content: Text('Channel group with name '
                  '${androidNotificationChannelGroup.name} created'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  Future<void> _deleteNotificationChannelGroup() async {
    const channelGroupId = 'your channel group id';
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannelGroup(channelGroupId);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Channel group with id $channelGroupId deleted'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _createNotificationChannel() async {
    const androidNotificationChannel = AndroidNotificationChannel(
      'your channel id 2',
      'your channel name 2',
      'your channel description 2',
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              content:
                  Text('Channel with name ${androidNotificationChannel.name} '
                      'created'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  Future<void> _deleteNotificationChannel() async {
    const channelId = 'your channel id 2';
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.deleteNotificationChannel(channelId);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Channel with id $channelId deleted'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _getActiveNotifications() async {
    final activeNotificationsDialogContent =
        await _getActiveNotificationsDialogContent();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: activeNotificationsDialogContent,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<Widget> _getActiveNotificationsDialogContent() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    if (!(androidInfo.version.sdkInt >= 23)) {
      return const Text(
        '"getActiveNotifications" is available only for Android 6.0 or newer',
      );
    }

    try {
      final activeNotifications = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.getActiveNotifications();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Active Notifications',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(color: Colors.black),
          if (activeNotifications.isEmpty)
            const Text('No active notifications'),
          if (activeNotifications.isNotEmpty)
            for (ActiveNotification activeNotification in activeNotifications)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'id: ${activeNotification.id}\n'
                    'channelId: ${activeNotification.channelId}\n'
                    'title: ${activeNotification.title}\n'
                    'body: ${activeNotification.body}',
                  ),
                  const Divider(color: Colors.black),
                ],
              ),
        ],
      );
    } on PlatformException catch (error) {
      return Text(
        'Error calling "getActiveNotifications"\n'
        'code: ${error.code}\n'
        'message: ${error.message}',
      );
    }
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen(
    this.payload, {
    Key key,
  }) : super(key: key);

  final String payload;

  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String _payload;
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Second Screen with payload: ${_payload ?? ''}'),
        ),
        body: Center(
          child: RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go back!'),
          ),
        ),
      );
}
