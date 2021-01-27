import 'package:json_annotation/json_annotation.dart';

part 'user_skills.g.dart';

@JsonSerializable()
class UserSkills {
  @JsonKey(defaultValue: <Skill>[])
  List<Skill> skills;

  UserSkills();

  List<Skill> get masteredSkills =>
      skills?.where((element) => element.progress == 1)?.toList() ?? [];

  List<Skill> get inProgressSkills =>
      skills
          ?.where((element) =>
              (element?.progress ?? 0) < 1 && (element?.progress ?? 0) > 0)
          ?.toList() ??
      [];

  List<Skill> get newSkills =>
      skills?.where((element) => element.progress == 0)?.toList() ?? [];

  factory UserSkills.fromJson(Map<String, dynamic> json) =>
      _$UserSkillsFromJson(json);

  Map<String, dynamic> toJson() => _$UserSkillsToJson(this);
}

@JsonSerializable()
class Skill {
  String name;
  double progress;

  Skill();

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  Map<String, dynamic> toJson() => _$SkillToJson(this);
}
