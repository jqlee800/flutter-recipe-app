import 'package:sqflite/sqflite.dart';

// Models
import 'package:flutter_recipe_app/models/constants.dart';
import 'package:flutter_recipe_app/models/recipe.dart';
import 'package:flutter_recipe_app/models/recipe_type.dart';

class RecipeDatabase {
  late Database database;

  Future<List<Map>> getAll(String table, {String? whereClause, List<Object>? whereArgs}) async {
    await openRecipeDb();
    List<Map> maps = await database.query(
      table,
      where: whereClause,
      whereArgs: whereArgs,
    );
    await closeRecipeDb();
    return maps;
  }

  Future openRecipeDb() async {
    database = await openDatabase('recipe.db', version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        create table ${Constants.tableRecipe} (
          ${Constants.colRecipeId} integer primary key autoincrement,
          ${Constants.colRecipeName} text not null,
          ${Constants.colRecipeCode} text not null,
          ${Constants.colRecipeDescription} text,
          ${Constants.colRecipeImage} text)
        ''');
    });
  }

  Future closeRecipeDb() async => database.close();

  Future setupInitialRecipes() async {
    await openRecipeDb();

    await database.insert(
      Constants.tableRecipe,
      const Recipe(
        null,
        'Signature Fish & Chips',
        RecipeTypeCode.MAIN,
        'Crispy Batter, Juicy Meat, with sides of Russet Potato Fries and of course with our house special Tartar Sauce as dips.',
        null,
        null,
        null,
      ).toDB(),
    );

    await database.insert(
      Constants.tableRecipe,
      const Recipe(
        null,
        'Bruschetta',
        RecipeTypeCode.APTZ,
        'Grilled bread rubbed with garlic and topped with fresh tomatoes, basil, and olive oil.',
        null,
        null,
        null,
      ).toDB(),
    );

    await database.insert(
      Constants.tableRecipe,
      const Recipe(
        null,
        'Chocolate Lava Cake',
        RecipeTypeCode.DSRT,
        'A rich and decadent chocolate cake with a molten chocolate center.',
        null,
        null,
        null,
      ).toDB(),
    );

    await database.insert(
      Constants.tableRecipe,
      const Recipe(
        null,
        'Caesar Salad',
        RecipeTypeCode.SLDS,
        'Crisp romaine lettuce, croutons, and Parmesan cheese tossed with a creamy Caesar dressing.',
        null,
        null,
        null,
      ).toDB(),
    );

    await database.insert(
      Constants.tableRecipe,
      const Recipe(
        null,
        'Mojito',
        RecipeTypeCode.BVRG,
        'A refreshing cocktail made with white rum, sugar, lime juice, soda water, and mint.',
        null,
        null,
        null,
      ).toDB(),
    );

    await closeRecipeDb();
  }
  // Future<Todo> insert(Todo todo) async {
  //   todo.id = await db.insert(tableTodo, todo.toMap());
  //   return todo;
  // }

  // Future<int> delete(int id) async {
  //   return await db.delete(tableTodo, where: '$columnId = ?', whereArgs: [id]);
  // }

  // Future<int> update(Todo todo) async {
  //   return await db.update(tableTodo, todo.toMap(), where: '$columnId = ?', whereArgs: [todo.id]);
  // }
}
