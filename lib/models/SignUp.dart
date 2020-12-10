class SignUp {
  static const AMATEUR = 1;
  static const NOVICE = 2;
  static const INTERMEDIATE = 3;
  static const EXPERT = 4;
  int level;
  double frequency;
  double preferredNumberServings;
  String name;
  String email;
  String password;
  List<String> list;

  SignUp({this.level, this.frequency, this.preferredNumberServings, this.name, this.email, this.password});

  Map<String, dynamic> toJson() => {
    'level': level,
    'frequency': frequency,
    'preferredNumberServings': preferredNumberServings,
    'name': name,
    'email': email,
    'password': password,
  };
}