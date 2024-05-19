// Models
import 'package:flutter_recipe_app/models/recipe.dart';
import 'package:flutter_recipe_app/models/recipe_ingredient.dart';
import 'package:flutter_recipe_app/models/recipe_type.dart';

abstract class RecipeState {}

class RecipeGetAllSuccess extends RecipeState {
  final List<Recipe> recipes;

  RecipeGetAllSuccess({required this.recipes});
}

class RecipeTypeGetAllSuccess extends RecipeState {
  List<RecipeType> types;

  RecipeTypeGetAllSuccess({
    this.types = const [],
  });
}

class RecipeGetDetailsSuccess extends RecipeState {
  List<RecipeIngredient> ingredients;

  RecipeGetDetailsSuccess({
    this.ingredients = const [],
  });
}

class RecipeDeleteSuccess extends RecipeState {
  RecipeDeleteSuccess();
}

class RecipeInit extends RecipeState {
  RecipeInit();
}
