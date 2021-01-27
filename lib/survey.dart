import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'culi_slider.dart';
import 'models/account.dart';
import 'models/survey/choose_many.dart';
import 'models/survey/choose_one.dart';
import 'models/survey/free_response.dart';
import 'models/survey/star_rating.dart';
import 'models/survey/survey.dart';
import 'models/survey/survey_question.dart';
import 'models/survey/yes_no.dart';
import 'theme.dart';
import 'utilities.dart';

class StarRatingSurvey extends StatelessWidget {
  final int index;

  const StarRatingSurvey({Key key, this.index = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Survey", style: Theme.of(context).textTheme.headline3),
        actions: [
          Consumer<Survey>(
            builder: (context, survey, child) => CloseButton(
                onPressed: () async =>
                    await changeSurveyScreens(context, survey, endNow: true)),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<Survey>(
                builder: (context, survey, child) => Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(survey.indexedQuestion(index).title,
                            style: Theme.of(context).textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CuliSlider(
                            initialValue: 3,
                            min: 1,
                            max: 5,
                            sliderUpdate: (val) {
                              survey.updateIndexed(index, val);
                            },
                            leftHint: survey.indexedQuestion(index).leftHint,
                            rightHint: survey.indexedQuestion(index).rightHint,
                          ),
                        ),
                      ),
                      CuliButton(
                        'Continue',
                        height: 75,
                        width: size.width * 0.9,
                        onPressed: () async => await changeSurveyScreens(
                            context, survey,
                            index: index + 1),
                      )
                    ])),
          ),
        ),
      ),
    );
  }
}

class SingleChoiceSurvey extends StatelessWidget {
  final int index;

  const SingleChoiceSurvey({Key key, this.index = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Survey", style: Theme.of(context).textTheme.headline3),
        actions: [
          Consumer<Survey>(
            builder: (context, survey, child) => CloseButton(
                onPressed: () async =>
                    await changeSurveyScreens(context, survey, endNow: true)),
          )
        ],
      ),
      body: SafeArea(
          child: Center(
              child: Consumer<Survey>(
        builder: (context, survey, child) => Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(survey.indexedQuestion(index).title,
                  style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView(
                // shrinkWrap: true,
                children: Iterable.generate(survey.indexedQuestion(index).options.length)
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 24),
                        child: CuliCheckbox(
                            survey.indexedQuestion(index).options[e],
                            selected: survey.indexedQuestion(index).choice == e,
                            onPressed: () => survey.updateIndexed(index, e)),
                      ))
                  .toList(),
              ),
            ),
            CuliButton(
              'Continue',
              height: 75,
              width: size.width * 0.9,
              onPressed: () async =>
                  await changeSurveyScreens(context, survey, index: index + 1),
            )
          ],
        ),
      ))),
    );
  }
}

class MultipleChoiceSurvey extends StatelessWidget {
  final int index;

  const MultipleChoiceSurvey({Key key, this.index = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Survey", style: Theme.of(context).textTheme.headline3),
        actions: [
          Consumer<Survey>(
            builder: (context, survey, child) => CloseButton(
                onPressed: () async =>
                    await changeSurveyScreens(context, survey, endNow: true)),
          )
        ],
      ),
      body: SafeArea(
          child: Center(
              child: Consumer<Survey>(
        builder: (context, survey, child) => Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(survey.indexedQuestion(index).title,
                  style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,),
            ),
            Expanded(
              child: ListView(
                children: Iterable.generate(survey.indexedQuestion(index).options.length)
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 24),
                        child: CuliCheckbox(
                            survey.indexedQuestion(index).options[e],
                            selected: survey.indexedQuestion(index).contains(e),
                            onPressed: () => survey.updateIndexed(index, e)),
                      ))
                  .toList()
              ),
            ),
            CuliButton(
              'Continue',
              height: 75,
              width: size.width * 0.9,
              onPressed: () async =>
                  await changeSurveyScreens(context, survey, index: index + 1),
            )
          ],
        ),
      ))),
    );
  }
}

class FreeResponseSurvey extends StatefulWidget {
  final int index;

  const FreeResponseSurvey({Key key, this.index = 0}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FreeResponseSurveyState();
}

class _FreeResponseSurveyState extends State<FreeResponseSurvey> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Survey", style: Theme.of(context).textTheme.headline3),
        actions: [
          Consumer<Survey>(
            builder: (context, survey, child) => CloseButton(
                onPressed: () async =>
                    await changeSurveyScreens(context, survey, endNow: true)),
          )
        ],
      ),
      body: SafeArea(
          child: Center(
        child: Consumer<Survey>(
          builder: (context, survey, child) => Column(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                survey.indexedQuestion(widget.index).title,
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                    minHeight: size.height * 0.1, maxHeight: size.height * 0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    onChanged: (input) =>
                        survey.updateIndexed(widget.index, input),
                    maxLines: 4,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ),
            ),
            CuliButton(
              'Continue',
              height: 75,
              width: size.width * 0.9,
              onPressed: () async => await changeSurveyScreens(context, survey,
                  index: widget.index + 1),
            )
          ]),
        ),
      )),
    );
  }
}

class YesNoSurvey extends StatelessWidget {
  final int index;

