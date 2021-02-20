import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sensors/sensors.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:vector_math/vector_math.dart';

import 'data_manipulation/gql_interface.dart';
import 'feedback.dart';
import 'loading_screen.dart';
import 'models/account.dart';
import 'models/feedback.dart';
import 'models/menus.dart';
import 'theme.dart';
import 'utilities.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await tz.initializeTimeZones();
  FlutterAppBadger.removeBadge();
  final Account account = await Account().loadFromCache();
  final Menus menus = await Menus().loadFromCache();
  final Menu menu = await Menu().loadFromCache();
  log('${account == null ? "Account is null" : "Account is not null"}');
  runApp(
    CuliInteractionNavigator(
      account: account,
      menus: menus,
      menu: menu,
    ),
  );
}

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class CuliInteractionNavigator extends StatefulWidget {
  // This widget is the root of your application.
  final Account account;
  final Menus menus;
  final Menu menu;

  CuliInteractionNavigator({this.account, this.menus, this.menu, Key key})
      : super(key: key);

  @override
  _CuliInteractionNavigatorState createState() =>
      _CuliInteractionNavigatorState();
}

class _CuliInteractionNavigatorState extends State<CuliInteractionNavigator> {
  final GlobalKey<NavigatorState> appState = GlobalKey<NavigatorState>();
  ScreenshotController screenshotController;
  DeviceInfoPlugin deviceInfo;

  bool inScreenshot = false;
  DateTime startShakeEventTime = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime mostRecentShakeEventTime = DateTime.fromMillisecondsSinceEpoch(0);
  final int timeRequiredForShakeEventInMillis = 300;
  final int minHoldOverShakeEventInMillis = 50;

  Vector3 lowPassValue;
  final accelerometerUpdateInterval = 1.0 / 100;
  final double lowPassKernelWidthInSeconds = 1;
  double shakeDetectionThreshold =
      1.5 * 9.81; // Multiply by gravity to correct for platform differences

