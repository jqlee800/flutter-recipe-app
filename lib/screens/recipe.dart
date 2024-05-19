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

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeScreen({
    required this.recipe,
    super.key,
  });

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  List<RecipeIngredient> _ingredients = [];
  List<RecipeStep> _steps = [];

  @override
  void initState() {
    super.initState();

    // Load ingredients and instructions from local db
    context.read<RecipeBloc>().add(
          RecipeGetDetails(
            recipeId: widget.recipe.recipeId!,
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
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
            child: BlocListener<RecipeBloc, RecipeState>(
          listener: (BuildContext context, RecipeState state) async {
            if (state is RecipeGetDetailsSuccess) {
              setState(() {
                _ingredients = state.ingredients;
                _steps = state.steps;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------------ RECIPE GENERAL INFO -------------------------
                widget.recipe.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          widget.recipe.image!,
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        color: Colors.yellow,
                        height: 20,
                      ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.recipe.name,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (widget.recipe.description != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(widget.recipe.description!),
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
                          enumToDisplayName(widget.recipe.code),
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
                            for (RecipeIngredient ingredient in _ingredients)
                              Container(
                                margin: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  children: [
                                    ClipRRect(
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

                      for (RecipeStep step in _steps)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey.shade100,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.name,
                                style: const TextStyle(color: Constants.secondaryColor, fontWeight: FontWeight.bold),
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
