import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'product.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'products.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY,
            name TEXT,
            price REAL
          )
        ''');
      },
    );
  }

  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert('products', product.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Product>> fetchProducts() async {
    final db = await database;
    final maps = await db.query('products');

    return List.generate(maps.length, (i) {
      return Product.fromJson(maps[i]);
    });
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