  const YesNoSurvey({Key key, this.index = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Survey", style: Theme.of(context).textTheme.headline3),
        actions: [
          Consumer<Survey>(
            builder: (context, survey, child) => CloseButton(
                onPressed: () async =>
                    await changeSurveyScreens(context, survey, endNow: true)),
          )
        ],
      ),
      body: SafeArea(
          child: Center(
              child: Consumer<Survey>(
        builder: (context, survey, child) => Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              survey.indexedQuestion(index).title,
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              width: size.width
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
            CuliButton(
              'No',
              height: 75,
              width: size.width * 0.45,
              onPressed: () async {
                survey.updateIndexed(index, false);
                await changeSurveyScreens(context, survey, index: index + 1);
              },
            ),
            CuliButton(
              'Yes',
              height: 75,
              width: size.width * 0.45,
              onPressed: () async {
                survey.updateIndexed(index, true);
                await changeSurveyScreens(context, survey, index: index + 1);
              },
            )
          ])
        ]),
      ))),
    );
  }
}

class TestSurveyStarRating extends StatelessWidget {
  final survey = Survey();

  TestSurveyStarRating() {
    final starRating = StarRating(title: "How much did you like the meal?")
      ..leftHint = 'did not like'
      ..rightHint = 'excellent';
    survey.questions.add(starRating);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: survey,
      child: StarRatingSurvey(),
    );
  }
}

class TestSurveyChooseOne extends StatelessWidget {
  final survey = Survey();

  TestSurveyChooseOne() {
    final chooseOne = ChooseOne(
        title: 'What was your favorite part of the meal?',
        options: ['chicken', 'tomato', 'mozzarella']);

    survey.questions.add(chooseOne);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: survey,
      child: SingleChoiceSurvey(),
    );
  }
}

class TestSurveyChooseMany extends StatelessWidget {
  final survey = Survey();

  TestSurveyChooseMany() {
    final chooseMany = ChooseMany(
        title: 'Which Ingredients do you think you would use again?',
        options: ['chicken', 'tomato', 'mozzarella']);

    survey.questions.add(chooseMany);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: survey,
      child: MultipleChoiceSurvey(),
    );
  }
}

class TestMultiQuestionSurvey extends StatelessWidget {
  final survey = Survey();

  TestMultiQuestionSurvey() {
    final starRating = StarRating(
        title: "How much did you like the meal?",
        leftHint: 'did not like',
        rightHint: 'excellent');

    final chooseOne = ChooseOne(
        title: 'What was your favorite part of the meal?',
        options: ['chicken', 'tomato', 'mozzarella']);

    final yesNo = YesNo(
      title: 'Do you think we provide value to your kitchen?',
    );

    final freeResponse =
        FreeResponse(title: "What as your favorite part of the experience?");

    final chooseMany = ChooseMany(
        title: 'Which Ingredients do you think you would use again?',
        options: ['chicken', 'tomato', 'mozzarella']);

    survey.questions
        .addAll([starRating, chooseOne, yesNo, freeResponse, chooseMany]);
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: survey,
      child: nextWidgetType(survey),
    );
  }
}

dynamic nextWidgetType(Survey survey, [int index = 0]) {
  final QuestionType type = survey.indexedQuestion(index).type;
  switch (type) {
    case QuestionType.invalid:
      // TODO: Handle this case.
      log("This was not expected...");
      break;
    case QuestionType.freeResponse:
      return FreeResponseSurvey(index: index);
    case QuestionType.chooseOne:
      return SingleChoiceSurvey(index: index);
    case QuestionType.chooseMany:
      return MultipleChoiceSurvey(index: index);
    case QuestionType.starRating:
      return StarRatingSurvey(index: index);
    case QuestionType.yesNo:
      return YesNoSurvey(index: index);
    case QuestionType.end:
      //TODO do something to break out of the survey here, maybe pop route until not '/survey'
      break;
  }
  return null;
}

void changeSurveyScreens(BuildContext context, Survey survey,
    {int index, bool endNow = false}) async {
  if (endNow) {
    final account = Provider.of<Account>(context, listen: false);
    print(await account.uploadSurvey(survey));
    Navigator.popUntil(
        context, (route) => !route.settings.name.startsWith('/survey'));
    // squash = true;
    return;
  }
  index ??= survey.currentIndex;
  survey.completeQuestion(index);
  log("Change screen to question at index $index");
  log(survey.questions.map((e) => e.title).join(", "));
  log("${survey.flatSurvey}");
  final current = survey.indexedQuestion(index);
  final QuestionType type = current.type;
  log('Moving to a question of type $type');
  Widget Function() nextWidget;
  var squash = false;
  switch (type) {
    case QuestionType.invalid:
      // TODO: Handle this case.
      log("This was not expected...");
      break;
    case QuestionType.end:
      final account = Provider.of<Account>(context, listen: false);
      print(await account.uploadSurvey(survey));
      Navigator.popUntil(
          context, (route) => !route.settings.name.startsWith('/survey'));
      // squash = true;
      return;
    default:
      nextWidget = () => nextWidgetType(survey, index);
  }
  log(current.toJson().toString());
  Utils.changeScreens(
      context: context,
      nextWidget: nextWidget,
      value: survey,
      routeName: '/survey/$index',
      squash: squash);
}
