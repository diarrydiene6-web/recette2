import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import '../models/recipe.dart';

final recipeBoxProvider = Provider<Box<Recipe>>((ref) {
  return Hive.box<Recipe>('recipesBox');
});

final recipeProvider = FutureProvider<List<Recipe>>((ref) async {
  final box = ref.watch(recipeBoxProvider);

  if (box.isNotEmpty) {
    return box.values.toList();
  }

  final String jsonString = await rootBundle.loadString(
    'assets/json/recipes.json',
  );

  final List<dynamic> jsonList = json.decode(jsonString);
  final recipes = jsonList.map((json) => Recipe.fromJson(json)).toList();

  for (var recipe in recipes) {
    box.put(recipe.id, recipe);
  }

  return recipes;
});

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String newQuery) {
    state = newQuery;
  }
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(() {
  return SearchQueryNotifier();
});

final filteredRecipesProvider = Provider<List<Recipe>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final recipesAsync = ref.watch(recipeProvider);

  return recipesAsync.maybeWhen(
    data: (recipes) {
      if (query.isEmpty) return recipes;
      return recipes
          .where(
            (recipe) => recipe.name.toLowerCase().contains(query.toLowerCase()),
      )
          .toList();
    },
    orElse: () => [],
  );
});