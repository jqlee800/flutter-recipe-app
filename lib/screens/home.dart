import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_recipe_app/bloc/recipe_bloc.dart';
import 'package:flutter_recipe_app/bloc/recipe_event.dart';

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
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    context.read<RecipeBloc>().add(RecipeGetAll());
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
}
