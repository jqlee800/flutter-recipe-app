class RecipeStep {
  final int? stepId;
  final String name;
  final String? description;
  final int? recipeId;

  const RecipeStep(
    this.stepId,
    this.name,
    this.description,
    this.recipeId,
  );

  RecipeStep.fromJson(Map<String, dynamic> json)
      : stepId = json['stepId'],
        name = json['name'],
        description = json['description'],
        recipeId = json['recipeId'];

  Map<String, dynamic> toJson() {
    return {
      'stepId': stepId,
      'name': name,
      'description': description,
      'recipeId': recipeId,
    };
  }

  RecipeStep.fromDB(Map<dynamic, dynamic> json)
      : stepId = json['stepId'],
        name = json['name'],
        description = json['description'],
        recipeId = json['recipeId'];
}
