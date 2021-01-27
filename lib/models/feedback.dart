import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'feedback.g.dart';

@JsonSerializable()
class AppFeedback {
  AppFeedbackType type;
  List<String> tags;
  String jsonDump;
  String description;
  @JsonKey(ignore: true)
  File imageFile;

  String get feedbackTag => _$AppFeedbackTypeEnumMap[type];

  AppFeedback(
      {@required this.type,
      this.tags = const <String>[],
      this.jsonDump = '',
      this.description = '',
      this.imageFile});

  factory AppFeedback.fromJson(Map<String, dynamic> json) =>
      _$AppFeedbackFromJson(json);

  Map<String, dynamic> toJson() => _$AppFeedbackToJson(this);
}

enum AppFeedbackType {
  @JsonValue("PROBLEM")
  problem,
  @JsonValue("SUGGESTION")
  suggestion
}
