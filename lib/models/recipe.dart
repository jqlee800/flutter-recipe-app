import 'package:flutter_recipe_app/models/recipe_type.dart';

class Recipe {
  final int? recipeId;
  final String name;
  final RecipeTypeCode code;
  final String? description;
  final String? image;

  const Recipe(
    this.recipeId,
    this.name,
    this.code,
    this.description,
    this.image,
  );

  Recipe.fromJson(Map<String, dynamic> json)
      : recipeId = json['recipeId'],
        name = json['name'],
        code = json['code'],
        description = json['description'],
        image = json['image'];

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'name': name,
      'code': codeEnumToString(code),
      'description': description,
      'image': image,
    };
  }

  Recipe.fromDB(Map<dynamic, dynamic> map)
      : recipeId = map['recipeId'],
        name = map['name'],
        code = codeStringToEnum(map['code']),
        description = map['description'],
        image = map['image'];
}
