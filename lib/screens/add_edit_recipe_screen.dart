import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/recipe.dart';
import '../providers/recipe_providers.dart';

class AddEditRecipeScreen extends ConsumerStatefulWidget {
  final Recipe? recipe; // null = ajout, non-null = modification

  const AddEditRecipeScreen({super.key, this.recipe});

  @override
  ConsumerState<AddEditRecipeScreen> createState() => _AddEditRecipeScreenState();
}

class _AddEditRecipeScreenState extends ConsumerState<AddEditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _summaryController;
  late TextEditingController _descriptionController;
  late TextEditingController _ingredientsController;
  late TextEditingController _stepsController;
  late TextEditingController _imagePathController;
  late TextEditingController _categoryController;

  bool get isEditing => widget.recipe != null;

  @override
  void initState() {
    super.initState();
    final r = widget.recipe;
    _nameController = TextEditingController(text: r?.name ?? '');
    _summaryController = TextEditingController(text: r?.summary ?? '');
    _descriptionController = TextEditingController(text: r?.description ?? '');
    _ingredientsController = TextEditingController(text: r?.ingredients.join('\n') ?? '');
    _stepsController = TextEditingController(text: r?.steps.join('\n') ?? '');
    _imagePathController = TextEditingController(text: r?.imagePath ?? '');
    _categoryController = TextEditingController(text: r?.category ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _summaryController.dispose();
    _descriptionController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    _imagePathController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final ingredients = _ingredientsController.text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final steps = _stepsController.text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final recipe = Recipe(
      id: widget.recipe?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      summary: _summaryController.text.trim(),
      description: _descriptionController.text.trim(),
      ingredients: ingredients,
      steps: steps,
      imagePath: _imagePathController.text.trim(),
      category: _categoryController.text.trim(),
    );

    final repo = ref.read(recipeRepositoryProvider);
    if (isEditing) {
      await repo.updateRecipe(recipe);
    } else {
      await repo.addRecipe(recipe);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Modifier la recette' : 'Nouvelle recette'),
        backgroundColor: Colors.orange,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nom'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Obligatoire' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _summaryController,
              decoration: const InputDecoration(labelText: 'Résumé court'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ingredientsController,
              decoration: const InputDecoration(
                labelText: 'Ingrédients (un par ligne)',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _stepsController,
              decoration: const InputDecoration(
                labelText: 'Étapes de préparation (une par ligne)',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _imagePathController,
              decoration: const InputDecoration(
                labelText: 'Chemin de l\'image (ex: assets/images/xxx.jpg)',
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Catégorie'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(isEditing ? 'Enregistrer les modifications' : 'Ajouter la recette'),
            ),
          ],
        ),
      ),
    );
  }
}