import 'package:json_annotation/json_annotation.dart';

import 'follow_up.dart';
import 'survey_question.dart';

part 'star_rating.g.dart';

@JsonSerializable()
class StarRating extends SurveyQuestion {
  QuestionType type = QuestionType.starRating;
  double rating;
  @JsonKey(required: false)
  FollowUp followUps;
  List<StarCondition> followUpCondition = <StarCondition>[];
  String leftHint = '';
  String rightHint = '';

  StarRating(
      {String title,
      this.followUps,
      this.followUpCondition,
      this.leftHint,
      this.rightHint})
      : super(title) {
    leftHint ??= '';
    rightHint ??= '';
    followUpCondition ??= <StarCondition>[];
    followUps ??= FollowUp();
  }

  @override
  factory StarRating.fromJson(Map<String, dynamic> json) =>
      _$StarRatingFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return _$StarRatingToJson(this);
  }

  @override
  List<FollowUp> get allFollowUps {
    print("Getting follow ups from $type");
    return [followUps];
  }

  @override
  List<SurveyQuestion> get children => followUpCondition != null
      ? Iterable.generate(followUpCondition.length)
          .where((element) => followUpCondition[element].test(rating.round()))
          .map((e) => followUps.questions[e])
          .toList()
      : List.empty();

  @override
  dynamic get current {
    if (answered == 0) {
      return this;
    } else if (answered >= flatSurvey.length) return SurveyQuestion.endQuestion;
    return flatSurvey[answered].current;
  }

  @override
  bool update(dynamic val) {
    // final target = current;
    // if(!identical(this, target)) return current.update(val);
    if (rating == val) return false;
    rating = val;
    return true;
  }
}

@JsonSerializable()
class StarCondition {
  int upperBound;
  int lowerBound;

  StarCondition();

  Map<String, dynamic> toJson() => _$StarConditionToJson(this);

  factory StarCondition.fromJson(Map<String, dynamic> json) =>
      _$StarConditionFromJson(json);

  bool test(int rating) => rating < upperBound && rating >= lowerBound;
}
