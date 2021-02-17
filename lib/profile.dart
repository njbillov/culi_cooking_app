import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/account.dart';
import 'models/menus.dart';
import 'signup_introduction.dart';
import 'theme.dart';
import 'utilities.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Account>(context, listen: true);
    account.getSkills();
    final menus = Provider.of<Menus>(context, listen: false);
    final menu = Provider.of<Menu>(context, listen: false);
    log(account.pendingNotificationMap.toString());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh_outlined, color: Culi.coral),
              onPressed: () {
                account
                    .updateMenus(menus, menu, force: true)
                    .then((value) => menu.notifyListeners());
                log("Requesting menu update");
              },
            ),
            IconButton(
              icon: Icon(Icons.info, color: Culi.coral),
              onPressed: () {
                showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                          title: Text('Account actions'),
                          actions: [
                            CupertinoDialogAction(
                              child: Text('Logout'),
                              isDestructiveAction: true,
                              onPressed: () async {
                                account.purge();
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                Utils.changeScreens(
                                  context: context,
                                  nextWidget: () => NewSignupIntroduction(),
                                  routeName: '/signup',
                                  squash: true,
                                );
                              },
                            ),
                            CupertinoDialogAction(
                              child: Text('Cancel'),
                              isDefaultAction: true,
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            )
                          ],
                        ));
              },
            )
          ],
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Culi.whiter,
        body: SafeArea(
          child: Center(
              child: ListView(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CuliAnnotatedCircle(
                diameter: 105,
                innerDiameter: 70,
                imageName: "assets/images/whitechefhat.png",
                annotate: false,
                backgroundColor: Culi.coral,
                outlined: false,
                labelText: "Me",
                fontSize: Theme.of(context).textTheme.headline2.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Meals made",
                            style: Theme.of(context).textTheme.bodyText1),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 4.0),
                                child: Consumer<Account>(
                                  builder: (context, account, child) => Text(
                                    (account?.mealsMade ?? 0).toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Culi.coral),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 4.0),
                                child: Icon(Icons.check_circle_rounded,
                                    color: Culi.coral),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Mastered Skills",
                            style: Theme.of(context).textTheme.bodyText1),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 6.0),
                          child: Consumer<Account>(
                            builder: (context, account, child) => Text(
                              account?.skills?.masteredSkills?.length
                                      ?.toString() ??
                                  '0',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Culi.coral),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                child: IconBeforeTitle(
                  "Mastered Skills",
                  assetName: "assets/images/ChefHat.png",
                )),
            Consumer<Account>(
              builder: (context, account, child) => CircleList(
                height: 125,
                list: account?.skills?.masteredSkills ?? [],
                backgroundColor: Colors.white,
                getLabel: (item) => item.name,
                imageSupplier: (_) => "assets/images/pan.png",
                innerDiameter: 40,
                outlineColor: Culi.coral,
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                child: IconBeforeTitle(
                  "Skills in Progress",
                  assetName: "assets/images/InProgress.png",
                )),
            Consumer<Account>(
              builder: (context, account, child) => CircleList(
                height: 125,
                list: account?.skills?.inProgressSkills ?? [],
                backgroundColor: Colors.white,
                getLabel: (item) => item.name,
                imageSupplier: (_) => "assets/images/pan.png",
                getProgress: (skill) => skill.progress,
                innerDiameter: 40,
                outlineColor: Culi.black,
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                child: IconBeforeTitle(
                  "New Skills",
                  assetName: "assets/images/NewSkills.png",
                )),
            Consumer<Account>(
              builder: (context, account, child) => CircleList(
                height: 125,
                list: account?.skills?.newSkills ?? [],
                backgroundColor: Colors.white,
                getLabel: (item) => item.name,
                imageSupplier: (_) => "assets/images/pan.png",
                innerDiameter: 40,
                outlineColor: Culi.black,
              ),
            ),
          ])),
        ));
  }
}

class IconBeforeTitle extends StatelessWidget {
  final String assetName;
  final String title;
  final double diameter;

  const IconBeforeTitle(this.title,
      {Key key, this.assetName, this.diameter = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: diameter,
              height: diameter,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(assetName),
                fit: BoxFit.contain,
              )),
            ),
          ),
          Text(title, style: Theme.of(context).textTheme.headline5)
        ]);
  }
}
