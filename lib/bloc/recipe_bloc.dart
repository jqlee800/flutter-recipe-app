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
    on<RecipeUpdate>(_onRecipeUpdate);
    on<RecipeCreate>(_onRecipeCreate);
    on<RecipeDelete>(_onRecipeDelete);
  }

  // Load all recipes from local db
  void _onRecipeGetAll(RecipeGetAll event, Emitter<RecipeState> emit) async {
    List<Map> dbRecipes = await recipeDatabase.getAll(
      Constants.tableRecipe,
      whereClause: event.code != RecipeTypeCode.NONE ? '${Constants.colRecipeCode}=?' : null,
      whereArgs: event.code != RecipeTypeCode.NONE ? [codeEnumToString(event.code)] : null,
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
    Map? dbRecipe = await recipeDatabase.getOne(
      Constants.tableRecipe,
      whereClause: '${Constants.colRecipeId}=?',
      whereArgs: [event.recipeId],
    );

    Recipe recipe = Recipe.fromDB(dbRecipe!);

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
      recipe: recipe,
      ingredients: ingredients,
      steps: steps,
    ));
  }

  // Add a new recipe
  void _onRecipeCreate(RecipeCreate event, Emitter<RecipeState> emit) async {
    int newRecipeId = await recipeDatabase.insert(
      Constants.tableRecipe,
      body: event.recipe.toJson(),
    );

    List<Map<String, dynamic>> ingredientsDB = event.ingredients.map((e) {
      Map<String, dynamic> map = e.toDB();
      map[Constants.colIngredientRecipeId] = newRecipeId;
      return map;
    }).toList();

    // Insert ingredients
    await recipeDatabase.insertAll(
      Constants.tableIngredient,
      body: ingredientsDB,
    );

    List<Map<String, dynamic>> stepsDB = event.steps.map((e) {
      Map<String, dynamic> map = e.toJson();
      map[Constants.colStepRecipeId] = newRecipeId;
      return map;
    }).toList();

    // Insert steps
    await recipeDatabase.insertAll(
      Constants.tableStep,
      body: stepsDB,
    );

    emit(RecipeCreateSuccess());
  }

  // Update recipe information
  void _onRecipeUpdate(RecipeUpdate event, Emitter<RecipeState> emit) async {
    await recipeDatabase.update(
      Constants.tableRecipe,
      whereClause: '${Constants.colRecipeId}=?',
      whereArgs: [event.recipe.recipeId!],
      body: event.recipe.toJson(),
    );

    // Delete removed ingredients
    List<int?> toDeleteIngredientIds = event.toRemoveIngredients.map((element) => element.ingredientId).toList();

    await recipeDatabase.delete(
      Constants.tableIngredient,
      whereClause: '${Constants.colIngredientId}=?',
      whereArgs: toDeleteIngredientIds.cast<Object>(),
    );

    // Delete removed steps
    List<int?> toDeleteStepIds = event.toRemoveSteps.map((element) => element.stepId).toList();

    await recipeDatabase.delete(
      Constants.tableStep,
      whereClause: '${Constants.colStepId}=?',
      whereArgs: toDeleteStepIds.cast<Object>(),
    );

    // Only insert those records with a null primary key
    // If primary has value that means DB already have this record, dont insert anymore
    List<Map<String, dynamic>> ingredientsDB =
        event.ingredients.where((element) => element.ingredientId == null).map((e) => e.toDB()).toList();

    await recipeDatabase.insertAll(
      Constants.tableIngredient,
      body: ingredientsDB,
    );

    List<Map<String, dynamic>> stepsDB =
        event.steps.where((element) => element.stepId == null).map((e) => e.toJson()).toList();

    await recipeDatabase.insertAll(
      Constants.tableStep,
      body: stepsDB,
    );

    emit(RecipeUpdateSuccess());
  }

  // Delete recipe by recipeId
  void _onRecipeDelete(RecipeDelete event, Emitter<RecipeState> emit) async {
    // Delete all associated ingredients
    await recipeDatabase.delete(
      Constants.tableIngredient,
      whereClause: '${Constants.colIngredientRecipeId}=?',
      whereArgs: [event.recipeId],
    );

    // Delete all associated steps
    await recipeDatabase.delete(
      Constants.tableStep,
      whereClause: '${Constants.colStepRecipeId}=?',
      whereArgs: [event.recipeId],
    );

    // Delete the recipe itself
    await recipeDatabase.delete(
      Constants.tableRecipe,
      whereClause: '${Constants.colRecipeId}=?',
      whereArgs: [event.recipeId],
    );

    emit(RecipeDeleteSuccess());
  }
}
