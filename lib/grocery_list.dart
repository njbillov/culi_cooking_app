import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'models/ingredient.dart';
import 'models/menus.dart';
import 'models/recipe.dart';
import 'recipe_overview.dart';
import 'theme.dart';
import 'utilities.dart';

class GroceryListScreen extends StatefulWidget {
  @override
  _GroceryListScreenState createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final m = Provider.of<Menu>(context);
    if (m?.recipes?.isEmpty ?? true) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Grocery List",
              style: Theme.of(context).textTheme.headline3),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text("Finish selecting your menu to get your grocery list",
              style: Theme.of(context).textTheme.headline3),
        )),
      );
    }
    // log(m.recipes.map((e) => e.recipeName).join(", "));
    // log(m.groceryList.ingredientMap.entries
    //     .map((e) => '${e.key}${e.value.map((e) => e.toJson())}')
    //     .join(", "));
    final menu = Provider.of<Menu>(context);
    var sortedIngredients = menu.groceryList.ingredientMap.values.toList();
    sortedIngredients.sort((a, b) =>
        a.first.name.toLowerCase().compareTo(b.first.name.toLowerCase()));
    return Scaffold(
        appBar: AppBar(
          title: Text("Grocery List",
              style: Theme.of(context).textTheme.headline3),
        ),
        extendBody: true,
        backgroundColor: Culi.white,
        body: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    alignment: Alignment.bottomCenter,
                    height: 0.075 * size.height,
                    child: Text('Gather...',
                        style: Theme.of(context).textTheme.headline2)),
                Expanded(
                  child: Consumer<Menu>(
                    builder: (context, menu, child) => Padding(
                      padding: const EdgeInsets.all(8),
                      child: GridView.count(
                        // physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        // crossAxisSpacing: 0,
                        // mainAxisSpacing: 100,
                        padding: const EdgeInsets.all(8),
                        childAspectRatio: 0.6,
                        shrinkWrap: true,
                        children: sortedIngredients
                            .map((e) => GroceryItem(
                                  ingredients: e,
                                  detailed: true,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                // CuliButton(
                //   "Let's Cook!",
                //   width: size.width * 0.55,
                //   height: 75,
                // )
              ],
            )));
  }

  @override
  bool get wantKeepAlive => true;
}

class GroceryItemDetail extends StatefulWidget {
  final Ingredient ingredient;
  final bool withUse;

  const GroceryItemDetail({Key key, this.ingredient, this.withUse = false})
      : super(key: key);

  @override
  _GroceryItemDetailState createState() => _GroceryItemDetailState();
}

class _GroceryItemDetailState extends State<GroceryItemDetail> {
  bool _selected;

  @override
  void initState() {
    super.initState();
    _selected =
        widget.ingredient.quantityObtained >= widget.ingredient.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return CuliCheckbox(
      widget.withUse ? widget.ingredient.detailedText : widget.ingredient.text,
      selected: _selected,
      circular: false,
      padded: false,
      onPressed: () {
        if (_selected) {
          widget.ingredient.quantityObtained = 0;
        } else {
          widget.ingredient.quantityObtained = widget.ingredient.quantity;
        }
        setState(() {
          _selected ^= true;
        });
      },
    );
  }
}

class DetailedGroceryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details', style: Theme.of(context).textTheme.headline3),
      ),
    );
  }
}

class GatherRecipeItemsScreen extends StatelessWidget {
  final Recipe recipe;
  final tabs = const <Tab>[Tab(text: 'Ingredients'), Tab(text: 'Equipment')];

