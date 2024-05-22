import 'package:flutter/material.dart';

// Models
import 'package:flutter_recipe_app/models/constants.dart';
import 'package:flutter_recipe_app/models/recipe_ingredient.dart';
import 'package:flutter_recipe_app/models/recipe_step.dart';

class SubitemScreen extends StatefulWidget {
  final int? recipeId;
  final bool? isStep;

  const SubitemScreen({
    this.recipeId,
    this.isStep = false,
    super.key,
  });

  @override
  State<SubitemScreen> createState() => _SubitemScreenState();
}

class _SubitemScreenState extends State<SubitemScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void initState() {
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
          widget.isStep == false ? 'Ingredient' : 'Instruction',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            disabledColor: Colors.grey.shade700,
            tooltip: 'Add',
            onPressed: () {
              RecipeStep step = RecipeStep(
                null,
                nameController.text,
                descriptionController.text,
                widget.recipeId,
              );

              RecipeIngredient ingredient = RecipeIngredient(
                null,
                nameController.text,
                imageController.text,
                null,
                null,
                widget.recipeId,
              );

              Navigator.pop(context, widget.isStep == true ? step : ingredient);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
              if (widget.isStep == true)
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
                )
              else
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
            ],
          ),
        ),
      ),
    );
  }
}
