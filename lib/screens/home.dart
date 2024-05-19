import 'package:flutter/cupertino.dart';
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

// Screens
import 'package:flutter_recipe_app/screens/edit.dart';
import 'package:flutter_recipe_app/screens/recipe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<RecipeType> _recipeTypes = [];
  List<Recipe> _recipes = [];

  int _selectedType = 0;

  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(RecipeTypeGetAll());
    _fetchRecipes(RecipeTypeCode.NONE);
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
          'Recipes',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: BlocListener<RecipeBloc, RecipeState>(
        listener: (BuildContext context, RecipeState state) async {
          if (state is RecipeGetAllSuccess) {
            setState(() {
              _recipes = state.recipes;
            });
          }

          if (state is RecipeTypeGetAllSuccess) {
            setState(() {
              _recipeTypes = state.types;
            });
          }

          // Refresh the list after successful deletion
          if (state is RecipeDeleteSuccess) {
            _fetchRecipes(_recipeTypes[_selectedType].code);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (_recipeTypes.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: _buildRecipeTypePicker(),
                ),
              Expanded(
                child: _recipes.isEmpty
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No recipes found.'),
                        ],
                      )
                    : ListView.builder(
                        itemCount: _recipes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: _buildRecipeTile(_recipes[index]),
                          );
                        }),
              ),
              Container(
                height: 60,
              ),
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to recipe details screen
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (BuildContext context) => RecipeBloc(),
                child: const EditScreen(),
              ),
            ),
          );

          _fetchRecipes(_recipeTypes[_selectedType].code);
        },
        tooltip: 'Add Recipe',
        backgroundColor: Constants.secondaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // -------------------------- WIDGETS --------------------------
  Widget _buildRecipeTile(Recipe recipe) {
    return ListTile(
      onTap: () async {
        // Navigate to recipe details screen
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (BuildContext context) => RecipeBloc(),
              child: RecipeScreen(recipeId: recipe.recipeId!),
            ),
          ),
        );

        _fetchRecipes(_recipeTypes[_selectedType].code);
      },
      tileColor: Colors.grey.shade100,
      leading: recipe.image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.network(
                recipe.image!,
                height: 60.0,
                width: 60.0,
                fit: BoxFit.cover,
              ),
            )
          : Container(
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
            ),
      trailing: IconButton(
        icon: Icon(
          Icons.delete_rounded,
          color: Colors.red.shade800,
        ),
        tooltip: 'Delete',
        onPressed: () {
          context.read<RecipeBloc>().add(RecipeDelete(
                recipeId: recipe.recipeId!,
              ));
        },
      ),
      title: Text(recipe.name),
      // Recipe type chip
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
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
              enumToDisplayName(recipe.code),
              style: const TextStyle(
                color: Constants.secondaryColor,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeTypePicker() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      const Padding(
        padding: EdgeInsets.only(
          right: 6.0,
        ),
        child: Icon(
          Icons.filter_alt_rounded,
          color: Constants.secondaryColor,
        ),
      ),
      CupertinoButton(
        padding: EdgeInsets.zero,
        // Display a CupertinoPicker with list of fruits.
        onPressed: () => _showRecipeTypeSelector(
          CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: 32,
            // This sets the initial item.
            scrollController: FixedExtentScrollController(
              initialItem: _selectedType,
            ),
            // This is called when selected item is changed.
            onSelectedItemChanged: (int selectedItem) {
              setState(() {
                _selectedType = selectedItem;
                _fetchRecipes(_recipeTypes[_selectedType].code);
              });
            },
            children: List<Widget>.generate(_recipeTypes.length, (int index) {
              return Center(child: Text(_recipeTypes[index].name));
            }),
          ),
        ),
        // This displays the selected recipe type.
        child: Container(
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
            _recipeTypes[_selectedType].name,
            style: const TextStyle(
              color: Constants.secondaryColor,
              fontSize: 15,
            ),
          ),
        ),
      )
    ]);
  }

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void _showRecipeTypeSelector(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  // ---------------------------- METHODS -----------------------------
  void _fetchRecipes(RecipeTypeCode code) {
    context.read<RecipeBloc>().add(RecipeGetAll(code: code));
  }
}
