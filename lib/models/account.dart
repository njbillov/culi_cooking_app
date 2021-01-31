import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mime/mime.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data_manipulation/gql_interface.dart';
import '../db_change_notifier.dart';
import '../meal_scheduler.dart';
import 'feedback.dart';
import 'grocery_list.dart';
import 'menus.dart';
import 'recipe.dart';
import 'sign_up.dart';
import 'survey/survey.dart';
import 'user_skills.dart';

part 'account.g.dart';

@JsonSerializable()
class Account extends DatabaseChangeNotifier {
  String email;
  String name;
  String session;
  @JsonKey(nullable: true)
  AccountFlags accountFlags = AccountFlags();
  @JsonKey(fromJson: notificationMapFromJson, toJson: notificationMapToJson)
  Map<int, tz.TZDateTime> pendingNotificationMap = {};
  UserSkills skills;
  int mealsMade;
  int mealsPerWeek;
  int menuCount;

  tz.TZDateTime getNotificationTime(int day) {
    if (pendingNotificationMap.containsKey(day)) {
      return pendingNotificationMap[day];
    }
    final date = tz.TZDateTime.from(
        DateTime.now()
            .toLocal()
            .add(Duration(days: 1))
            .roundDown(delta: Duration(days: 1))
            .subtract(DateTime.now().timeZoneOffset)
            .add(Duration(days: day, hours: 18)),
        tz.local);
    pendingNotificationMap[day] = date;
    return date;
  }

  static Map<int, tz.TZDateTime> notificationMapFromJson(
      Map<String, dynamic> json) {
    // TODO fix this so that it works if the user crosses time zones
    return json?.map((key, value) {
      log(value.toString());
      String locString = value['locale'];
      log(locString);
      final millis = value['ticks'];
      if (locString == 'UTC') locString = 'Europe/London';
      final location = tz.getLocation(locString);
      final time = tz.TZDateTime.fromMillisecondsSinceEpoch(location, millis);
      return MapEntry(int.parse(key), time);
    });
  }

  static Map<String, dynamic> notificationMapToJson(
      Map<int, tz.TZDateTime> map) {
    return map?.map((key, value) => MapEntry(key.toString(),
        {'locale': tz.local.name, 'ticks': value.millisecondsSinceEpoch}));
  }

  bool notifyEmail(String email) {
    var changed = this.email != email;
    this.email = email;
    if (changed) notifyListeners();
    return changed;
  }

  bool notifyName(String name) {
    var changed = this.name != name;
    this.name = name;
    if (changed) notifyListeners();
    return changed;
  }

  bool notifySession(String session) {
    var changed = this.session != session;
    this.session = session;
    if (changed) notifyListeners();
    return changed;
  }

  bool notifyAccountFlags(AccountFlags accountFlags) {
    var changed = this.accountFlags != accountFlags;
    this.accountFlags = accountFlags;
    if (changed) notifyListeners();
    return changed;
  }

  bool scheduleNotification(int id, tz.TZDateTime time) {
    if (time.isBefore(tz.TZDateTime.now(tz.local))) return false;
    pendingNotificationMap ??= <int, tz.TZDateTime>{};
    var existingNotification = pendingNotificationMap.containsKey(id);
    pendingNotificationMap[id] = time;
    log('Pending notifications ${pendingNotificationMap.toString()}');
    write();
    return existingNotification;
  }

  Account() : super(key: 'account');

