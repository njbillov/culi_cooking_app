import 'dart:convert';

import 'choose_many.dart';
import 'choose_one.dart';
import 'follow_up.dart';
import 'free_response.dart';
import 'star_rating.dart';
import 'survey.dart';
import 'survey_question.dart';
import 'yes_no.dart';

void main() {
  final survey = Survey();
  prettyPrint(val) => print(JsonEncoder.withIndent('\t').convert(val));
  survey.questions
      .add(StarRating(title: "How many stars would you rate this?"));
  survey.questions
      .add(FreeResponse(title: "What was your favorite part of the meal?"));
  survey.questions
      .add(ChooseOne(title: "What part of the recipe took the longest?"));
  survey.questions.add(
      ChooseMany(title: "Which flavors in the recipe were your favorite?"));

  prettyPrint(survey.toJson());

  final encodedSurvey = survey.toJson();
  (encodedSurvey['questions'] as List<Map<String, dynamic>>).removeLast();
  encodedSurvey.remove('answered');

  final encodedJson = jsonEncode(encodedSurvey);

  print(encodedJson);

  final decodedSurvey = Survey.fromJson(jsonDecode(encodedJson));

  for (final question in decodedSurvey.questions) {
    print(question.runtimeType);
  }

  prettyPrint(survey.toJson());
  print(survey);
  print(survey.depth);
  print(survey.flatSurvey);

  final yesNo = YesNo();
  yesNo.title = "Nested Yes No";
  yesNo.answer = true;
  yesNo.yesFollowUps = FollowUp(questions: <SurveyQuestion>[
    ChooseMany(title: "ChooseMany 1", options: [
      'Zero'
    ], choices: [
      0
    ], followUps: [
      FollowUp(questions: [
        ChooseMany(title: "ChooseMany 2", options: [
          "Zero",
          "One",
          "Two"
        ], choices: [
          0,
          2
        ], followUps: [
          FollowUp(questions: [
            FreeResponse(title: "NestFR1"),
            FreeResponse(title: "NestFR2")
          ]),
          FollowUp(questions: [FreeResponse(title: "NestFR3")]),
          FollowUp(questions: [FreeResponse(title: "NestFR4")]),
        ]),
        FreeResponse(title: "FreeResponse")
      ])
    ])
  ]);

  final survey2 = Survey();
  survey2.questions.add(yesNo);
  survey2.questions.add(StarRating(title: "Star Rating"));
  survey2.answered++;
  yesNo.answered += 2;

  prettyPrint(survey2.toJsonString());
  // print(survey2.depth);
  // print(survey2.flatSurvey.map((e) => e.title).join(", "));
  // print("Going to print a flat tree representation of the json");
  final flatTree = survey2.toFlatTreeJson();

  final fromFlatTree = Survey.fromJson(flatTree);
  prettyPrint(fromFlatTree.toJsonString());
  // prettyPrint(survey2.toJson());

  print(fromFlatTree.toJson() == survey2.toJson());

  print(JsonEncoder().convert(jsonEncode(flatTree)));
  // prettyPrint(flatTree);
}
