class RecipeIngredient {
  final int? ingredientId;
  final String name;
  final int quantity;
  final IngredientMeasurement measurement;
  final int? recipeId;

  const RecipeIngredient(
    this.ingredientId,
    this.name,
    this.quantity,
    this.measurement,
    this.recipeId,
  );

  RecipeIngredient.fromJson(Map<String, dynamic> json)
      : ingredientId = json['ingredientId'],
        name = json['name'],
        quantity = json['quantity'],
        measurement = json['measurement'],
        recipeId = json['recipeId'];

  Map<String, dynamic> toJson() {
    return {
      'ingredientId': ingredientId,
      'name': name,
      'quantity': quantity,
      'measurement': measurementEnumToString(measurement),
      'recipeId': recipeId,
    };
  }
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
