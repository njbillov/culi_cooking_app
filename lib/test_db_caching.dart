import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db_change_notifier.dart';
import 'models/account.dart';
import 'theme.dart';

class TestDatabaseCachingScreen extends StatelessWidget {
  final account = Account();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: account,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<Account>(
                    builder: (context, account, child) => CuliButton(
                          account.accountFlags.toJson().values.toString(),
                          onPressed: () {
                            account.accountFlags.completedOrientation ^= true;
                            log(account.accountFlags.toJson().toString());
                          },
                        )),
                Consumer<Account>(
                  builder: (context, account, child) => CuliButton(
                      account.accountFlags.toJson().values.toString(),
                      onPressed: () {
                    account.accountFlags.verified ^= true;
                    log(account.accountFlags.toJson().toString());
                  }),
                ),
                Consumer<Account>(
                  builder: (context, account, child) =>
                      CuliButton("Notify Listeners", onPressed: () {
                    account.notifyListeners();
                    log(account.accountFlags.toJson().toString());
                  }),
                ),
                Consumer<Account>(
                  builder: (context, account, child) =>
                      CuliButton("Load from cache", onPressed: () async {
                    await account.loadFromCache();
                  }),
                ),
                Consumer<Account>(
                  builder: (context, account, child) => CuliButton(
                    "Clear database",
                    onPressed: () async {
                      await account.bind();
                      await account.db.execute("DELETE FROM $cacheTableName;");
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
