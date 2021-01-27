import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

@JsonSerializable()
class Ingredient {
  @JsonKey(defaultValue: 1)
  double quantity;
  double quantityObtained;
  @JsonKey(defaultValue: '')
  String name;
  @JsonKey(defaultValue: '')
  String unit;
  @JsonKey(ignore: true)
  String use;

  String get text =>
      '${quantity.toString()} ${unit != null ? "$unit of " : ""}$name';

  String get detailedText => '$text - $use';

  Ingredient(
      {this.quantity,
      this.quantityObtained = 0,
      this.name,
      this.unit,
      this.use = ''});

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}
