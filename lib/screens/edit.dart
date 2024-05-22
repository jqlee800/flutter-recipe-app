import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bloc
import 'package:flutter_recipe_app/bloc/recipe_bloc.dart';
import 'package:flutter_recipe_app/bloc/recipe_event.dart';
import 'package:flutter_recipe_app/bloc/recipe_state.dart';

// Models
import 'package:flutter_recipe_app/models/constants.dart';
import 'package:flutter_recipe_app/models/recipe.dart';
import 'package:flutter_recipe_app/models/recipe_type.dart';

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

  late bool _isCreate;

  @override
  void initState() {
    _isCreate = widget.recipe == null;

    if (!_isCreate) {
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
        title: Text(
          _isCreate ? 'Create Recipe' : 'Edit Recipe',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            tooltip: _isCreate ? 'Add' : 'Save',
            onPressed: () {
              if (_isCreate) {
                context.read<RecipeBloc>().add(
                      RecipeCreate(recipe: _getUpdatedRecipe()),
                    );
              } else {
                context.read<RecipeBloc>().add(
                      RecipeUpdate(recipe: _getUpdatedRecipe()),
                    );
              }
            },
          ),
        ],
      ),
      body: BlocListener<RecipeBloc, RecipeState>(
        listener: (BuildContext context, RecipeState state) async {
          if (state is RecipeUpdateSuccess || state is RecipeCreateSuccess) {
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
      // TODO!! remove hard coded main course
      widget.recipe != null ? widget.recipe!.code : RecipeTypeCode.MAIN,
      descriptionController.text,
      imageController.text,
      null,
      null,
    );
  }
}
