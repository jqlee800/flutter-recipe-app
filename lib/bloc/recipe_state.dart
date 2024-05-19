import 'package:flutter_recipe_app/models/recipe.dart';

abstract class RecipeState {}

class RecipeGetAllSuccess extends RecipeState {
  final List<Recipe> recipes;

  RecipeGetAllSuccess({
    required this.recipes,
  });
}

class RecipeInit extends RecipeState {
  RecipeInit();
}