  Map<String, dynamic> get credentials => {'session': session};

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);

  Future<dynamic> createAccount({@required SignUp signupForm}) async {
    final query = r'''
      mutation createAccount($form: PasswordForm!) {
        createAccount(passwordForm: $form) {
          ok,
          code,
          session
        }
      }
    ''';
    final variables = {'form': signupForm.createAccountJson};
    log('Create account parameter dict: $variables');
    final results = await GraphQLWrapper.mutate(query, variables: variables);
    log('Results: $results');
    final accountResults = results['createAccount'];
    if (!accountResults['ok']) return accountResults;
    mealsPerWeek = signupForm.frequency.round();
    menuCount = 2;
    name = signupForm.name;
    email = signupForm.email;
    session = accountResults['session'];
    skills = UserSkills();
    accountFlags = AccountFlags();
    getSkills().then((value) => write());
    return accountResults;
  }

  Future<dynamic> login({@required Map<String, dynamic> login}) async {
    log(login.toString());
    final query = r'''
    mutation loginRequest($email:String!, $password:String!){
      login(email:$email, passwordInput:$password) {
        ok
        account {
          skills {
            name
            progress
          }
          mealsMade
          accountFlags {
            completedOrientation
            verified
          }
          name
          email
          session
        }
      }
    }
    ''';
    final results = await GraphQLWrapper.mutate(query, variables: login);
    log(results.toString());
    if (!results['login']['ok']) return results;
    copyFromJson(results['login']['account']);
    return results;
  }

  Future<dynamic> logout() async {
    final query = r'''
      mutation logout($session: String!) {
        logout(session: $session) {
          ok
        }
      }
    ''';
    final variables = credentials;
    final results = await GraphQLWrapper.mutate(query, variables: variables);
    if (results['logout']['ok']) session = null;
    return results;
  }

  Future<GroceryList> getGroceryList() async {
    final query = r'''
    query getGroceryList($session: String!) {
      account(session: $session) {
        groceryList
      }
    }
    ''';

    final results =
        await GraphQLWrapper.query(query, variables: {'session': session});
    Map<String, dynamic> groceries = results['account']['groceryList'];
    final groceryList = GroceryList.fromJson(groceries);
    return groceryList;
  }

  Future<UserSkills> getSkills() async {
    final query = r'''
    query getSkills($session: String!) {
      account(session: $session) {
        skills {
          name
          progress        
        }
        mealsMade
      }
    }
    ''';

    final results =
        await GraphQLWrapper.query(query, variables: {'session': session});
    Map<String, dynamic> skills = results['account'];
    var userSkills = UserSkills.fromJson(skills);
    this.skills = userSkills;
    mealsMade = skills['mealsMade'];
    // log('Skills: ${skills.toString()} -> ${userSkills.toJson().toString()}');
    return userSkills;
  }

  Future<bool> uploadSurvey(Survey survey) async {
    final query = r'''
      mutation uploadSurvey($survey:String!, $session: String!){
        uploadSurvey(survey: $survey, session: $session){
          ok
        }
    }
    ''';
    final flatTree = survey.toFlatTreeJson();
    final answered = flatTree['answered'];
    final questions = flatTree['questions'];
    flatTree['questions'] = (flatTree['questions'] as List)
        .sublist(0, math.min(answered + 1, questions.length));
    log('Truncated questions ${flatTree["questions"]}');
    print('This is a the flat tree representation: $flatTree');
    final variables = {
      'survey': JsonEncoder().convert(flatTree),
      'session': session
    };
    final results = await GraphQLWrapper.mutate(query, variables: variables);
    return results['uploadSurvey']['ok'];
  }

  Future<Recipe> getRecipe(int recipeId) async {
    final query = r'''
      query getRecipe($recipeId: Int!) {
        recipe(recipeId: $recipeId) {
          recipeName
          recipeId
          ingredients {
            name
            quantity
            unit
          }
          equipment {
            name
            quantity
          }
          steps {
            name
            steps {
              ingredients {
                name
                quantity
                unit
              }
              equipment {
                name
                quantity
              }
              skills {
                name
              }
              text 
            }
          }
          timeEstimate
          description
          thumbnailUrl
          splashUrl
        }
      }
      ''';

    final results =
        await GraphQLWrapper.query(query, variables: {'recipeId': recipeId});
    Map<String, dynamic> recipeMap = results['recipe'];
    final recipe = Recipe.fromJson(recipeMap);
    return recipe;
  }

  Future<Menus> requestMenus(
      {int recipeCount, int menuCount, bool override = false}) async {
    recipeCount ??= mealsPerWeek ?? 3;
    menuCount ??= this.menuCount ?? 2;
    final query = r'''
      mutation requestMenus($recipeCount: Int!, $menuCount: Int!, $session: String!, $override: Boolean) {
        requestMenus(recipeCount: $recipeCount, menuCount: $menuCount, session: $session, override: $override) {
          ok
          menus {
            recipes {
              recipeName
              recipeId
              equipment {
                name 
                quantity
              }
              ingredients {
                name
                unit
                quantity
              }
              steps {
              name
                steps {
                  ingredients {
                    name
                    quantity
                    unit
                  }
                  equipment {
                    name
                    quantity
                  }
                  skills {
                    name
                  }
                  text 
                }
              }
              timeEstimate
              description
              thumbnailUrl
              splashUrl
            }
          }
        }
      }
    ''';
    final variables = {
      'recipeCount': recipeCount,
      'menuCount': menuCount,
      'session': session,
      'override': override,
    };
    log('Request Menus parameter dictionary: $variables');
    final results = await GraphQLWrapper.mutate(query, variables: variables);
    Map<String, dynamic> menuMap = results['requestMenus'];
    // log(results.toString());
    final menus = Menus.fromJson(menuMap);
    log('Menus initialized with length of ${menus.menus.length}');
    return menus;
  }

  Future<Menus> getMenus() async {
    final query = r'''
      query requestMenus($session: String!) {
        account(session: $session) {
           menus {
            recipes {
              recipeName
              recipeId
              equipment {
                name 
                quantity
              }
              ingredients {
                name
                unit
                quantity
              }
              steps {
              name
                steps {
                  ingredients {
                    name
                    quantity
                    unit
                  }
                  equipment {
                    name
                    quantity
                  }
                  skills {
                    name
                  }
                  text 
                }
              }
              timeEstimate
              description
              thumbnailUrl
              splashUrl
            }
          }
        }
      }
    ''';
    final results =
        await GraphQLWrapper.query(query, variables: {'session': session});
    log(results?.toString()?.substring(200) ?? "Getting menus failed");
    Map<String, dynamic> menuMap = results['account'];
    // log("Ingredients for the first menu: ${menuMap[0]['ingredients']}");
    final menus = Menus.fromJson(menuMap);
    return menus;
  }

  Future<bool> uploadRecipeImage(
      {@required File image, @required int recipeId}) async {
    final imageBytes = await image.readAsBytes();
    final mediaType = MediaType.parse(lookupMimeType(image.path));
    final filename = '';
    var fileUpload = MultipartFile.fromBytes('photo', imageBytes,
        filename: filename, contentType: mediaType);

    final query = r'''
    mutation uploadRecipeImage($file: Upload!, $recipeId: Int!, $session: String!) {
      uploadRecipeImage(image: $file, recipeId: $recipeId, session: $session) {
        ok
      }
    }
    ''';

    final variables = {
      'file': fileUpload,
      'session': session,
      'recipeId': recipeId
    };
    final results = await GraphQLWrapper.mutate(query, variables: variables);
    final bool ok = results['uploadRecipeImage']['ok'];
    log('Upload status: ${ok ? 'success' : 'failure'}');
    return ok;
  }

  Future<bool> completeRecipe(int recipeId) async {
    final query = r'''
      mutation completeRecipe($recipeId: Int!, $session: String!) {
        completeRecipe(recipeId: $recipeId, session: $session) {
          ok
        }
      }
    ''';

    final results = await GraphQLWrapper.mutate(query,
        variables: {'recipeId': recipeId, 'session': session});
    log(results.toString());
    final bool ok = results['completeRecipe']['ok'];
    log('Complete recipe status: ${ok ? 'success' : 'failure'}');
    return ok;
  }

  Future<bool> submitFeedback({@required AppFeedback feedback}) async {
    final imageBytes = await feedback.imageFile.readAsBytes();
    print("Read in image");
    // final filename = '${DateTime.now().millisecondsSinceEpoch}-${hashList(imageBytes)}';
    final mediaType = MediaType.parse(lookupMimeType(feedback.imageFile.path));
    log('mediaType: $mediaType');
    final filename = '';
    var fileUpload = MultipartFile.fromBytes('photo', imageBytes,
        filename: filename, contentType: mediaType);
    print("Made multipart file upload");

    final query = r'''
    mutation uploadFeedback($file: Upload!, $description: String!, $tags: [String!], $stateDump: String!, $session: String!, $feedbackType: String!) {
      uploadFeedback(file: $file, description: $description, tags: $tags, state: $stateDump, session: $session, feedbackType: $feedbackType) {
        ok
      }
    }
    ''';
    final tags = feedback.tags;
    final variables = {
      'session': session ?? '',
      'description': feedback.description,
      'tags': tags,
      'stateDump': feedback.stateDump,
      'file': fileUpload,
      'feedbackType': feedback.feedbackTag
    };
    // log(feedback.stateDump.substring(0, 200));
    final results = await GraphQLWrapper.mutate(query, variables: variables);
    log(results.toString());
    final bool ok = results['uploadFeedback']['ok'];
    log('Upload status: ${ok ? 'success' : 'failure'}');
    return ok;
  }

  @override
  void copyFromJson(Map<String, dynamic> json) {
    email = json['email'] as String;
    session = json['session'] as String;
    name = json['name'] as String;
    pendingNotificationMap =
        notificationMapFromJson(json['pendingNotificationMap']);
    mealsMade = json['mealsMade'] as int;
    if (json['skills'] != null) {
      log(json['skills'].toString());
      if (json['skills'].runtimeType == <dynamic>[].runtimeType) {
        skills = UserSkills.fromJson({'skills': json['skills']});
      } else {
        skills = UserSkills.fromJson(json['skills']);
      }
    } else {
      skills = UserSkills();
    }
    log('flags: ${json["accountFlags"]}');
    if (json['accountFlags'] != null) {
      accountFlags = AccountFlags.fromJson(json['accountFlags']);
    } else {
      accountFlags = AccountFlags();
    }
    notifyListeners();
  }
}

@JsonSerializable()
class AccountFlags {
  @JsonKey(defaultValue: false)
  bool completedOrientation = false;
  @JsonKey(defaultValue: false)
  bool verified = false;

  AccountFlags();

  factory AccountFlags.fromJson(Map<String, dynamic> json) =>
      _$AccountFlagsFromJson(json);

  Map<String, dynamic> toJson() => _$AccountFlagsToJson(this);
}
