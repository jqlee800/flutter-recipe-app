import 'package:flutter/material.dart';

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

class RecipeDelete extends RecipeEvent {
  final int recipeId;

  RecipeDelete({
    required this.recipeId,
  });
}