  double lowPassFilterFactor;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    selectNotificationSubject.close();
  }

  void _giveFeedback() async {
    if (inScreenshot) return;
    inScreenshot = false;
    // log(mounted ? "mounted" : "not mounted");
    // print(
    //     appState.currentContext != null ? "appstate exists" : "app state null");
    // log('Taking a screenshot at ${ModalRoute.of(appState.currentContext).settings.name}');
    final image = await screenshotController.capture();

    var deviceInfoMap = {};
    if (Platform.isIOS) {
      var osInfo = await deviceInfo.iosInfo;
      deviceInfoMap = {
        'iosVersion': osInfo.utsname.version,
        'machine': osInfo.utsname.machine,
        'release': osInfo.utsname.release,
        'sysnode': osInfo.utsname.sysname,
        'nodenode': osInfo.utsname.nodename,
        'model': osInfo.model,
        'systemVersion': osInfo.systemVersion,
        'system': osInfo.systemName,
        'name': osInfo.name
      };
    } else if (Platform.isAndroid) {
      var osInfo = await deviceInfo.androidInfo;
      deviceInfoMap = {
        'type': osInfo.type,
        'id': osInfo.id,
        'androidVersion': osInfo.version,
        'brand': osInfo.brand,
        'manufacturer': osInfo.manufacturer,
        'device': osInfo.device
      };
    }
    final stateDump = jsonEncode([
      widget.account,
      {'deviceInfo': deviceInfoMap},
      widget.menu,
      widget.menus
    ]);

    Widget notWorkingButton = CupertinoDialogAction(
      child: Text("Something Isn't Working"),
      isDefaultAction: false,
      onPressed: () async {
        // final image = await screenshotController.capture();
        final feedback = AppFeedback(
            imageFile: image,
            type: AppFeedbackType.problem,
            stateDump: stateDump);
        if (image != null) {
          //TODO insert code to upload the image
        }
        //TODO insert code to schedule a survey notification
        Utils.changeScreens(
            context: appState.currentContext,
            routeName: '/feedback/error',
            global: true,
            nextWidget: () => FeedbackScreen(feedback: feedback));
        // Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget feedbackButton = CupertinoDialogAction(
      child: Text("General Feedback"),
      isDefaultAction: false,
      onPressed: () async {
        // final image = await screenshotController.capture();
        final feedback = AppFeedback(
            imageFile: image,
            type: AppFeedbackType.suggestion,
            stateDump: stateDump);
        if (image != null) {
          //TODO insert code to upload the image
        }
        //TODO insert code to schedule a survey notification
        Utils.changeScreens(
            context: appState.currentContext,
            routeName: '/feedback/suggestion',
            global: true,
            nextWidget: () => FeedbackScreen(feedback: feedback));
        // Navigator.of(context, rootNavigator: true).pop();
      },
    );

    Widget cancel = CupertinoDialogAction(
      child: Text("Cancel"),
      isDefaultAction: true,
      onPressed: () async {
        if (image != null) {
          //TODO insert code to upload the image
        }
        //TODO insert code to schedule a survey notification
        Navigator.of(appState.currentContext, rootNavigator: true).pop();
      },
    );

    final alert = CupertinoAlertDialog(
      title: Text('Report a Problem!'),
      actions: [notWorkingButton, feedbackButton, cancel],
    );

    showCupertinoDialog(
      context: appState.currentContext,
      builder: (context) => alert,
    ).then((value) => inScreenshot = false);

    // Navigator.of(context, rootNavigator: true)
    //     .push(MaterialPageRoute<void>(builder: (context) {
    //   return Scaffold(
    //     appBar: AppBar(title: Text('Screenshot'),),
    //     body: Image.file(image),
    //   );
    // }
    // )).then((value) => inScreenshot = false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deviceInfo = DeviceInfoPlugin();
    screenshotController = ScreenshotController();
    lowPassFilterFactor =
        accelerometerUpdateInterval / lowPassKernelWidthInSeconds;
    shakeDetectionThreshold *= shakeDetectionThreshold;
    userAccelerometerEvents.listen((event) {
      // final prevTime = lastUpdate;
      // final timeDifference = lastUpdate.difference(prevTime).inMilliseconds / 1000.0;
      final time = DateTime.now();
      final acceleration = Vector3(event.x, event.y, event.z);
      lowPassValue ??= acceleration;
      lowPassValue += (acceleration - lowPassValue) * lowPassFilterFactor;
      final deltaAcceleration = acceleration - lowPassValue;
      if (deltaAcceleration.distanceToSquared(Vector3.zero()) >=
          shakeDetectionThreshold) {
        // log('Shake event with magnitude ${acceleration.distanceToSquared(Vector3.zero())}detected at time: ${DateTime.now().toIso8601String()}');
        final previousDuration = mostRecentShakeEventTime
            .difference(startShakeEventTime)
            .abs()
            .inMilliseconds;
        if (time.difference(mostRecentShakeEventTime).abs().inMilliseconds >=
            minHoldOverShakeEventInMillis) {
          mostRecentShakeEventTime = time;
          startShakeEventTime = time;
        } else {
          // log('Shake length: $previousDuration');
          mostRecentShakeEventTime = time;
          if (time.difference(startShakeEventTime).abs().inMilliseconds >
                  timeRequiredForShakeEventInMillis &&
              previousDuration <= timeRequiredForShakeEventInMillis) {
            // log('Detected a shake event');
            _giveFeedback();
          }
        }
      }
      // log('Time since last reading: ${timeDifference.toStringAsFixed(3)}s values: $event sqrMagnitude: $sqrMagnitude');
    });
  }

  @override
  Widget build(BuildContext context) {
    GraphQLWrapper.setEndpoints().then((value) => value
        ? log('Endpoint connection successful')
        : log('Endpoint connection failed'));
    if (Platform.isIOS) {
      deviceInfo.iosInfo.then((osInfo) => log({
            'iosVersion': osInfo.utsname.version,
            'machine': osInfo.utsname.machine,
            'release': osInfo.utsname.release,
            'sysnode': osInfo.utsname.sysname,
            'nodenode': osInfo.utsname.nodename,
            'model': osInfo.model,
            'systemVersion': osInfo.systemVersion,
            'system': osInfo.systemName,
            'name': osInfo.name
          }.toString()));
    }
    return Screenshot(
      controller: screenshotController,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: widget.account),
          ChangeNotifierProvider.value(value: widget.menu),
          ChangeNotifierProvider.value(value: widget.menus),
        ],
        child: MaterialApp(
          navigatorKey: appState,
          title: 'Culi Interaction Navigator',
          theme: culiTheme,
          home: TopLevelInitializer(),
        ),
      ),
    );
  }
}
