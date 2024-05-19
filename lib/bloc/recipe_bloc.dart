import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recipe_app/bloc/recipe_event.dart';
import 'package:flutter_recipe_app/bloc/recipe_state.dart';
import 'package:flutter_recipe_app/database/recipe_db.dart';
import 'package:flutter_recipe_app/models/constants.dart';
import 'package:flutter_recipe_app/models/recipe.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeDatabase recipeDatabase = RecipeDatabase();

  RecipeBloc() : super(RecipeInit()) {
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
}
