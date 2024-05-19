import 'package:flutter_recipe_app/models/recipe_ingredient.dart';
import 'package:flutter_recipe_app/models/recipe_step.dart';
import 'package:flutter_recipe_app/models/recipe_type.dart';

class Recipe {
  final int? recipeId;
  final String name;
  final RecipeTypeCode code;
  final String? description;
  final String? image;
  final List<RecipeStep>? steps;
  final List<RecipeIngredient>? ingredients;

  const Recipe(
    this.recipeId,
    this.name,
    this.code,
    this.description,
    this.image,
    this.steps,
    this.ingredients,
  );

  Recipe.fromJson(Map<String, dynamic> json)
      : recipeId = json['recipeId'],
        name = json['name'],
        code = json['code'],
        description = json['description'],
        image = json['image'],
        steps = json['steps'],
        ingredients = json['ingredients'];

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'name': name,
      'code': codeEnumToString(code),
      'description': description,
      'image': image,
      'steps': steps,
      'ingredients': ingredients,
    };
  }

  Map<String, dynamic> toDB() {
    return {
      'recipeId': recipeId,
      'name': name,
      'code': codeEnumToString(code),
      'description': description,
      'image': image
    };
  }

  Recipe.fromDB(Map<dynamic, dynamic> map)
      : recipeId = map['recipeId'],
        name = map['name'],
        code = codeStringToEnum(map['code']),
        description = map['description'],
        image = map['image'],
        steps = [],
        ingredients = [];
}
