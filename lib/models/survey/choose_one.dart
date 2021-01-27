import 'package:json_annotation/json_annotation.dart';

import 'follow_up.dart';
import 'survey_question.dart';

part 'choose_one.g.dart';

@JsonSerializable()
class ChooseOne extends SurveyQuestion {
  QuestionType type = QuestionType.chooseOne;
  List<String> options = <String>[];
  @JsonKey(required: false)
  List<FollowUp> followUps = <FollowUp>[];
  int choice;

  ChooseOne({String title, this.options, this.followUps}) : super(title) {
    options ??= <String>[];
    followUps ??= options.map((e) => FollowUp()).toList();
  }

  @override
  factory ChooseOne.fromJson(Map<String, dynamic> json) =>
      _$ChooseOneFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChooseOneToJson(this);

  @override
  List<SurveyQuestion> get children =>
      choice != null ? followUps[choice].questions : List.empty();

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
    return followUps;
  }

  @override
  bool update(dynamic val) {
    // final target = current;
    // if(!identical(this, target)) return current.update(val);
    final inputValue = val as int;
    if (choice == inputValue) return false;
    choice = inputValue;
    return true;
  }
}
