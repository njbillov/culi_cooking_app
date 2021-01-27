import 'package:json_annotation/json_annotation.dart';

import 'equipment.dart';
import 'ingredient.dart';
import 'user_skills.dart';

part 'micro_step.g.dart';

@JsonSerializable()
class MicroStep {
  List<Ingredient> ingredients;
  List<Equipment> equipment;
  List<Skill> skills;
  String text;

  MicroStep();

  factory MicroStep.fromJson(Map<String, dynamic> json) =>
      _$MicroStepFromJson(json);

  Map<String, dynamic> toJson() => _$MicroStepToJson(this);
}
