import 'package:json_annotation/json_annotation.dart';

import 'survey.dart';
import 'survey_question.dart';

part 'follow_up.g.dart';

@JsonSerializable()
class FollowUp {
  @JsonKey(name: 'questions', required: false, includeIfNull: false)
  List<SurveyQuestion> _questions;
  @JsonKey(name: 'start', required: false)
  int start;
  @JsonKey(name: 'length', required: false)
  int length;
  @JsonKey(required: true)
  FollowUpType type;

  // Returns the underlying survey questions that are now referenced to by this
  // instance
  List<SurveyQuestion> switchToReference(int start) {
    assert(type == FollowUpType.inplace);
    // print(toJson());
    if (type == FollowUpType.reference) return List.empty();
    length = _questions.length;
    type = FollowUpType.reference;
    this.start = start;
    final tempQuestions = _questions;
    _questions = List.empty();
    return tempQuestions;
  }

  factory FollowUp.fromJson(Map<String, dynamic> json) =>
      _$FollowUpFromJson(json);

  Map<String, dynamic> toJson() => _$FollowUpToJson(this);

  FollowUp({List<SurveyQuestion> questions, this.start, this.length}) {
    if (questions != null) {
      _questions = questions;
      type = FollowUpType.inplace;
    } else if (start != null && length != null) {
      type = FollowUpType.reference;
    }
    _questions ??= List.empty();
    type = FollowUpType.inplace;
  }

  List<SurveyQuestion> get questions => _questions;

  int switchToInplace(Survey survey) {
    assert(type == FollowUpType.reference);
    final oldStart = start;
    _questions = survey.questions.sublist(start, start + length);
    start = null;
    length = null;
    type = FollowUpType.inplace;
    return oldStart;
  }
}

enum FollowUpType {
  @JsonValue("INPLACE")
  inplace,
  @JsonValue("REFERENCE")
  reference
}
