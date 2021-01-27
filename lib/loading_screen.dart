import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sensors/sensors.dart';
import 'package:vector_math/vector_math.dart';

import 'feedback.dart';
import 'models/account.dart';
import 'models/feedback.dart';
import 'navigation_bar_helpers.dart';
import 'notification_handlers.dart';
import 'signup_introduction.dart';
import 'theme.dart';
import 'utilities.dart';

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class LoadingScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final account = Provider.of<Account>(context, listen: false);
    final goToSignup = account?.session?.isNotEmpty ?? false;
    log(account?.session ?? 'no account session');
    Provider.of<Future<bool>>(context).then((value) => Utils.changeScreens(
          context: context,
          routeName: '/',
          squash: true,
          nextWidget: () =>
              goToSignup ? NavigationRoot() : NewSignupIntroduction(),
        ));
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Culi.white,
      body: Center(
        child: Container(
          width: size.width * 0.2,
          height: size.width * 0.2,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/culi_icons.png'),
          )),
        ),
      ),
    );
  }
}

class TopLevelInitializer extends StatefulWidget {
  @override
  _TopLevelInitializerState createState() => _TopLevelInitializerState();
}

class _TopLevelInitializerState extends State<TopLevelInitializer> {
  ScreenshotController screenshotController;
  bool inScreenshot = false;
  StreamSubscription _accelerometerStream;
  DateTime startShakeEventTime = DateTime.fromMillisecondsSinceEpoch(0);
  DateTime mostRecentShakeEventTime = DateTime.fromMillisecondsSinceEpoch(0);
  final int timeRequiredForShakeEventInMillis = 300;
  final int minHoldOverShakeEventInMillis = 50;
  Future<bool> isInitialized;

  Vector3 lowPassValue;
  final accelerometerUpdateInterval = 1.0 / 100;
  final double lowPassKernelWidthInSeconds = 1;
  double shakeDetectionThreshold =
      2.0 * 9.81; // Multiply by gravity to correct for platform differences

  double lowPassFilterFactor;

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((payload) async {
      log(payload);
      await handleNotification(context, payload);
    });
  }

  void _giveFeedback() async {
    if (inScreenshot) return;
    inScreenshot = false;
    log('Taking a screenshot at ${ModalRoute.of(context).settings.name}');
    final image = await screenshotController.capture();

    Widget notWorkingButton = CupertinoDialogAction(
      child: Text("Something Isn't Working"),
      isDefaultAction: false,
      onPressed: () async {
        final image = await screenshotController.capture();
        final feedback =
            AppFeedback(imageFile: image, type: AppFeedbackType.problem);
        if (image != null) {
          //TODO insert code to upload the image
        }
        //TODO insert code to schedule a survey notification
        Utils.changeScreens(
            context: context,
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
        final image = await screenshotController.capture();
        final feedback =
            AppFeedback(imageFile: image, type: AppFeedbackType.suggestion);
        if (image != null) {
          //TODO insert code to upload the image
        }
        //TODO insert code to schedule a survey notification
        Utils.changeScreens(
            context: context,
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
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    final alert = CupertinoAlertDialog(
      title: Text('Report a Problem!'),
      actions: [notWorkingButton, feedbackButton, cancel],
    );

    showCupertinoDialog(
      context: context,
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
    super.initState();
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
    isInitialized = NotificationHandler.instance
        .initializePlugin()
        .then((value) => initializeNotificationHandler())
        .then((value) => _configureSelectNotificationSubject())
        .then((value) => true);
  }

  @override
  void dispose() {
    super.dispose();
    log('Disposing');
    selectNotificationSubject.close();
  }

  void initializeNotificationHandler() async {
    var topLevelContext = Navigator.of(context, rootNavigator: true).context;
    var future2 = Future.delayed(Duration(milliseconds: 1500));
    var future1 = NotificationHandler.instance
        .initializeHandlers(topLevelContext)
        .then((value) => log('Notification handler has been initialized'));
    if (NotificationHandler().appLaunchDetails.didNotificationLaunchApp) {
      log('Loading app from a notification');
      if (NotificationHandler.instance.isInitialized) return;
      NotificationHandler.instance.isInitialized = true;
      return;
    }
    await Future.wait([future1, future2]);
    if (NotificationHandler.instance.isInitialized) return;
    NotificationHandler.instance.isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return Provider<Future<bool>>.value(
      value: isInitialized,
      child: Screenshot(
        controller: screenshotController,
        child: MaterialApp(
            title: 'Culi',
            theme: culiTheme,
            initialRoute: '/loading',
            routes: {
              // '/home': (context) => InteractionNavigator(),
              '/loading': (context) => LoadingScreen(),
              // '/selection': (context) => InteractionNavigator(),
              '/introduction': (context) => NewSignupIntroduction(),
              '/onboarding': (context) => NewSignupIntroduction(),
              '/createAccount': (context) => SignupForm1(),
            }),
      ),
    );
  }
}
