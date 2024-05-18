// Category of recipes
class RecipeType {
  final String name;
  final String description;

  const RecipeType(
    this.name,
    this.description,
  );

  RecipeType.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}
