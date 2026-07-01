import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/historique_entry.dart';
import '../services/historique_database.dart';

final historiqueProvider =
NotifierProvider<HistoriqueNotifier, List<HistoriqueEntry>>(
  HistoriqueNotifier.new,
);

class HistoriqueNotifier extends Notifier<List<HistoriqueEntry>> {
  @override
  List<HistoriqueEntry> build() {
    chargerHistorique();
    return [];
  }

  Future<void> chargerHistorique() async {
    state = await HistoriqueDatabase.instance.getHistorique();
  }

  Future<void> enregistrerConsultation(String recetteId, String recetteNom) async {
    final entry = HistoriqueEntry(
      recetteId: recetteId,
      recetteNom: recetteNom,
      dateConsultation: DateTime.now(),
    );
    await HistoriqueDatabase.instance.ajouterConsultation(entry);
    await chargerHistorique();
  }

  Future<void> toggleFavori(String recetteId, bool estFavori) async {
    await HistoriqueDatabase.instance.toggleFavori(recetteId, estFavori);
    await chargerHistorique();
  }
}