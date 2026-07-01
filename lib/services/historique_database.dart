import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/historique_entry.dart';

class HistoriqueDatabase {
  static final HistoriqueDatabase instance = HistoriqueDatabase._init();
  static Database? _database;

  HistoriqueDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('historique.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE historique (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recetteId TEXT NOT NULL,
        recetteNom TEXT NOT NULL,
        dateConsultation TEXT NOT NULL,
        estFavori INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // Enregistrer une consultation
  Future<int> ajouterConsultation(HistoriqueEntry entry) async {
    final db = await instance.database;
    return await db.insert('historique', entry.toMap());
  }

  // Récupérer tout l'historique, trié du plus récent au plus ancien
  Future<List<HistoriqueEntry>> getHistorique() async {
    final db = await instance.database;
    final result = await db.query(
      'historique',
      orderBy: 'dateConsultation DESC',
    );
    return result.map((map) => HistoriqueEntry.fromMap(map)).toList();
  }

  // Récupérer uniquement les favoris
  Future<List<HistoriqueEntry>> getFavoris() async {
    final db = await instance.database;
    final result = await db.query(
      'historique',
      where: 'estFavori = ?',
      whereArgs: [1],
      orderBy: 'dateConsultation DESC',
    );
    return result.map((map) => HistoriqueEntry.fromMap(map)).toList();
  }

  // Marquer/démarquer une recette comme favorite
  Future<int> toggleFavori(String recetteId, bool estFavori) async {
    final db = await instance.database;
    return await db.update(
      'historique',
      {'estFavori': estFavori ? 1 : 0},
      where: 'recetteId = ?',
      whereArgs: [recetteId],
    );
  }

  // Supprimer une entrée de l'historique
  Future<int> supprimerEntree(int id) async {
    final db = await instance.database;
    return await db.delete('historique', where: 'id = ?', whereArgs: [id]);
  }

  // Vider tout l'historique
  Future<int> viderHistorique() async {
    final db = await instance.database;
    return await db.delete('historique');
  }
}