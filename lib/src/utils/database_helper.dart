import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uhsaf/src/utils/csv_utils.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _csvName = "data-${DateTime.now()}.csv";
  static final _databaseVersion = 1;

  static final table = 'SAF';

  static final columnId = '_id';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  Future<String> csvString() async {
    List<Map<String, dynamic>> data = await this.queryAllRows();
    return mapListToCsv(data);
  }

  Future<String> saveCSV() async {
    String csvData = await this.csvString();
    List<Directory> _externalStorageDirectories =
        await getExternalStorageDirectories(type: StorageDirectory.downloads);
    String downloadPath = _externalStorageDirectories[0].path;
    String csvPath = '$downloadPath/$_csvName';
    File file = File(csvPath);
    print(csvPath);
    await file.writeAsString(csvData, mode: FileMode.writeOnly, flush: true);
    return csvPath;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            municipality TEXT NOT NULL,
            saf TEXT NOT NULL,
            name TEXT NOT NULL,
            address TEXT NOT NULL,
            identifier TEXT NOT NULL,
            assistance TEXT NOT NULL,
            satisfaction TEXT NOT NULL,
            quality TEXT NOT NULL,
            opinions TEXT NOT NULL,
            causes TEXT NOT NULL,
            timestamp TEXT NOT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    row['timestamp'] = '${DateTime.now()}';
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
