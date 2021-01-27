import 'package:json_annotation/json_annotation.dart';

part 'equipment.g.dart';

@JsonSerializable()
class Equipment {
  String name;
  int quantity;

  Equipment();

  factory Equipment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentFromJson(json);

  Map<String, dynamic> toJson() => _$EquipmentToJson(this);
}
