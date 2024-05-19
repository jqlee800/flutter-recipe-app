import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recipe_app/models/recipe_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Bloc
import 'package:flutter_recipe_app/bloc/recipe_event.dart';
import 'package:flutter_recipe_app/bloc/recipe_state.dart';

// Database
import 'package:flutter_recipe_app/database/recipe_db.dart';

// Models
import 'package:flutter_recipe_app/models/constants.dart';
import 'package:flutter_recipe_app/models/recipe.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeDatabase recipeDatabase = RecipeDatabase();

  RecipeBloc() : super(RecipeInit()) {
    on<RecipeTypeGetAll>(_onRecipeTypeGetAll);
    on<RecipeGetAll>(_onRecipeGetAll);
  }

  // Load all recipes from local db
  void _onRecipeGetAll(RecipeGetAll event, Emitter<RecipeState> emit) async {
    List<Recipe> results = await getAllRecipes();
    emit(RecipeGetAllSuccess(recipes: results));
  }

  Future<List<Recipe>> getAllRecipes() async {
    List<Map> dbRecipes = await recipeDatabase.getAll(Constants.tableRecipe);

    List<Recipe> results = [];

    for (Map recipe in dbRecipes) {
      results.add(Recipe.fromDB(recipe));
    }

    return results;
  }

  void _onRecipeTypeGetAll(RecipeTypeGetAll event, Emitter<RecipeState> emit) async {
    // Retrieve recipe types from SP for filter
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
}
