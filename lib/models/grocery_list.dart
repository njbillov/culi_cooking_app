import 'package:json_annotation/json_annotation.dart';

import 'ingredient.dart';

part 'grocery_list.g.dart';

@JsonSerializable()
class GroceryList {
  List<Ingredient> groceries;

  GroceryList({this.groceries});

  List<Ingredient> get overview => groceries
      .map((e) => e.name)
      .toSet()
      .map((e) =>
          Ingredient(name: e, quantity: 1, quantityObtained: 0, unit: ''))
      .toList();

  Map<String, List<Ingredient>> combineIngredients(
      Map<String, List<Ingredient>> map, Ingredient ingredient) {
    final key = '${ingredient.name}:${ingredient.unit}';
    if (map[key] != null) {
      map[key].add(ingredient);
    } else {
      map[key] = [ingredient];
    }
    return map;
  }

  Map<String, List<Ingredient>> get ingredientMap {
    return groceries.fold(<String, List<Ingredient>>{}, combineIngredients);
  }

  List<Ingredient> get detailed {
    return ingredientMap.values
        .map((e) => e.reduce((value, element) {
              value.quantityObtained += element.quantityObtained;
              value.quantity += element.quantity;
              return value;
            }))
        .toList();
  }

  factory GroceryList.fromJson(Map<String, dynamic> json) =>
      _$GroceryListFromJson(json);

  Map<String, dynamic> toJson() => _$GroceryListToJson(this);
}
