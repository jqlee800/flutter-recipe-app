import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bloc
import 'package:flutter_recipe_app/bloc/recipe_bloc.dart';
import 'package:flutter_recipe_app/bloc/recipe_event.dart';
import 'package:flutter_recipe_app/bloc/recipe_state.dart';

// Models
import 'package:flutter_recipe_app/models/constants.dart';
import 'package:flutter_recipe_app/models/recipe.dart';
import 'package:flutter_recipe_app/models/recipe_ingredient.dart';
import 'package:flutter_recipe_app/models/recipe_step.dart';
import 'package:flutter_recipe_app/models/recipe_type.dart';

// Screen
import 'package:flutter_recipe_app/screens/edit.dart';

class RecipeScreen extends StatefulWidget {
  final int recipeId;

  const RecipeScreen({
    required this.recipeId,
    super.key,
  });

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  Recipe? _recipe;
  List<RecipeIngredient> _ingredients = [];
  List<RecipeStep> _steps = [];

  @override
  void initState() {
    super.initState();

    // Load ingredients and instructions from local db
    context.read<RecipeBloc>().add(
          RecipeGetDetails(
            recipeId: widget.recipeId,
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Recipe Details',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(onPressed: () {
          Navigator.pop(context, _recipe);
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () async {
              // Navigate to recipe details screen
              Recipe? updatedRecipe = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (BuildContext context) => RecipeBloc(),
                    child: EditScreen(
                      recipe: _recipe,
                      ingredients: _ingredients,
                      steps: _steps,
                    ),
                  ),
                ),
              );

              if (updatedRecipe != null) {
                setState(() {
                  _recipe = updatedRecipe;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
            child: BlocListener<RecipeBloc, RecipeState>(
          listener: (BuildContext context, RecipeState state) async {
            if (state is RecipeGetDetailsSuccess) {
              setState(() {
                _recipe = state.recipe;
                _ingredients = state.ingredients;
                _steps = state.steps;
              });
            }
          },
          child: _recipe == null
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Loading...'),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ------------------------ RECIPE GENERAL INFO -------------------------
                      _recipe!.image != null && _recipe!.image!.trim().isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                _recipe!.image!,
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.indigo.shade100,
                              ),
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: const Icon(
                                Icons.image,
                                size: 50,
                                color: Constants.primaryColor,
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _recipe!.name.isEmpty ? 'No title specified' : _recipe!.name,
                              style: TextStyle(
                                fontSize: 24,
                                color: _recipe!.name.isEmpty ? Colors.grey.shade400 : Constants.primaryColor,
                                fontWeight: _recipe!.name.isEmpty ? FontWeight.normal : FontWeight.bold,
                              ),
                            ),
                            if (_recipe!.description != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(_recipe!.description!),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 1.0,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: Constants.secondaryColor,
                                  )),
                              child: Text(
                                enumToDisplayName(_recipe!.code),
                                style: const TextStyle(
                                  color: Constants.secondaryColor,
                                ),
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.only(top: 12.0),
                              child: Divider(),
                            ),

                            // ----------------- INGREDIENTS ----------------
                            const Text(
                              'Ingredients',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  if (_ingredients.isEmpty) const Text('No ingredients specifed.'),
                                  for (RecipeIngredient ingredient in _ingredients)
                                    Container(
                                      margin: const EdgeInsets.only(right: 8.0),
                                      child: Column(
                                        children: [
                                          ingredient.image.isEmpty
                                              ? Container(
                                                  padding: const EdgeInsets.all(4),
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: Colors.indigo.shade100,
                                                  ),
                                                  child: const Icon(
                                                    Icons.image,
                                                    color: Constants.primaryColor,
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  child: Image.network(
                                                    ingredient.image,
                                                    height: 60,
                                                    width: 60,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              ingredient.name,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                ],
                              ),
                            ),

                            const Padding(
                              padding: EdgeInsets.only(top: 12.0),
                              child: Divider(),
                            ),

                            // ----------------- STEPS ----------------
                            const Padding(
                              padding: EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                'Instructions',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            if (_steps.isEmpty) const Text('No instructions specifed.'),

                            for (RecipeStep step in _steps)
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey.shade100,
                                ),
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                margin: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      step.name,
                                      style:
                                          const TextStyle(color: Constants.secondaryColor, fontWeight: FontWeight.bold),
                                    ),
                                    if (step.description != null) Text(step.description!),
                                  ],
                                ),
                              )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        )),
      ),
    );
  }
}
