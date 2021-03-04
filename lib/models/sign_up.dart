import 'dart:developer';

import 'package:flutter/material.dart';

class SignUp extends ChangeNotifier {
  static const amateur = 1;
  static const novice = 2;
  static const intermediate = 3;
  static const expert = 4;
  int _level = 0;
  double _frequency = 3;
  double _preferredNumberServings = 0;
  String _name;
  String _email;
  String _password;
  List<String> _restrictions = [];
  List<String> list;

  List<String> get restrictions => _restrictions;

  set restrictions(List<String> newRestrictions) {
    _restrictions = newRestrictions;
    log(toJson().toString());
    notifyListeners();
  }

  int get level => _level;

  set level(int newLevel) {
    _level = newLevel;
    log(toJson().toString());
    notifyListeners();
  }

  double get frequency => _frequency;

  set frequency(double freq) {
    _frequency = freq;
    log(toJson().toString());
    notifyListeners();
  }

  double get preferredNumberServings => _preferredNumberServings;

  set preferredNumberServings(double servings) {
    _preferredNumberServings = servings;
    log(toJson().toString());
    notifyListeners();
  }

  String get name => _name;

  set name(String newName) {
    _name = newName;
    log(toJson().toString());
    notifyListeners();
  }

  String get email => _email;

  set email(String newEmail) {
    _email = newEmail;
    log(toJson().toString());
    notifyListeners();
  }

  String get password => _password;

  set password(String newPassword) {
    _password = newPassword;
    log(toJson().toString());
    notifyListeners();
  }

  Map<String, dynamic> toJson() => {
        'level': level,
        'frequency': frequency,
        'preferredNumberServings': preferredNumberServings,
        'name': name,
        'email': email,
        'password': password,
        'restrictions': restrictions,
      };

  Map<String, dynamic> get createAccountJson =>
      {'name': name, 'email': email, 'passwordInput': password};

  Map<String, dynamic> get loginJson => {'email': email, 'password': password};
}
