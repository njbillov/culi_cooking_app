import 'package:json_annotation/json_annotation.dart';

import 'follow_up.dart';
import 'survey_question.dart';

part 'yes_no.g.dart';

@JsonSerializable()
class YesNo extends SurveyQuestion {
  QuestionType type = QuestionType.yesNo;
  @JsonKey(required: false)
  FollowUp yesFollowUps;
  @JsonKey(required: false)
  FollowUp noFollowUps;
  bool answer;

  YesNo({String title, this.yesFollowUps, this.noFollowUps, this.answer})
      : super(title) {
    yesFollowUps ??= FollowUp();
    noFollowUps ??= FollowUp();
  }

  factory YesNo.fromJson(Map<String, dynamic> json) => _$YesNoFromJson(json);

  Map<String, dynamic> toJson() => _$YesNoToJson(this);

  @override
  List<SurveyQuestion> get children {
    if (answer != null) {
      return answer ? yesFollowUps.questions : noFollowUps.questions;
    }
    return List.empty();
  }

  @override
  dynamic get current {
    if (answered == 0) {
      return this;
    } else if (answered > flatSurvey.length) return SurveyQuestion.endQuestion;
    return flatSurvey[answered].current;
  }

  @override
  List<FollowUp> get allFollowUps {
    print("Getting follow ups from $type");
    return [yesFollowUps, noFollowUps];
  }

  @override
  bool update(dynamic val) {
    // final target = current;
    // if(!identical(this, target)) return current.update(val);
    if (val.runtimeType != bool) return false;
    if (answer == val) return false;
    answer = val;
    return true;
  }
}
