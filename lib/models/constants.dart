import 'package:flutter/material.dart';

class Constants {
  static const Color primaryColor = Color(0xFF1A237E);
  static const Color secondaryColor = Color(0xFF945030);

  // Recipe Table
  static const String tableRecipe = 'recipe';
  static const String colRecipeId = 'recipeId';
  static const String colRecipeName = 'name';
  static const String colRecipeCode = 'code';
  static const String colRecipeDescription = 'description';
  static const String colRecipeImage = 'image';

  // Recipe Step Table
  static const String tableStep = 'step';
  static const String colStepId = 'stepId';
  static const String colStepName = 'name';
  static const String colStepDescription = 'description';
  static const String colStepRecipeId = 'recipeId';

  // Recipe Ingredients Table
  static const String tableIngredient = 'ingredient';
  static const String colIngredientId = 'ingredientId';
  static const String colIngredientName = 'name';
  static const String colIngredientImage = 'image';
  static const String colIngredientRecipeId = 'recipeId';
}
