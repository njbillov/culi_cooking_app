import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../data_manipulation/gql_interface.dart';
import '../db_change_notifier.dart';
import '../theme.dart';

part 'change_log.g.dart';

final _currentBuild = ChangeLog(major: 0, minor: 0, patch: 5, build: 0);

@JsonSerializable()
class ChangeLog extends DatabaseChangeNotifier
    implements Comparable<ChangeLog> {
  int major;
  int minor;
  int patch;
  int build;
  List<String> majorChanges;
  List<String> minorChanges;
  List<String> patchChanges;
  List<String> buildChanges;
  ChangeLog({this.major = 0, this.minor = 0, this.patch = 0, this.build = 0})
      : super(key: "buildVersion");

  ChangeLog.fromVersion(String buildVersion) {
    final tokens = buildVersion.split('.').map(int.parse).toList();
    if (tokens.isNotEmpty) {
      major = tokens[0];
    }
    if (tokens.length > 1) {
      minor = tokens[1];
    }
    if (tokens.length > 2) {
      patch = tokens[2];
    }
    if (tokens.length > 3) {
      build = tokens[3];
    }
  }

  String get buildString => '$major.$minor.$patch.$build';

  String get shortBuild {
    if (build == 0 && patch == 0 && minor == 0) {
      return "$major";
    } else if (build == 0 && patch == 0) {
      return "$major.$minor";
    } else if (build == 0) {
      return "$major.$minor.$patch";
    }
    return buildString;
  }

  factory ChangeLog.fromJson(Map<String, dynamic> json) =>
      _$ChangeLogFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeLogToJson(this);

  Future fetchUpdates(BuildContext context) async {
    final query = r'''
      query getAppUpdates($build: String!) {
        changeLog(appVersion: $build) {
          major
          minor
          patch
          build
          majorChanges
          minorChanges
          patchChanges
          buildChanges
         }
      }
    ''';

    final results =
        await GraphQLWrapper.query(query, variables: {'build': buildString});
    log(results.toString());
    List<dynamic> changelogs = results['changeLog'] ?? [];

    var parsedChangelogs =
        changelogs.map((e) => ChangeLog.fromJson(e)).toList();

    parsedChangelogs.sort();
    parsedChangelogs = parsedChangelogs.reversed
        .where((e) => e.majorChanges.isNotEmpty || e.minorChanges.isNotEmpty)
        .where((e) => e.compareTo(_currentBuild) <= 0)
        .toList();
    if (parsedChangelogs.isNotEmpty) {
      final displaySucceeded = await displayUpdates(context, parsedChangelogs);
      if (!displaySucceeded) return;
      final newChangeLog = parsedChangelogs.first;
      this
        ..major = newChangeLog.major
        ..minor = newChangeLog.minor
        ..patch = newChangeLog.patch
        ..build = newChangeLog.build;

      write();
    }
  }

  List<Widget> renderChangeLog(BuildContext context) {
    return [
      Text("Release Notes v$shortBuild",
          style: Theme.of(context).textTheme.headline3),
      if (majorChanges.isNotEmpty) ...[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          child: Text("Major Changes",
              style:
                  Theme.of(context).textTheme.headline3.copyWith(fontSize: 16)),
        ),
        ...majorChanges
            .map((e) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: Text('• $e',
                      style: Theme.of(context).textTheme.bodyText1),
                ))
            .toList()
      ],
      if (minorChanges.isNotEmpty) ...[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          child: Text("Minor Changes",
              style:
                  Theme.of(context).textTheme.headline3.copyWith(fontSize: 16)),
        ),
        ...minorChanges
            .map((e) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                  child: Text('• $e',
                      style: Theme.of(context).textTheme.bodyText1),
                ))
            .toList()
      ]
    ];
  }

  Future<bool> displayUpdates(
      BuildContext context, List<ChangeLog> changes) async {
    final size = MediaQuery.of(context).size;
    showCupertinoDialog(
        context: context,
        builder: (context) => Center(
              child: Container(
                  height: size.height * 0.8,
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Text(
                        "What's new",
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(fontSize: 28),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: changes
                                  .expand((e) => e.renderChangeLog(context))
                                  .toList()),
                        ),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CuliButton(
                        "Acknowledge",
                        height: 75,
                        onPressed: Navigator.of(context).pop,
                      ),
                    )
                  ])),
            ),
        barrierDismissible: true);
    return true;
  }

  int compareTo(ChangeLog other) {
    final o = other;
    if (major != o.major) {
      return major - o.major;
    } else if (minor != o.minor) {
      return minor - o.minor;
    } else if (patch != o.patch) {
      return patch - o.patch;
    } else if (build != o.build) {
      return build - o.build;
    }
    return 0;
  }

  @override
  void copyFromJson(Map<String, dynamic> json) {
    // TODO: implement copyFromJson
    final changeLog = ChangeLog.fromJson(json);
    this
      ..major = changeLog.major
      ..minor = changeLog.minor
      ..patch = changeLog.patch
      ..build = changeLog.build;
  }
}
