import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeDetailPage extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.imagePath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  recipe.imagePath,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 16),
            Text(recipe.description, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 20),
            Text(
              'Ingrédients',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...recipe.ingredients.map((item) => Text('- $item')),

            const SizedBox(height: 20),
            Text(
              'Préparation',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...recipe.steps.map((step) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text('- $step'),
            )).toList(),

          ],
        ),
      ),
    );
  }
}