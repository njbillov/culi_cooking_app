import 'dart:developer';
import 'dart:io';
import 'dart:math' show Random;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

import 'models/account.dart';
import 'models/menus.dart';
import 'models/notification_payload.dart';
import 'models/recipe.dart';
import 'models/survey/survey.dart';
import 'models/user_skills.dart';
import 'notification_handlers.dart';
import 'theme.dart';
import 'utilities.dart';

class RecipeOverview extends StatelessWidget {
  final Recipe recipe;

  const RecipeOverview({Key key, this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.recipeName,
            style: Theme.of(context).textTheme.headline3),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Center(
              child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < recipe.steps.length; ++i)
                    StepView(recipe: recipe, step: i, navigable: true)
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CuliButton("Start",
                width: size.width * 0.90,
                height: 75,
                color: Culi.accentGreen, onPressed: () {
              recipe.startTime = DateTime.now();
              Utils.changeScreens(
                  routeName: '/recipe/${recipe.recipeId}/step1',
                  nextWidget: () => RecipeStepDetails(
                      recipe: recipe, step: 0, navigable: true),
                  context: context);
            }),
          ),
        ],
      ))),
    );
  }
}

class StepView extends StatelessWidget {
  final Recipe recipe;
  final int step;
  final bool navigable;

  const StepView({Key key, this.recipe, this.step, this.navigable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: InkWell(
        onTap: () => Utils.changeScreens(
            context: context,
            routeName: '/recipe/${recipe.recipeId}/step${step + 1}',
            nextWidget: () => RecipeStepDetails(
                recipe: recipe, step: step, navigable: navigable)),
        child: Container(
            height: 75,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flex(direction: Axis.horizontal, children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.center,
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: Culi.coral,
                        ),
                        child: Text(
                          '${step + 1}',
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              .copyWith(fontSize: 11, color: Colors.white),
                        )),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        recipe.steps[step].name.isNotEmpty
                            ? recipe.steps[step].name
                            : 'Step ${step + 1}',
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(fontWeight: FontWeight.bold)),
                  ),
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Culi.coral,
                    ),
                  ),
                ),
              ]),
            )),
      ),
    );
  }
}

class HowToBar extends StatelessWidget {
  final List<Skill> skills;

  const HowToBar({Key key, this.skills}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                "How-to's",
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CircleList(
              list: skills,
              getLabel: (skill) => skill.name,
              imageSupplier: (skill) => "assets/images/pan.png",
            ),
          )
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String text;

  const ListItem(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: Container(
          child: Row(children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  image: DecorationImage(
                    image: AssetImage("assets/images/knife.png"),
                  )),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                text.toLowerCase().toCamelCase(),
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontSize: 12),
                maxLines: 2,
              ),
            ),
          ),
        )
      ])),
    );
  }
}

class MicroStepWidget extends StatelessWidget {
  final Recipe recipe;
  final int macroStep;
  final int microStep;

  const MicroStepWidget({
    Key key,
    @required this.macroStep,
    @required this.microStep,
    @required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 24.0, right: 16.0),
      child: Container(
          child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          height: 36,
          width: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: Culi.coral,
          ),
          child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "${macroStep + 1}.${microStep + 1}",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              )),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                recipe.steps[macroStep].steps[microStep].text,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(fontSize: 16),
              ),
            ),
          ),
        )
      ])),
    );
  }
}

class RecipeStepDetails extends StatelessWidget {
  final Recipe recipe;
  final int step;
  final bool navigable;

  const RecipeStepDetails(
      {Key key, this.recipe, this.step, this.navigable = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.recipeName,
            style: Theme.of(context).textTheme.headline3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
            child: ListView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                scrollDirection: Axis.vertical,
                children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Step ${step + 1}: ${recipe.steps[step].name}",
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: Culi.coral),
                  textAlign: TextAlign.center,
                ),
              ),
              if (recipe.steps[step].skills.isNotEmpty) ...[
                Divider(thickness: 1),
                HowToBar(
                    skills: recipe.steps[step].steps
                        .expand((element) => element.skills)
                        .toSet()
                        .toList()),
              ],
              Table(
                border: TableBorder.all(color: Colors.black12),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Ingredients",
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: Culi.coral),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Equipment",
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: Culi.coral),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ]),
                  TableRow(children: [
                    Column(
                        children: recipe.steps[step].ingredients
                            .map((e) => e.name)
                            .toSet()
                            .map((e) => ListItem(e))
                            .toList()),
                    Column(
                        children: recipe.steps[step].equipment
                            .map((e) => e.name)
                            .toSet()
                            .map((e) => ListItem(e))
                            .toList())
                  ])
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Steps",
                  style: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: Culi.coral),
                  textAlign: TextAlign.center,
                ),
              ),
              Divider(thickness: 1),
              ...Iterable.generate(recipe.steps[step].steps.length)
                  .map((e) => MicroStepWidget(
                      recipe: recipe, macroStep: step, microStep: e))
                  .toList(),
              Container(
                height: 0.05 * size.height,
              ),
              if (navigable)
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CuliButton(
                          "Back",
                          color: Culi.accentGreen,
                          width: size.width * 0.45,
                          height: 75,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CuliButton(
                          step + 1 < recipe.steps.length
                              ? "Next Step"
                              : "Finish",
                          color: Culi.accentGreen,
                          width: size.width * 0.45,
                          height: 75,
                          onPressed: () {
                            if (step + 1 < recipe.steps.length) {
                              log('Going to the next page of the recipe');
                              Utils.changeScreens(
                                  context: context,
                                  routeName:
                                      '/recipe/${recipe.recipeId}/step${step + 2}',
                                  nextWidget: () => RecipeStepDetails(
                                      recipe: recipe,
                                      step: step + 1,
                                      navigable: navigable));
                            } else {
                              log('Trying to finish the recipe');
                              Utils.changeScreens(
                                  context: context,
                                  routeName:
                                      '/recipe/${recipe.recipeId}/finished',
                                  nextWidget: () =>
                                      RecipeFinishedScreen(recipe: recipe));
                            }
                          },
                        ),
                      )
                    ])
            ])),
      ),
    );
  }
}

class RecipeFinishedScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeFinishedScreen({Key key, @required this.recipe})
      : super(key: key);

  @override
  _RecipeFinishedScreenState createState() => _RecipeFinishedScreenState();
}

class _RecipeFinishedScreenState extends State<RecipeFinishedScreen> {
  File _image;
  final picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);
    print(pickedFile.path);

    print("Media type: ${MediaType.parse(lookupMimeType(pickedFile.path))}");
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void showFinishedDialog() {
    Widget okButton = CupertinoDialogAction(
      child: Text('OK'),
      isDefaultAction: true,
      onPressed: () async {
        if (_image != null) {
          //TODO insert code to upload the image
        }
        //TODO insert code to schedule a survey notification
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context, rootNavigator: true)
            .popUntil((route) => !route.settings.name.startsWith('/recipe'));
        // Utils.changeScreens(
        //     context: context,
        //     routeName: '/',
        //     nextWidget: () => NavigationRoot(title: '/menu')
        // );
      },
    );

    final alert = CupertinoAlertDialog(
      title: Text('Go eat your food!'),
      content: Text('We will ask you what you thought later.'),
      actions: [okButton],
    );

    showCupertinoDialog(
      context: context,
      builder: (context) => alert,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.recipe.recipeName,
              style: Theme.of(context).textTheme.headline3),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Align(
                alignment: Alignment.topCenter,
                child: Column(children: [
                  Container(height: size.height * 0.025),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 8),
                    child: Text("Congratulations, you're done!",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 8),
                    child: Text(
                        "Let's take a picture of your ${widget.recipe.recipeName}, so you can remember all the hard work you just put in.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: AspectRatio(
                          aspectRatio: 3.0 / 4.0,
                          child: _image == null
                              ? Center(
                                  child: Text(
                                    'No image selected.',
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Image.file(
                                  _image,
                                  fit: BoxFit.fitWidth,
                                ),
                        ),
                      ),
                    ),
                  ),
                  // COMEBACK HERE
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CuliButton(
                            "Camera Roll",
                            color: Culi.coral,
                            width: size.width * 0.45,
                            height: 75,
                            onPressed: () => getImage(ImageSource.gallery),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: CuliButton(
                              "Take a picture",
                              color: Culi.coral,
                              width: size.width * 0.45,
                              height: 75,
                              onPressed: () => getImage(ImageSource.camera),
                            )),
                      ]),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<Account>(
                      builder: (context, account, child) => Consumer<Menu>(
                        builder: (context, menu, child) => CuliButton(
                          "I'm done",
                          width: size.width * 0.9,
                          height: 75,
                          onPressed: () {
                            account.completeRecipe(widget.recipe.recipeId);
                            menu.recipes
                                .where(
                                    (e) => e.recipeId == widget.recipe.recipeId)
                                .forEach((element) {
                              element.completed = true;
                            });
                            menu.write();
                            final payload = NotificationPayload(
                                type: NotificationType.survey,
                                title: 'Tell us how you liked your meal!',
                                id: Random().nextInt(1000) + 1000,
                                payload: Survey.postRecipeDefaultSurvey(
                                        widget.recipe)
                                    .toJsonString());
                            NotificationHandler.showNotification(
                                payload: payload,
                                offset: Duration(minutes: 30));
                            if (_image != null) {
                              account.uploadRecipeImage(
                                  image: _image,
                                  recipeId: widget.recipe.recipeId);
                            }
                            showFinishedDialog();
                          },
                        ),
                      ),
                    ),
                  ),
                ]))));
  }
}
