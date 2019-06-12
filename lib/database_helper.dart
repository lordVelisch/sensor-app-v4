import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final String tableLocations = 'locations';
final String columnId = '_id';
final String columnLatitude = 'latitude';
final String columnLongitude = 'longitude';

class Location {

  int id;
  String latitude;
  String longitude;
  // todo String timestamp;

  Location();

  Location.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    latitude = map[columnLatitude];
    longitude = map[columnLongitude];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnLatitude: latitude,
      columnLongitude: longitude
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableLocations (
                $columnId INTEGER PRIMARY KEY,
                $columnLatitude TEXT NOT NULL,
                $columnLongitude TEXT NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Location location) async {
    Database db = await database;
    int id = await db.insert(tableLocations, location.toMap());
    return id;
  }

  Future<Location> queryLocation(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableLocations,
        columns: [columnId, columnLatitude, columnLongitude],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Location.fromMap(maps.first);
    }
    return null;
  }

// TODO: queryAllWords()
// TODO: delete(int id)
// TODO: update(Word word)
}

