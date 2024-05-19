import 'package:flutter/material.dart';

@immutable
abstract class RecipeEvent {}

class RecipeGetAll extends RecipeEvent {
  RecipeGetAll();
}
