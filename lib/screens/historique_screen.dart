import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/historique_provider.dart';

class HistoriqueScreen extends ConsumerWidget {
  const HistoriqueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historique = ref.watch(historiqueProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
      body: historique.isEmpty
          ? const Center(child: Text('Aucune recette consultée pour le moment'))
          : ListView.builder(
        itemCount: historique.length,
        itemBuilder: (context, index) {
          final entry = historique[index];
          return ListTile(
            title: Text(entry.recetteNom),
            subtitle: Text(
              '${entry.dateConsultation.day}/${entry.dateConsultation.month}/${entry.dateConsultation.year} '
                  'à ${entry.dateConsultation.hour}:${entry.dateConsultation.minute.toString().padLeft(2, '0')}',
            ),
            trailing: IconButton(
              icon: Icon(
                entry.estFavori ? Icons.favorite : Icons.favorite_border,
                color: entry.estFavori ? Colors.red : null,
              ),
              onPressed: () {
                ref.read(historiqueProvider.notifier).toggleFavori(
                  entry.recetteId,
                  !entry.estFavori,
                );
              },
            ),
          );
        },
      ),
    );
  }
}