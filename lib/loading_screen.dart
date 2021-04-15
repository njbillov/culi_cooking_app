import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/account.dart';
import 'navigation_bar_helpers.dart';
import 'notification_handlers.dart';
import 'signup_introduction.dart';
import 'theme.dart';
import 'utilities.dart';

/// A loading screen at the start of the app to initialize any resources.  This
/// is specifically used to wait until notifications handlers are finished
/// loading.
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
  Future<bool> isInitialized;
  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((payload) async {
      log(payload);
      await handleNotification(context, payload);
    });
  }

  @override
  void initState() {
    super.initState();
    isInitialized = NotificationHandler.instance
        .initializePlugin()
        .then((value) => initializeNotificationHandler())
        .then((value) => _configureSelectNotificationSubject())
        .then((value) => true);
  }

  @override
  void dispose() {
    super.dispose();
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
    log("Loading screen re-rendered");
    return Provider<Future<bool>>.value(
        value: isInitialized, child: LoadingScreen());
  }
}
