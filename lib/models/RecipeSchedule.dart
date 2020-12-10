
class RecipeSchedule {
  List<RecipeOverview> recipeList;

  RecipeSchedule({this.recipeList});
}

class RecipeOverview {
  final String recipeName;
  final String recipeImageResource;
  final List<String> ingredients;

  const RecipeOverview({this.recipeName, this.recipeImageResource, this.ingredients});
}