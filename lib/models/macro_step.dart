import 'package:json_annotation/json_annotation.dart';

import 'equipment.dart';
import 'ingredient.dart';
import 'micro_step.dart';
import 'user_skills.dart';

part 'macro_step.g.dart';

@JsonSerializable()
class MacroStep {
  List<MicroStep> steps;
  String name;

  MacroStep();

  factory MacroStep.fromJson(Map<String, dynamic> json) =>
      _$MacroStepFromJson(json);

  List<Ingredient> get ingredients =>
      steps.expand((element) => element.ingredients).toSet().toList();

  List<Equipment> get equipment =>
      steps.expand((element) => element.equipment).toSet().toList();

  List<Skill> get skills =>
      steps.expand((element) => element.skills).toSet().toList();

  Map<String, dynamic> toJson() => _$MacroStepToJson(this);
}
