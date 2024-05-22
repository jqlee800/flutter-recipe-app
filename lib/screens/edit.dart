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
import 'package:flutter_recipe_app/screens/subitem.dart';

class EditScreen extends StatefulWidget {
  final Recipe? recipe;
  final List<RecipeIngredient>? ingredients;
  final List<RecipeStep>? steps;

  const EditScreen({
    this.recipe,
    this.ingredients = const [],
    this.steps = const [],
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
  List<RecipeIngredient> _recipeIngredients = [];
  List<RecipeStep> _recipeSteps = [];
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
      _recipeIngredients = widget.ingredients ?? [];
      _recipeSteps = widget.steps ?? [];
    }

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    descriptionController.dispose();
    imageController.dispose();
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
            disabledColor: Colors.grey.shade700,
            tooltip: _isCreate ? 'Add' : 'Save',
            onPressed: () {
              if (_isCreate) {
                context.read<RecipeBloc>().add(
                      RecipeCreate(
                        recipe: _getUpdatedRecipe(),
                        ingredients: _recipeIngredients,
                        steps: _recipeSteps,
                      ),
                    );
              } else {
                context.read<RecipeBloc>().add(
                      RecipeUpdate(
                        recipe: _getUpdatedRecipe(),
                        ingredients: _recipeIngredients,
                        steps: _recipeSteps,
                      ),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: _buildRecipeTypeDropdown(),
                ),

                // --------------------- INGREDIENTS ---------------------
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),

                _buildIngredients(),

                // --------------------- STEPS ---------------------
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
                  child: Text(
                    'Instructions',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),

                _buildSteps(),
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

  Widget _buildIngredients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (RecipeIngredient ingredient in _recipeIngredients)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.shade100,
            ),
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ingredient.image.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(4),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.indigo.shade100,
                          ),
                          child: const Icon(
                            Icons.image,
                            size: 15,
                            color: Constants.primaryColor,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.network(
                            ingredient.image,
                            height: 40.0,
                            width: 40.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ingredient.name),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_rounded,
                    color: Colors.red.shade800,
                  ),
                  iconSize: 20,
                  tooltip: 'Delete',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        TextButton.icon(
          onPressed: () async {
            // Navigate to add ingredient/step screen
            RecipeIngredient? newIngredient = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (BuildContext context) => RecipeBloc(),
                  child: SubitemScreen(
                    recipeId: widget.recipe?.recipeId,
                  ),
                ),
              ),
            );

            if (newIngredient != null) {
              setState(() {
                _recipeIngredients.add(newIngredient);
              });
            }
          },
          icon: const Icon(
            Icons.add,
            color: Constants.primaryColor,
          ),
          label: const Text(
            'Add ingredient',
            style: TextStyle(color: Constants.primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildSteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (RecipeStep step in _recipeSteps)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.grey.shade100,
            ),
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step.name),
                      if (step.description != null)
                        Text(
                          step.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_rounded,
                    color: Colors.red.shade800,
                  ),
                  iconSize: 20,
                  tooltip: 'Delete',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        TextButton.icon(
          onPressed: () async {
            // Navigate to add ingredient/step screen
            RecipeStep? newStep = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (BuildContext context) => RecipeBloc(),
                  child: SubitemScreen(
                    recipeId: widget.recipe?.recipeId,
                    isStep: true,
                  ),
                ),
              ),
            );

            if (newStep != null) {
              setState(() {
                _recipeSteps.add(newStep);
              });
            }
          },
          icon: const Icon(
            Icons.add,
            color: Constants.primaryColor,
          ),
          label: const Text(
            'Add instruction',
            style: TextStyle(color: Constants.primaryColor),
          ),
        ),
      ],
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
    );
  }
}
