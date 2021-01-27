import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'data_manipulation/gql_interface.dart';
import 'loading_screen.dart';
import 'models/account.dart';
import 'models/menus.dart';
import 'theme.dart';

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

class CuliInteractionNavigator extends StatelessWidget {
  // This widget is the root of your application.
  final Account account;
  final Menus menus;
  final Menu menu;

  CuliInteractionNavigator({this.account, this.menus, this.menu, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    GraphQLWrapper.setEndpoints().then((value) => value
        ? log('Endpoint connection successful')
        : log('Endpoint connection failed'));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: account),
        ChangeNotifierProvider.value(value: menu),
        ChangeNotifierProvider.value(value: menus),
      ],
      child: MaterialApp(
        title: 'Culi Interaction Navigator',
        theme: culiTheme,
        home: TopLevelInitializer(),
      ),
    );
  }
}
