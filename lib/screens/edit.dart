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

  List<RecipeType> _recipeTypes = [];
  String _selectedRecipeType = codeEnumToString(RecipeTypeCode.APTZ);

  late bool _isCreate;

  @override
  void initState() {
    _isCreate = widget.recipe == null;

    // Fetch recipe type from SP for selection
    context.read<RecipeBloc>().add(RecipeTypeGetAll());

    // If editing a existing recipe, pre-populate the text fields
    if (!_isCreate) {
      nameController.text = widget.recipe!.name;
      descriptionController.text = widget.recipe!.description ?? '';
      imageController.text = widget.recipe!.image ?? '';
      _selectedRecipeType = codeEnumToString(widget.recipe!.code);
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

          if (state is RecipeTypeGetAllSuccess) {
            setState(() {
              // Remove 'ALL' from list
              _recipeTypes = state.types.sublist(1, state.types.length);
            });
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --------------------- TITLE ---------------------
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: nameController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Title',
                    ),
                    autofocus: true,
                  ),
                ),

                // --------------------- DESCRIPTION ---------------------
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

                // --------------------- IMAGE LINK ---------------------
                TextFormField(
                  controller: imageController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Paste image link',
                  ),
                ),

                // --------------------- RECIPE TYPE ---------------------
                _buildRecipeTypeDropdown(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------- WIDGETS -------------------
  Widget _buildRecipeTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recipe Type',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
          DropdownButton<String>(
            value: _selectedRecipeType,
            // icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            underline: Container(
              height: 2,
              color: Constants.primaryColor,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                _selectedRecipeType = value!;
              });
            },
            items: _recipeTypes.map<DropdownMenuItem<String>>((RecipeType recipeType) {
              return DropdownMenuItem<String>(
                value: codeEnumToString(recipeType.code),
                child: Text(enumToDisplayName(recipeType.code)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ----------------- METHODS -------------------
  Recipe _getUpdatedRecipe() {
    return Recipe(
      widget.recipe?.recipeId,
      nameController.text,
      codeStringToEnum(_selectedRecipeType),
      descriptionController.text,
      imageController.text,
      null,
      null,
    );
  }
}
