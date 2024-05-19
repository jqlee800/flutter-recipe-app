import 'package:flutter/material.dart';

import 'package:flutter_recipe_app/database/recipe_db.dart';
import 'package:flutter_recipe_app/models/constants.dart';
import 'package:flutter_recipe_app/models/recipe.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeDatabase recipeDatabase = RecipeDatabase();

  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Constants.primaryColor,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text(
          'Recipes',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: 50,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: _buildRecipeTile(),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
  Widget _buildRecipeTile() {
    return ListTile(
      tileColor: Colors.grey.shade100,
      leading: Container(
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
      title: Text("Signature Fish and Chips"),
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
            child: const Text(
              "Main Courses",
              style: TextStyle(
                color: Constants.secondaryColor,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------- METHODS --------------------------
  Future<List<Recipe>> getAllRecipes() async {
    List<Map> dbRecipes = await recipeDatabase.getAll(Constants.tableRecipe);

    List<Recipe> results = [];

    for (Map recipe in dbRecipes) {
      results.add(Recipe.fromDB(recipe));
    }

    return results;
  }
}
