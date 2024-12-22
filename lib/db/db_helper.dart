import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  static Database? _database;

  // Création de la base de données
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  // Initialisation de la base de données
  _initDB() async {
    String path = join(await getDatabasesPath(), 'user_data.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Création de la table pour l'inscription
  _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT,
        prenom TEXT,
        numero TEXT,
        pin TEXT,
        taux TEXT
      )
    ''');
  }

  // Insérer les données d'inscription dans la base de données
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Récupérer tous les utilisateurs (optionnel)
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<Map<String, dynamic>?> getUserByNumero(String numero) async {
    final db = await database;
    final result = await db.query(
      'users', // Nom de la table
      where: 'numero = ?', // Condition pour vérifier le numéro
      whereArgs: [numero], // Valeur du numéro
    );

    if (result.isNotEmpty) {
      return result.first; // Retourne la première correspondance
    }
    return null; // Retourne null si aucun utilisateur trouvé
  }
}
