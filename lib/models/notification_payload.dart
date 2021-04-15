import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_payload.g.dart';

/// A serializable payload to tell the app how to navigate when the user
/// clicks in on a notification.
@JsonSerializable()
class NotificationPayload {
  NotificationType type;
  @JsonKey(defaultValue: '')
  String title = '';
  @JsonKey(defaultValue: '')
  String body = '';
  @JsonKey(defaultValue: '')
  String payload;
  @JsonKey(defaultValue: 0)
  int id;
  NotificationPayload(
      {@required this.type,
      @required this.title,
      this.body = '',
      this.payload = '',
      this.id = 0});

  factory NotificationPayload.mealTime(int id) {
    return NotificationPayload(
        type: NotificationType.mealTime,
        title: "It's time to eat!",
        body: "Click in when you're ready to come to the kitchen!",
        id: id,
        payload: '');
  }

  factory NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationPayloadToJson(this);

  String toJsonString() => jsonEncode(toJson());
}

enum NotificationType {
  @JsonValue("SURVEY")
  survey,
  @JsonValue("MAKE_SOCIAL_POST")
  makeSocialPost,
  @JsonValue("SOCIAL")
  social,
  @JsonValue("MEAL_TIME")
  mealTime,
}
