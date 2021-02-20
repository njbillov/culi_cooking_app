import 'package:culi/theme.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_skills.g.dart';

@JsonSerializable()
class UserSkills {
  @JsonKey(defaultValue: <Skill>[])
  List<Skill> skills;

  UserSkills();

  List<Skill> get masteredSkills {
    final masteredSkillsList = skills?.where((element) => element.progress == 1)?.toList() ?? [];
    masteredSkillsList.sort((a, b) => a.name.compareTo(b.name));
    return masteredSkillsList;
  }

  List<Skill> get inProgressSkills {
    final inProgressSkills = skills
            ?.where((element) =>
                (element?.progress ?? 0) < 1 && (element?.progress ?? 0) > 0)
            ?.toList() ??
        [];

    inProgressSkills.sort((a, b) {
      final comp = (b.progress - a.progress).sign.round();
      if (comp == 0) {
        return a.name.compareTo(b.name);
      }
      return comp;
    });
    return inProgressSkills;
  }

  List<Skill> get newSkills {
    final newSkillList =
        skills?.where((element) => element.progress == 0)?.toList() ?? [];

    newSkillList.sort((a, b) => a.name.compareTo(b.name));

    return newSkillList;
  }

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
