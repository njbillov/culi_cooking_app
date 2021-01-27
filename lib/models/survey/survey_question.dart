import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';

import 'choose_many.dart';
import 'choose_one.dart';
import 'follow_up.dart';
import 'free_response.dart';
import 'star_rating.dart';
import 'yes_no.dart';

part 'survey_question.g.dart';

@JsonSerializable(nullable: false)
class SurveyQuestion {
  String title = '';
  QuestionType type;
  @JsonKey(required: false)
  int answered = 0;
  SurveyQuestion([this.title = '', this.type = QuestionType.invalid]);

  factory SurveyQuestion.fromJson(Map<String, dynamic> json) {
    switch (_$enumDecode(_$QuestionTypeEnumMap, json['type'])) {
      case QuestionType.freeResponse:
        return FreeResponse.fromJson(json);
      case QuestionType.chooseOne:
        return ChooseOne.fromJson(json);
      case QuestionType.chooseMany:
        return ChooseMany.fromJson(json);
      case QuestionType.starRating:
        return StarRating.fromJson(json);
      case QuestionType.yesNo:
        return YesNo.fromJson(json);
      case QuestionType.invalid:
        print("Error");
        break;
      case QuestionType.end:
        return endQuestion;
    }
    return null;
  }

  // ignore: missing_return
  Map<String, dynamic> toJson() {
    log("Converting $type to json");
    switch (type) {
      case QuestionType.end:
      case QuestionType.invalid:
        return _$SurveyQuestionToJson(this);
      case QuestionType.freeResponse:
        return (this as FreeResponse).toJson();
      case QuestionType.chooseOne:
        return (this as ChooseOne).toJson();
      case QuestionType.chooseMany:
        return (this as ChooseMany).toJson();
      case QuestionType.starRating:
        return (this as StarRating).toJson();
      case QuestionType.yesNo:
        return (this as YesNo).toJson();
    }
  }

  int get depth => flatSurvey.length;

  List<SurveyQuestion> get flatSurvey =>
      <SurveyQuestion>[this, ...flatten(children)];

  List<SurveyQuestion> get children => List.empty();

  List<SurveyQuestion> get oneDeepTree => [this, ...children];

  List<FollowUp> get allFollowUps {
    print("Getting follow ups from $type");
    return List.empty();
  }

  dynamic get current => this;

  bool update(dynamic val) {
    log("Error: Trying to use $val to update a generic SurveyQuestion");
    return false;
  }

  static final SurveyQuestion endQuestion =
      SurveyQuestion("end", QuestionType.end);

  bool completeQuestion() {
    if (answered == 0) {
      answered += 1;
    } else if (oneDeepTree[answered].completeQuestion()) answered += 1;
    log('Propagating ${answered >= oneDeepTree.length} up from $title');
    return answered >= oneDeepTree.length;
  }
}

enum QuestionType {
  @JsonValue('INVALID')
  invalid,
  @JsonValue('FREE_RESPONSE')
  freeResponse,
  @JsonValue('CHOOSE_ONE')
  chooseOne,
  @JsonValue('CHOOSE_MANY')
  chooseMany,
  @JsonValue('STAR')
  starRating,
  @JsonValue('YES_NO')
  yesNo,
  @JsonValue('END')
  end
}

List<SurveyQuestion> flatten(List<SurveyQuestion> list) {
  return list
      .map((e) => [
            e,
            ...e.children
                .map((child) =>
                    child.children.isNotEmpty ? flatten([child]) : [child])
                .fold(List.empty(),
                    (previousValue, element) => [...previousValue, ...element])
          ])
      .where((element) => element.isNotEmpty)
      .fold(List.empty(),
          (previousValue, element) => [...previousValue, ...element]);
}
