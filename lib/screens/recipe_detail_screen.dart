import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import '../providers/historique_provider.dart';
import '../providers/recipe_providers.dart';
import 'add_edit_recipe_screen.dart';

class RecipeDetailPage extends ConsumerStatefulWidget {
  final Recipe recipe;
  const RecipeDetailPage({super.key, required this.recipe});

  @override
  ConsumerState<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends ConsumerState<RecipeDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(historiqueProvider.notifier).enregistrerConsultation(
        widget.recipe.id,
        widget.recipe.name,
      );
    });
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la recette'),
        content: Text('Voulez-vous vraiment supprimer "${widget.recipe.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(recipeRepositoryProvider).deleteRecipe(widget.recipe.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Modifier',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditRecipeScreen(recipe: recipe),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Supprimer',
            onPressed: _confirmDelete,
          ),
        ],
      ),
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
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    size: 60,
                  ),
                ),
              ),

            const SizedBox(height: 16),
            Text(recipe.description, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 20),
            const Text(
              'Ingrédients',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...recipe.ingredients.map((item) => Text('- $item')),

            const SizedBox(height: 20),
            const Text(
              'Préparation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...recipe.steps.map((step) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text('- $step'),
            )),
          ],
        ),
      ),
    );
  }
}