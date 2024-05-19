class RecipeIngredient {
  final int? ingredientId;
  final String name;
  final String image;
  final int? quantity;
  final IngredientMeasurement? measurement;
  final int? recipeId;

  const RecipeIngredient(
    this.ingredientId,
    this.name,
    this.image,
    this.quantity,
    this.measurement,
    this.recipeId,
  );

  RecipeIngredient.fromJson(Map<String, dynamic> json)
      : ingredientId = json['ingredientId'],
        name = json['name'],
        image = json['image'],
        quantity = json['quantity'],
        measurement = json['measurement'],
        recipeId = json['recipeId'];

  Map<String, dynamic> toJson() {
    return {
      'ingredientId': ingredientId,
      'name': name,
      'image': image,
      'quantity': quantity,
      'measurement': measurement != null ? measurementEnumToString(measurement!) : measurement,
      'recipeId': recipeId,
    };
  }

  Map<String, dynamic> toDB() {
    return {
      'ingredientId': ingredientId,
      'name': name,
      'image': image,
      'recipeId': recipeId,
    };
  }

  RecipeIngredient.fromDB(Map<dynamic, dynamic> map)
      : ingredientId = map['ingredientId'],
        name = map['name'],
        image = map['image'],
        quantity = null,
        measurement = null,
        recipeId = map['recipeId'];
}

enum IngredientMeasurement {
  SPOON,
  CUP,
  ML,
  GRAM,
  UNIT,
}

// Convert code in enum to string
String measurementEnumToString(IngredientMeasurement measurement) {
  switch (measurement) {
    case IngredientMeasurement.SPOON:
      return 'SPOON';

    case IngredientMeasurement.CUP:
      return 'CUP';

    case IngredientMeasurement.ML:
      return 'ML';

    case IngredientMeasurement.GRAM:
      return 'GRAM';

    case IngredientMeasurement.UNIT:
      return 'UNIT';

    default:
      return '';
  }
}
