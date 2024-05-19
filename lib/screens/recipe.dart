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

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({
    super.key,
  });

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
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
        backgroundColor: Constants.primaryColor,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Recipe name',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: BlocListener<RecipeBloc, RecipeState>(
        listener: (BuildContext context, RecipeState state) async {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [Text('hey')],
          ),
        ),
      )),
    );
  }
}
