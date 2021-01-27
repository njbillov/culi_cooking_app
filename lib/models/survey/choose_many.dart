import 'package:json_annotation/json_annotation.dart';

import 'follow_up.dart';
import 'survey_question.dart';

part 'choose_many.g.dart';

@JsonSerializable()
class ChooseMany extends SurveyQuestion {
  QuestionType type = QuestionType.chooseMany;
  List<String> options = <String>[];
  List<int> choices = <int>[];
  @JsonKey(required: false)
  List<FollowUp> followUps = <FollowUp>[];

  ChooseMany({String title, this.options, this.followUps, this.choices})
      : super(title) {
    options ??= <String>[];
    choices ??= <int>[];
    followUps ??= options.map((e) => FollowUp()).toList();
  }

  @override
  factory ChooseMany.fromJson(Map<String, dynamic> json) =>
      _$ChooseManyFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChooseManyToJson(this);

  @override
  List<SurveyQuestion> get children => choices != null
      ? choices
          .map((e) => followUps[e].questions)
          .fold(List.empty(), (value, element) => [...value, ...element])
      : List.empty();

  @override
  List<FollowUp> get allFollowUps {
    print("Getting follow ups from $type");
    return followUps;
  }

  @override
  dynamic get current {
    if (answered == 0) {
      return this;
    } else if (answered > flatSurvey.length) return SurveyQuestion.endQuestion;
    return flatSurvey[answered].current;
  }

  bool contains(int val) {
    if (choices == null) return false;
    return choices.contains(val);
  }

  @override
  bool update(dynamic val) {
    // final target = current;
    // if(!identical(this, target)) return current.update(val);
    final inputValue = val as int;
    if (contains(inputValue)) {
      choices.remove(inputValue);
    } else {
      choices.add(inputValue);
      choices.sort();
    }
    return true;
  }
}
