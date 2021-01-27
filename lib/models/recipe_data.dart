class Recipe {
  List<MacroStep> _steps;
  String imageName = "";
  String name = "";
  int time;
  String description =
      "Night 1 baby! We're starting the week off with something super simple and familiar, chicken with broccoli. We'll marinate some chicken in honey and soy sauce, giving it a nice sweet and salty flavor.";

  static Recipe hscr = Recipe(
      imageName: "assets/images/honeysoychickenandramen.png",
      name: "Honey Soy Chicken & Ramen",
      time: 54);
  static Recipe cls = Recipe(
      imageName: "assets/images/charredlimesteak.png",
      name: "Charred Lime Steak",
      time: 54);
  static Recipe cps = Recipe(
      imageName: "assets/images/chickpea_stew.png",
      name: "Chickpea Stew",
      time: 54);
  static Recipe efr = Recipe(
      imageName: "assets/images/eggfriedrice.png",
      name: "Egg Fried Rice",
      time: 54);
  static Recipe hscb = Recipe(name: "Honey Soy Chicken & Broccoli");
  static Recipe rbp = Recipe(name: "Roasted Broccoli Pasta");
  static Recipe gsz = Recipe(name: "Garlic Shrimp Zoodles");
  static Recipe kbb = Recipe(name: "Korean Beef Burger");

  Recipe(
      {steps,
      this.imageName = "",
      this.description,
      this.name = "",
      this.time = -1}) {
    description ??=
        "Night 1 baby! We're starting the week off with something super simple and familiar, chicken with broccoli. We'll marinate some chicken in honey and soy sauce, giving it a nice sweet and salty flavor.";
    _steps = steps;
  }

  List<MacroStep> get steps {
    if (_steps == null) {
      return stepNames.map((e) => MacroStep(name: e)).toList();
    }
    return _steps;
  }

  List<String> get equipment {
    if (_steps == null) return <String>[];
    var equipment = <String>{};
    for (var step in steps) {
      equipment.addAll(step.equipment);
    }
    final equipmentList = equipment.toList();
    equipmentList.sort();
    return equipmentList;
  }

  List<String> get ingredients {
    if (_steps == null) return <String>[];
    var ingredients = <String>{};
    for (var step in steps) {
      ingredients.addAll(step.equipment);
    }
    final ingredientsList = ingredients.toList();
    ingredientsList.sort();
    return ingredientsList;
  }

  List<String> get skills {
    if (_steps == null) return <String>[];
    var skills = <String>{};
    for (var step in steps) {
      skills.addAll(step.skills);
    }
    final skillList = skills.toList();
    skillList.sort();
    return skillList;
  }

  int get ingredientCount {
    if (_steps == null) return 9;
    return ingredients.length;
  }

  int get skillCount {
    if (_steps == null) return 6;
    return skills.length;
  }

  int get equipmentCount {
    if (_steps == null) return 6;
    return equipment.length;
  }

  List<String> get stepNames {
    if (_steps == null) {
      return [
        "Prepare marinade",
        "Prepare broccoli",
        "Season the broccoli",
        "Stove or oven cooking",
        "Finish and plate"
      ];
    }
    return _steps.map((e) => e.name).toList();
  }
}

class MicroStep {
  List<String> ingredients;
  List<String> equipment;
  List<String> skills;

  MicroStep(this.ingredients, this.equipment, this.skills);
}

class MacroStep {
  List<MicroStep> microSteps;
  String name;

  MacroStep({this.name, this.microSteps});

  List<String> get ingredients {
    var ingredients = <String>{};
    for (var step in microSteps) {
      ingredients.addAll(step.ingredients);
    }
    final ingredientList = ingredients.toList();
    ingredientList.sort();
    return ingredientList;
  }

  List<String> get equipment {
    var equipment = <String>{};
    for (var step in microSteps) {
      equipment.addAll(step.equipment);
    }
    final equipmentList = equipment.toList();
    equipmentList.sort();
    return equipmentList;
  }

  List<String> get skills {
    if (microSteps == null) {
      return ["Hold a knife", "Mince garlic", "Steam", "Sauteé"];
    }
    var skills = <String>{};
    for (var step in microSteps) {
      skills.addAll(step.skills);
    }
    final skillsList = skills.toList();
    skillsList.sort();
    return skillsList;
  }
}
