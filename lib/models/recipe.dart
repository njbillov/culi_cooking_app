import 'package:json_annotation/json_annotation.dart';

import 'equipment.dart';
import 'ingredient.dart';
import 'macro_step.dart';

part 'recipe.g.dart';

@JsonSerializable()
class Recipe {
  String recipeName;
  int recipeId;
  List<Ingredient> ingredients;
  List<Equipment> equipment;
  int timeEstimate;
  List<MacroStep> steps;
  String description;
  String thumbnailUrl;
  String splashUrl;
  @JsonKey(defaultValue: false)
  bool completed = false;
  DateTime startTime;

  Recipe();

  List<Ingredient> get annotatedIngredients {
    for (var i in ingredients ?? []) {
      i.use = recipeName;
    }
    return ingredients;
  }

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}
