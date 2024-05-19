import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Bloc
import 'package:flutter_recipe_app/bloc/recipe_event.dart';
import 'package:flutter_recipe_app/bloc/recipe_state.dart';

// Database
import 'package:flutter_recipe_app/database/recipe_db.dart';

// Models
import 'package:flutter_recipe_app/models/constants.dart';
import 'package:flutter_recipe_app/models/recipe.dart';
import 'package:flutter_recipe_app/models/recipe_ingredient.dart';
import 'package:flutter_recipe_app/models/recipe_type.dart';
import 'package:flutter_recipe_app/models/recipe_step.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeDatabase recipeDatabase = RecipeDatabase();

  RecipeBloc() : super(RecipeInit()) {
    on<RecipeTypeGetAll>(_onRecipeTypeGetAll);
    on<RecipeGetAll>(_onRecipeGetAll);
    on<RecipeGetDetails>(_onRecipeGetDetails);
    on<RecipeDelete>(_onRecipeDelete);
  }

  // Load all recipes from local db
  void _onRecipeGetAll(RecipeGetAll event, Emitter<RecipeState> emit) async {
    List<Map> dbRecipes = await recipeDatabase.getAll(
      Constants.tableRecipe,
      whereClause: '${Constants.colRecipeCode}=?',
      whereArgs: [codeEnumToString(event.code)],
    );

    List<Recipe> results = [];

    for (Map recipe in dbRecipes) {
      results.add(Recipe.fromDB(recipe));
    }

    emit(RecipeGetAllSuccess(recipes: results));
  }

  // Retrieve recipe types from SP for filter
  void _onRecipeTypeGetAll(RecipeTypeGetAll event, Emitter<RecipeState> emit) async {
    final SharedPreferences spInstance = await SharedPreferences.getInstance();
    String? typesString = spInstance.getString('recipeTypes');

    List<RecipeType> types = [];

    if (typesString != null) {
      List<dynamic> typesJson = jsonDecode(typesString);

      for (Map type in typesJson) {
        types.add(RecipeType.fromSP(type));
      }
    }

    emit(RecipeTypeGetAllSuccess(types: types));
  }

  // Get recipe details by recipeId
  void _onRecipeGetDetails(RecipeGetDetails event, Emitter<RecipeState> emit) async {
    List<Map> dbIngredients = await recipeDatabase.getAll(
      Constants.tableIngredient,
      whereClause: '${Constants.colIngredientRecipeId}=?',
      whereArgs: [event.recipeId],
    );

    List<RecipeIngredient> ingredients = [];

    for (Map recipe in dbIngredients) {
      ingredients.add(RecipeIngredient.fromDB(recipe));
    }

    List<Map> dbSteps = await recipeDatabase.getAll(
      Constants.tableStep,
      whereClause: '${Constants.colStepRecipeId}=?',
      whereArgs: [event.recipeId],
    );

    List<RecipeStep> steps = [];

    for (Map step in dbSteps) {
      steps.add(RecipeStep.fromDB(step));
    }

    emit(RecipeGetDetailsSuccess(
      ingredients: ingredients,
      steps: steps,
    ));
  }

  // Delete recipe by recipeId
  void _onRecipeDelete(RecipeDelete event, Emitter<RecipeState> emit) async {
    await recipeDatabase.delete(
      Constants.tableRecipe,
      whereClause: '${Constants.colRecipeId}=?',
      whereArgs: [event.recipeId],
    );

    emit(RecipeDeleteSuccess());
  }
}
