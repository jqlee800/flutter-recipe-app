import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// External libraries
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

// Models
import 'package:flutter_recipe_app/models/constants.dart';
import 'package:flutter_recipe_app/models/recipe_type.dart';
import 'package:flutter_recipe_app/database/recipe_db.dart';

// Screens
import 'package:flutter_recipe_app/screens/splash.dart';

final RecipeDatabase recipeDatabase = RecipeDatabase();

void main() async {
  runApp(const RecipeApp());

  List<RecipeType> types = await _loadRecipeTypes();

  // Save into SP for easy retrieval
  final SharedPreferences spInstance = await SharedPreferences.getInstance();
  String recipeTypeJson = jsonEncode(types);
  spInstance.setString('recipeTypes', recipeTypeJson);

  // Pre-insert some default recipes
  await recipeDatabase.setupInitialRecipes();

  print(spInstance.getString('recipeTypes'));
}

// Function to load and parse recipe types from recipetypes.xml
Future<List<RecipeType>> _loadRecipeTypes() async {
  // Read xml file from assets folder
  String recipeTypesXml = await rootBundle.loadString('assets/recipetypes.xml');

  final document = xml.XmlDocument.parse(recipeTypesXml);

  final recipesNode = document.findElements('recipes').first;
  final types = recipesNode.findElements('recipeType');

  List<RecipeType> recipeTypes = [];

  // Convert xml content into a model
  for (final type in types) {
    final name = type.findElements('name').first.text;
    final code = type.findElements('code').first.text;
    final description = type.findElements('description').first.text;

    RecipeTypeCode codeEnum = codeStringToEnum(code);

    RecipeType typeModel = RecipeType(name, codeEnum, description);
    recipeTypes.add(typeModel);
  }

  return recipeTypes;
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Recipe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.primaryColor),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
