import 'package:hive_ce/hive_ce.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recipe.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Recipe {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String summary;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final List<String> ingredients;

  @HiveField(5)
  final List<String> steps;

  @HiveField(6)
  final String imagePath;

  @HiveField(7)
  final String category;

  const Recipe({
    required this.id,
    required this.name,
    required this.summary,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.imagePath,
    required this.category,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) =>
      _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}