import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bloc
import 'package:flutter_recipe_app/bloc/recipe_bloc.dart';
import 'package:flutter_recipe_app/bloc/recipe_event.dart';
import 'package:flutter_recipe_app/bloc/recipe_state.dart';

// Models
import 'package:flutter_recipe_app/models/constants.dart';
import 'package:flutter_recipe_app/models/recipe.dart';

class EditScreen extends StatefulWidget {
  final Recipe? recipe;

  const EditScreen({
    this.recipe,
    super.key,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void initState() {
    if (widget.recipe != null) {
      nameController.text = widget.recipe!.name;
      descriptionController.text = widget.recipe!.description ?? '';
      imageController.text = widget.recipe!.image ?? '';
    }

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
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
          'Edit Recipe',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            tooltip: 'Save',
            onPressed: () {
              context.read<RecipeBloc>().add(
                    RecipeUpdate(recipe: _getUpdatedRecipe()),
                  );
            },
          ),
        ],
      ),
      body: BlocListener<RecipeBloc, RecipeState>(
        listener: (BuildContext context, RecipeState state) async {
          if (state is RecipeUpdateSuccess) {
            Navigator.pop(context, _getUpdatedRecipe());
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: nameController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Recipe Name',
                  ),
                  autofocus: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: descriptionController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Description',
                  ),
                ),
              ),
              TextFormField(
                controller: imageController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Paste image link',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------- METHODS -------------------
  Recipe _getUpdatedRecipe() {
    return Recipe(
      widget.recipe?.recipeId,
      nameController.text,
      widget.recipe!.code,
      descriptionController.text,
      imageController.text,
      null,
      null,
    );
  }
}
