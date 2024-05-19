import 'package:flutter/material.dart';

@immutable
abstract class RecipeEvent {}

class RecipeTypeGetAll extends RecipeEvent {
  RecipeTypeGetAll();
}

class RecipeGetAll extends RecipeEvent {
  RecipeGetAll();
}
