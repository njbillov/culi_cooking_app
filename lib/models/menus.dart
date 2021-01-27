import 'package:json_annotation/json_annotation.dart';

import '../db_change_notifier.dart';
import 'grocery_list.dart';
import 'ingredient.dart';
import 'recipe.dart';

part 'menus.g.dart';

@JsonSerializable()
class Menu extends DatabaseChangeNotifier {
  List<Recipe> recipes;
  int index;

  Menu({String key = 'selected_menu', this.index, this.recipes})
      : super(key: key);

  GroceryList get groceryList => GroceryList(
      groceries: recipes
          .expand((element) => element?.annotatedIngredients ?? <Ingredient>[])
          .toList());

  factory Menu.fromJson(Map<String, dynamic> json) => _$MenuFromJson(json);

  Map<String, dynamic> toJson() => _$MenuToJson(this);

  @override
  void copyFromJson(Map<String, dynamic> json) {
    final menu = Menu.fromJson(json);
    recipes = menu.recipes;
    index = menu.index;
    notifyListeners();
  }
}

@JsonSerializable()
class Menus extends DatabaseChangeNotifier {
  List<Menu> menus;

  Menus({String key = 'menu_choices', this.menus}) : super(key: key);

  factory Menus.fromJson(Map<String, dynamic> json) => _$MenusFromJson(json);

  Map<String, dynamic> toJson() => _$MenusToJson(this);

  @override
  void copyFromJson(Map<String, dynamic> json) {
    menus = Menus.fromJson(json).menus;
    notifyListeners();
  }
}
