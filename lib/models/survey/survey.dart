import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../recipe.dart';
import 'choose_many.dart';
import 'follow_up.dart';
import 'free_response.dart';
import 'star_rating.dart';
import 'survey_question.dart';
import 'yes_no.dart' show YesNo;

part 'survey.g.dart';

/// A survey data structure that has 3 different forms to make it easy to
/// create dynamic surveys conditional on previous answers
///
/// Tree: The survey questions are formatted as a list of trees.  Each tree
/// represents all the follow up questions based on a given input.  This cannot
/// be consumed via GraphQL because it has the possibility for infinite
/// recursion--something explicitly not allowed by GraphQL spec.
///
/// Flat Tree: The survey questions are formatted as a list of questions, but
/// there are pointers to reconstitute the edges in the tree representation.
/// This representation still has all the data for all possible paths.
///
/// Flat: Only the survey questions that have been answered are present.  This
/// view represents the order that the user answered questions in the survey.

@JsonSerializable()
class Survey extends ChangeNotifier {
  @JsonKey(required: true)
  List<SurveyQuestion> questions = <SurveyQuestion>[];
  @JsonKey(required: false)
  int answered = 0;
  @JsonKey(required: true)
  SurveyType type = SurveyType.unknown;

  Survey({this.questions, this.answered = 0, this.type = SurveyType.tree}) {
    questions ??= <SurveyQuestion>[];
  }

  Map<String, dynamic> toJson() => _$SurveyToJson(this);

  String toJsonString() => jsonEncode(toJson());

  factory Survey.fromJsonString(String json) =>
      Survey.fromJson(jsonDecode(json));

  factory Survey.fromJson(Map<String, dynamic> json) {
    switch (_$enumDecode(_$SurveyTypeEnumMap, json['type'])) {
      case SurveyType.flatTree:
        return Survey._fromFlatTreeJson(json);
      default:
        return _$SurveyFromJson(json);
    }
  }

  factory Survey.postRecipeDefaultSurvey(Recipe recipe) {
    final questions = <SurveyQuestion>[
      StarRating(
        title: 'What did you think about ${recipe.recipeName}?',
        leftHint: 'Did not like',
        rightHint: 'Excellent',
      ),
      YesNo(
          title: 'Would you make this recipe again?',
          yesFollowUps: FollowUp(questions: <SurveyQuestion>[
            ChooseMany(
                title: 'What were your favorite parts of the recipe?',
                options: [
                  'Creativity',
                  'Final product',
                  'Time to make',
                  'Other'
                ],
                followUps: [
                  FollowUp(),
                  FollowUp(),
                  FollowUp(),
                  FollowUp(questions: <SurveyQuestion>[
                    FreeResponse(
                        title: "Tell us what else you liked about the recipe!")
                  ])
                ])
          ]),
          noFollowUps: FollowUp(questions: <SurveyQuestion>[
            ChooseMany(
                title: 'What did you dislike about the recipe?',
                options: [
                  'Difficulty',
                  'Final product',
                  'Ingredients',
                  'Lack of clarity',
                  'Time to make',
                  'Other'
                ],
                followUps: <FollowUp>[
                  FollowUp(questions: [
                    FreeResponse(
                        title: 'What did you find difficult about the recipe?')
                  ]),
                  FollowUp(questions: [
                    FreeResponse(
                        title: 'Why did you not like the final product?')
                  ]),
                  FollowUp(questions: [
                    ChooseMany(
                        title: 'Which of the ingredients did you not like?',
                        options: recipe.ingredients.map((e) => e.name).toList())
                  ]),
                  FollowUp(questions: [
                    FreeResponse(
                        title: 'Tell us about a moment that you were confused?')
                  ]),
                  FollowUp(questions: [
                    FreeResponse(
                        title: 'What part of the recipe took too long?'),
                    FreeResponse(
                        title:
                            'How much time would you have liked the recipe to take?')
                  ]),
                  FollowUp(questions: [
                    FreeResponse(
                        title: 'Tell us any other thoughts about the recipe!')
                  ]),
                ]),
          ])),
    ];

    return Survey(questions: questions);
  }

  int get depth =>
      questions.map((e) => e.depth).reduce((value, element) => value + element);

  List<SurveyQuestion> get flatSurvey => flatten(questions);

  Map<String, dynamic> toFlatJson() => _$SurveyToJson(
      Survey(questions: flatSurvey, answered: answered, type: SurveyType.flat));

  Map<String, dynamic> toFlatTreeJson() {
    var queue = Queue<SurveyQuestion>.from(questions);
    var flatQuestions = List<SurveyQuestion>.from(questions, growable: true);
    while (queue.isNotEmpty) {
      print('State of queue $queue');
      var top = queue.removeFirst();
      print('Converting ${top.toJson()}');
      for (var followUp in top.allFollowUps) {
        final length = flatQuestions.length;
        // print(followUp.toJson());
        final referencedQuestions = followUp.switchToReference(length);
        flatQuestions.addAll(referencedQuestions);
        queue.addAll(referencedQuestions);
      }
    }
    log("Answered questions $answered");
    return _$SurveyToJson(Survey(
        questions: flatQuestions,
        answered: answered,
        type: SurveyType.flatTree));
  }

  factory Survey._fromFlatTreeJson(Map<String, dynamic> json) {
    final survey = _$SurveyFromJson(json);
    final questionCount = survey.questions.length;
    final lastTopLevelIndex = survey.questions
        .map((e) => e.allFollowUps
            .map((e) => e.switchToInplace(survey))
            .fold(questionCount, math.min))
        .fold(questionCount, math.min);
    print("First non-top level index: $lastTopLevelIndex");
    survey.questions = survey.questions.sublist(0, lastTopLevelIndex);
    survey.type = SurveyType.tree;
    survey.answered = json['answered'];
    return survey;
  }

  @override
  String toString() => toJson().toString();

  dynamic get current => answered < questions.length
      ? questions[answered].current
      : SurveyQuestion.endQuestion;

  int get currentIndex =>
      flatSurvey.indexWhere((element) => identical(current, element));

  dynamic indexedQuestion(int index) {
    final survey = flatSurvey;
    if (index >= survey.length) return SurveyQuestion.endQuestion;
    return survey[index];
  }

  // ignore: avoid_setters_without_getters
  set updateCurrent(dynamic val) {
    if (current.update(val)) notifyListeners();
    // log(toJsonString());
  }

  bool updateIndexed(int index, dynamic val) {
    final updated = flatSurvey[index].update(val);
    if (updated) notifyListeners();
    log(toJson().toString());
    return updated;
  }

  bool completeQuestion(int index) {
    if (index <= currentIndex) {
      log('This question has been answered, not advancing question counter');
      return false;
    }
    if (answered >= questions.length) {
      log('Reached the end of the survey');
      return true;
    } else if (questions[answered].completeQuestion()) {
      answered += 1;
      log('Advancing question counter at top level');
      return true;
    }
    log('True not propagated to the top of the survey');
    return false;
  }
}

enum SurveyType {
  @JsonValue("FLAT_TREE")
  flatTree,
  @JsonValue("FLAT")
  flat,
  @JsonValue("TREE")
  tree,
  @JsonValue("UNKNOWN")
  unknown
}
