import 'package:sqflite/sqflite.dart';

// Models
import 'package:flutter_recipe_app/models/constants.dart';
import 'package:flutter_recipe_app/models/recipe.dart';
import 'package:flutter_recipe_app/models/recipe_type.dart';
import 'package:flutter_recipe_app/models/recipe_ingredient.dart';
import 'package:flutter_recipe_app/models/recipe_step.dart';

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

  Future<Map?> getOne(String table, {String? whereClause, List<Object>? whereArgs}) async {
    List<Map> maps = await getAll(table, whereClause: whereClause, whereArgs: whereArgs);
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<int> update(
    String table, {
    String? whereClause,
    List<Object>? whereArgs,
    Map<String, dynamic> body = const {},
  }) async {
    await openRecipeDb();
    int updatedId = await database.update(table, body, where: whereClause, whereArgs: whereArgs);
    await closeRecipeDb();
    return updatedId;
  }

  Future<int> delete(String table, {String? whereClause, List<Object>? whereArgs}) async {
    await openRecipeDb();
    int deletedId = await database.delete(table, where: whereClause, whereArgs: whereArgs);
    await closeRecipeDb();
    return deletedId;
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

      await db.execute('''
        create table ${Constants.tableStep} (
          ${Constants.colStepId} integer primary key autoincrement,
          ${Constants.colStepName} text not null,
          ${Constants.colStepDescription} text,
          ${Constants.colStepRecipeId} integer not null)
        ''');

      await db.execute('''
        create table ${Constants.tableIngredient} (
          ${Constants.colIngredientId} integer primary key autoincrement,
          ${Constants.colIngredientName} text not null,
          ${Constants.colIngredientImage} text not null,
          ${Constants.colIngredientRecipeId} integer not null)
        ''');
    });
  }

  Future closeRecipeDb() async => database.close();

  Future setupInitialRecipes() async {
    // Only insert when local db is empty
    List<Map> recipes = await getAll(Constants.tableRecipe);

    if (recipes.isEmpty) {
      await openRecipeDb();

      // ----------------------------- FISH & CHIPS -----------------------------
      int recipeId1 = await database.insert(
        Constants.tableRecipe,
        const Recipe(
                null,
                'Signature Fish & Chips',
                RecipeTypeCode.MAIN,
                'Crispy Batter, Juicy Meat, with sides of Russet Potato Fries and of course with our house special Tartar Sauce as dips.',
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEEBhozoDyr2udvXeOwhgsagXNyVKRMRX7TDk8FJKZ3A&s',
                null,
                null)
            .toDB(),
      );

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'Fish Fillet',
                  'https://www.capeannfreshcatch.org/cdn/shop/products/Fish_Fillet_FB.png?v=1581541236',
                  null,
                  null,
                  recipeId1)
              .toDB());

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'Russet Potatoes',
                  'https://themeatzgrocer.com.my/wp-content/uploads/2021/11/A5CCB0B9-E6F8-4FEF-99E9-1221932EF02E.jpeg',
                  null,
                  null,
                  recipeId1)
              .toDB());

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'Batter Mix',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGylIhBJG_RZlaQ1XlBARcTK4dHPQqMViDK8H42rKMpw&s',
                  null,
                  null,
                  recipeId1)
              .toDB());

      await database.insert(
          Constants.tableStep,
          RecipeStep(null, 'Prepare the Fish',
                  'Pat the fish fillets dry with paper towels and season them with salt and pepper.', recipeId1)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Make the Batter',
                  'In a bowl, mix flour, baking powder, and a pinch of salt. Gradually whisk in cold water or beer until the batter is smooth.',
                  recipeId1)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Prepare the Potatoes',
                  'Peel and cut the russet potatoes into thick strips. Soak them in cold water for 30 minutes, then drain and pat dry.',
                  recipeId1)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Fry the Potatoes',
                  'Heat oil in a deep fryer or large pot to 350°F (175°C). Fry the potatoes in batches until golden and crispy, about 5-6 minutes. Remove and drain on paper towels.',
                  recipeId1)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Fry the Fish',
                  'Dip the seasoned fish fillets into the batter, allowing any excess to drip off. Carefully place them into the hot oil and fry until golden brown and cooked through, about 4-5 minutes per side. Remove and drain on paper towels.',
                  recipeId1)
              .toJson());

      // ----------------------------- BRUSCHETTA -----------------------------
      int recipeId2 = await database.insert(
        Constants.tableRecipe,
        const Recipe(
                null,
                'Bruschetta',
                RecipeTypeCode.APTZ,
                'Grilled bread rubbed with garlic and topped with fresh tomatoes, basil, and olive oil.',
                'https://richanddelish.com/wp-content/uploads/2023/01/Bruschetta-recipe-with-mozzarella-2.jpg',
                null,
                null)
            .toDB(),
      );

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'Baguette',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0kNpmlAsGqX3BgqgzLRqdHDaI6957rhRBKf59U8pRqHqC-9R9aXFdPy2ScwrJTIjO_lk&usqp=CAU',
                  null,
                  null,
                  recipeId2)
              .toDB());

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'Tomatoes',
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Tomato_je.jpg/1200px-Tomato_je.jpg',
                  null,
                  null,
                  recipeId2)
              .toDB());

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'Basil',
                  'https://sb-assets.sgp1.cdn.digitaloceanspaces.com/product/main_image/60735/small_3236e182-db75-4d5a-ace6-c6ae344a98bd.jpeg',
                  null,
                  null,
                  recipeId2)
              .toDB());

      await database.insert(
          Constants.tableStep,
          RecipeStep(null, 'Prepare the Bread',
                  'Slice the baguette into 1/2-inch thick slices. Lightly brush each slice with olive oil.', recipeId2)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Toast the Bread',
                  'Place the bread slices on a baking sheet and toast in the oven at 400°F (200°C) for about 5-7 minutes, or until golden and crispy.',
                  recipeId2)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Prepare the Tomatoes',
                  'Dice the tomatoes and place them in a bowl. Add chopped basil, minced garlic, olive oil, salt, and pepper. Mix well to combine.',
                  recipeId2)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Assemble the Bruschetta',
                  'Spoon the tomato mixture onto the toasted bread slices. Ensure each slice is evenly topped.',
                  recipeId2)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Serve',
                  'Arrange the bruschetta on a serving platter. Drizzle with balsamic glaze or extra olive oil if desired, and serve immediately.',
                  recipeId2)
              .toJson());

      // ----------------------------- CHOCOLATE LAVA CAKE -----------------------------
      int recipeId3 = await database.insert(
        Constants.tableRecipe,
        const Recipe(
          null,
          'Chocolate Lava Cake',
          RecipeTypeCode.DSRT,
          'A rich and decadent chocolate cake with a molten chocolate center.',
          'https://www.unicornsinthekitchen.com/wp-content/uploads/2016/02/Molten-chocolate-lava-cake-1-700px.jpg',
          null,
          null,
        ).toDB(),
      );

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'Dark Chocolate',
                  'https://www.thespruceeats.com/thmb/ab5Ah9pdp9Ks6dY_9wOYPyLloOQ=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/dark_chocolate1-e58737b8bcbe4e4092f62d42c3c19fe0.jpg',
                  null,
                  null,
                  recipeId3)
              .toDB());

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'Butter',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQiKZMklq8ZsUhV9aufwdsOZV_YAnFtZV8spv-eSZOA9pcT6O5-Ucb2yCubtUbxMSNJuJI&usqp=CAU',
                  null,
                  null,
                  recipeId3)
              .toDB());

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'Eggs',
                  'https://kidseatincolor.com/wp-content/uploads/2022/02/eggs-e1648216369366.jpeg',
                  null,
                  null,
                  recipeId3)
              .toDB());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Prepare the Ramekins',
                  'Preheat the oven to 425°F (220°C). Grease the ramekins with butter and dust with cocoa powder to prevent sticking.',
                  recipeId3)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Melt Chocolate and Butter',
                  'In a double boiler, melt the dark chocolate and butter together until smooth. Remove from heat and let it cool slightly.',
                  recipeId3)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Mix the Batter',
                  'In a bowl, whisk together the eggs, egg yolks, and sugar until thick and pale. Gradually fold in the melted chocolate mixture and then gently fold in the flour until just combined.',
                  recipeId3)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Fill the Ramekins',
                  'Pour the batter into the prepared ramekins, filling them about 3/4 full. Place the ramekins on a baking sheet.',
                  recipeId3)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Bake and Serve',
                  'Bake in the preheated oven for 12-14 minutes, or until the edges are set but the center is still soft. Remove from the oven, let them cool for a minute, then invert onto plates. Serve immediately with a dusting of powdered sugar or a scoop of vanilla ice cream.',
                  recipeId3)
              .toJson());

      // ----------------------------- CAESAR SALAD -----------------------------
      int recipeId4 = await database.insert(
        Constants.tableRecipe,
        const Recipe(
          null,
          'Caesar Salad',
          RecipeTypeCode.SLDS,
          'Crisp romaine lettuce, croutons, and Parmesan cheese tossed with a creamy Caesar dressing.',
          'https://www.recipetineats.com/wp-content/uploads/2016/05/Caesar-Salad_7.jpg',
          null,
          null,
        ).toDB(),
      );

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(null, 'Romaine Lettuce', 'https://cdn.store-assets.com/s/227701/i/19170867.jpg?width=1024',
                  null, null, recipeId4)
              .toDB());

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'Parmesan Cheese',
                  'https://demas.eorder.com.my/wp-content/uploads/2021/10/cheese-powder-white-background-parmesan-fine-savory-salty-222759153.jpg',
                  null,
                  null,
                  recipeId4)
              .toDB());

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'Caesar Dressing',
                  'https://www.ambitiouskitchen.com/wp-content/uploads/2021/02/Vegan-Caesar-Dressing-5.jpg',
                  null,
                  null,
                  recipeId4)
              .toDB());

      await database.insert(
          Constants.tableStep,
          RecipeStep(null, 'Prepare the Lettuce',
                  'Wash and dry the romaine lettuce. Chop or tear the leaves into bite-sized pieces.', recipeId4)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Make the Dressing',
                  'In a bowl, whisk together minced garlic, anchovy paste, lemon juice, Dijon mustard, Worcestershire sauce, and egg yolk. Slowly whisk in olive oil until the dressing is emulsified. Stir in grated Parmesan cheese.',
                  recipeId4)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Toast the Croutons',
                  'Cut a baguette into small cubes. Toss the cubes with olive oil, salt, and pepper. Spread on a baking sheet and bake at 375°F (190°C) for about 10-15 minutes, or until golden and crisp.',
                  recipeId4)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Toss the Salad',
                  'In a large bowl, combine the chopped romaine lettuce and croutons. Pour the dressing over the salad and toss to coat evenly.',
                  recipeId4)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Serve',
                  'Divide the salad among plates. Top with shaved Parmesan cheese and freshly ground black pepper. Serve immediately.',
                  recipeId4)
              .toJson());

      // ----------------------------- MOJITO -----------------------------
      int recipeId5 = await database.insert(
        Constants.tableRecipe,
        const Recipe(
          null,
          'Mojito',
          RecipeTypeCode.BVRG,
          'A refreshing cocktail made with white rum, sugar, lime juice, soda water, and mint.',
          'https://cdn.loveandlemons.com/wp-content/uploads/2020/07/mojito.jpg',
          null,
          null,
        ).toDB(),
      );

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'White Rum',
                  'https://cdn11.bigcommerce.com/s-q90i85/images/stencil/1280x1280/products/479/1205/captainmorganwhiterum___10078.1629630213.png?c=2',
                  null,
                  null,
                  recipeId5)
              .toDB());

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'Mint Leaves',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6SgsdpP-pgX-hlkpt5b0-SoSp7Ie1Tea9di_1B-YJOmvGrr4Itx1mfCo5NlvUAriugoo&usqp=CAU',
                  null,
                  null,
                  recipeId5)
              .toDB());

      await database.insert(
          Constants.tableIngredient,
          RecipeIngredient(
                  null,
                  'Lime',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSyH5kzD8eptNBOGL95jn29NuETAVl2XHpGeXkEzbNDbQ&s',
                  null,
                  null,
                  recipeId5)
              .toDB());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Muddle the Mint',
                  'Place the mint leaves and sugar in a glass. Use a muddler or the back of a spoon to gently crush the mint leaves to release their flavor.',
                  recipeId5)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(
                  null,
                  'Add Lime Juice',
                  'Squeeze the juice of half a lime into the glass. Add the lime wedges to the glass and muddle them with the mint and sugar.',
                  recipeId5)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(null, 'Add the Rum', 'Pour the white rum into the glass and stir well to combine the ingredients.',
                  recipeId5)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(null, 'Add Ice and Soda Water',
                  'Fill the glass with ice cubes, then top off with soda water. Stir gently to mix.', recipeId5)
              .toJson());

      await database.insert(
          Constants.tableStep,
          RecipeStep(null, 'Garnish and Serve',
                  'Garnish the mojito with a sprig of fresh mint and a slice of lime. Serve immediately.', recipeId5)
              .toJson());

      await closeRecipeDb();
    }
  }
  // Future<Todo> insert(Todo todo) async {
  //   todo.id = await db.insert(tableTodo, todo.toMap());
  //   return todo;
  // }
}
