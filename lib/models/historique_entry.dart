class HistoriqueEntry {
  final int? id;
  final String recetteId;
  final String recetteNom;
  final DateTime dateConsultation;
  final bool estFavori;

  HistoriqueEntry({
    this.id,
    required this.recetteId,
    required this.recetteNom,
    required this.dateConsultation,
    this.estFavori = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recetteId': recetteId,
      'recetteNom': recetteNom,
      'dateConsultation': dateConsultation.toIso8601String(),
      'estFavori': estFavori ? 1 : 0,
    };
  }

  factory HistoriqueEntry.fromMap(Map<String, dynamic> map) {
    return HistoriqueEntry(
      id: map['id'],
      recetteId: map['recetteId'],
      recetteNom: map['recetteNom'],
      dateConsultation: DateTime.parse(map['dateConsultation']),
      estFavori: map['estFavori'] == 1,
    );
  }
}