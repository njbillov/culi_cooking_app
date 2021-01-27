import 'package:json_annotation/json_annotation.dart';

import 'survey_question.dart';

part 'free_response.g.dart';

@JsonSerializable()
class FreeResponse extends SurveyQuestion {
  QuestionType type = QuestionType.freeResponse;
  String response = '';
  FreeResponse({String title, this.response}) : super(title) {
    response ??= '';
  }

  @override
  factory FreeResponse.fromJson(Map<String, dynamic> json) =>
      _$FreeResponseFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FreeResponseToJson(this);

  @override
  bool update(dynamic val) {
    // final target = current;
    // if(!identical(this, target)) return current.update;
    if (val.runtimeType != String) return false;
    response = val;
    return false;
  }
}