  const GatherRecipeItemsScreen({Key key, this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: tabs.length,
        child: Builder(builder: (context) {
          final tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {}
          });
          return Scaffold(
              appBar: AppBar(
                title: Text('Grocery List',
                    style: Theme.of(context).textTheme.headline3),
                bottom: TabBar(
                  tabs: tabs,
                  indicatorColor: Culi.coral,
                  labelStyle: Theme.of(context)
                      .textTheme
                      .headline3
                      .copyWith(color: Culi.coral),
                  labelColor: Culi.coral,
                  unselectedLabelStyle: Theme.of(context).textTheme.headline3,
                  unselectedLabelColor: Colors.black,
                ),
              ),
              backgroundColor: Culi.white,
              body: SafeArea(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.bottomCenter,
                        height: 0.075 * size.height,
                        child: Text('Gather...',
                            style: Theme.of(context).textTheme.headline2)),
                    Expanded(
                      // height: size.height * 0.54,
                      child: TabBarView(
                          children: tabs
                              .map((tab) => Align(
                                  alignment: Alignment.topCenter,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: GridView.count(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          crossAxisCount: 4,
                                          // crossAxisSpacing: 0,
                                          // mainAxisSpacing: 100,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          childAspectRatio: 0.6,
                                          shrinkWrap: true,
                                          children: (tab.text == 'Ingredients'
                                                  ? recipe.ingredients
                                                  : recipe?.equipment?.map(
                                                          (e) => Ingredient(
                                                              name: e.name,
                                                              quantity: e
                                                                  .quantity
                                                                  .toDouble())) ??
                                                      <Ingredient>[])
                                              .map((e) => Ingredient(
                                                  name: e.name,
                                                  quantityObtained: 0,
                                                  quantity: e.quantity,
                                                  unit: e.unit,
                                                  use: e.use))
                                              .map((e) =>
                                                  GroceryItem(ingredients: [e]))
                                              .toList()
                                              .reversed
                                              .toList(),
                                        ),
                                      ),
                                    ],
                                  )))
                              .toList()),
                    ),
                    Container(height: size.height * 0.05),
                    CuliButton("Let's Cook!",
                        width: size.width * 0.90,
                        height: 75,
                        onPressed: () => Utils.changeScreens(
                            context: context,
                            routeName: '/recipe/${recipe.recipeId}/overview',
                            nextWidget: () => RecipeOverview(recipe: recipe))),
                  ],
                ),
              ));
        }));
  }
}

class GroceryItem extends StatefulWidget {
  final List<Ingredient> ingredients;
  final bool detailed;

  GroceryItem({@required this.ingredients, this.detailed = false}) {
    for (var i in ingredients) {
      i.quantityObtained ??= 0;
    }
  }

  @override
  _GroceryItemState createState() => _GroceryItemState();
}

class _GroceryItemState extends State<GroceryItem> {
  bool ingredientObtained;

  @override
  void initState() {
    ingredientObtained = widget.ingredients
        .every((element) => element.quantityObtained >= element.quantity);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      alignment: Alignment.topCenter,
      child: Consumer<Menu>(
        builder: (context, menu, child) => CuliAnnotatedCircle(
          backgroundColor: ingredientObtained ? Culi.lightCoral : Colors.white,
          annotate: true,
          outlined: false,
          imageName: "assets/images/pot.png",
          innerDiameter: 35,
          annotation: Icon(Icons.check_circle_rounded,
              color: ingredientObtained ? Culi.coral : Culi.clear, size: 25),
          labelText: widget.ingredients.first.name.toCamelCase(),
          onTap: () {
            setState(() {
              var changed = false;
              if (ingredientObtained) {
                ingredientObtained = false;
                for (var i in widget.ingredients) {
                  if (i.quantityObtained >= i.quantity) {
                    i.quantityObtained = 0;
                    changed = true;
                  }
                }
                changed = true;
              } else {
                ingredientObtained = true;
                for (var i in widget.ingredients) {
                  if (i.quantityObtained < i.quantity) {
                    i.quantityObtained = i.quantity;
                    changed = true;
                  }
                }
              }
              if (changed) {
                menu.write();
                // .then((value) => log(menu
                // .groceryList.ingredientMap.entries
                // .map((e) => '${e.key}: ${e.value.map((e) => e.toJson())}')
                // .join(', ')));
              }
            });
          },
          onLongPress: () => showCupertinoModalBottomSheet(
              context: context,
              builder: (context) => ListView(
                    shrinkWrap: true,
                    children: widget.ingredients
                        .map((e) => GroceryItemDetail(
                              ingredient: e,
                              withUse: widget.detailed,
                            ))
                        .toList(),
                  )).then((value) => setState(() {
                ingredientObtained = widget.ingredients.every(
                    (element) => element.quantityObtained >= element.quantity);
              })),
        ),
      ),
    );
  }
}
