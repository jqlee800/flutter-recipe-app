import 'package:flutter/material.dart';
import 'package:flutter_recipe_app/models/recipe.dart';
import 'package:flutter_recipe_app/models/recipe_ingredient.dart';
import 'package:flutter_recipe_app/models/recipe_step.dart';

// Models
import 'package:flutter_recipe_app/models/recipe_type.dart';

@immutable
abstract class RecipeEvent {}

class RecipeTypeGetAll extends RecipeEvent {
  RecipeTypeGetAll();
}

class RecipeGetAll extends RecipeEvent {
  final RecipeTypeCode code;

  RecipeGetAll({
    required this.code,
  });
}

class RecipeGetDetails extends RecipeEvent {
  final int recipeId;

  RecipeGetDetails({
    required this.recipeId,
  });
}

class RecipeCreate extends RecipeEvent {
  final Recipe recipe;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;

  RecipeCreate({
    required this.recipe,
    this.ingredients = const [],
    this.steps = const [],
  });
}

class RecipeUpdate extends RecipeEvent {
  final Recipe recipe;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;

  RecipeUpdate({
    required this.recipe,
    this.ingredients = const [],
    this.steps = const [],
  });
}

class RecipeDelete extends RecipeEvent {
  final int recipeId;

  RecipeDelete({
    required this.recipeId,
  });
}
