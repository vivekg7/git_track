import 'dart:io';

import 'package:git_track/models/url.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;  // A single DatabaseHelper (once in whole app)
  static Database _database;

  String urlTable = "url_table";
  String colId = "id";
  String colTime = "time";
  String colUrl = "url";

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {

    if ( _databaseHelper == null ) {
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {

    if ( _database == null ) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'simplechat.db';

    // Open/create the database
    var userDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return userDatabase;
  }

  void _createDb(Database db, int newV) async {
    await db.execute('CREATE TABLE $urlTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTime TEXT, '
        '$colUrl TEXT)');
  }

  // Fetch operation : get all urls from database
  Future<List<Map<String, dynamic>>> getUrlMapList() async {
    Database db = await this.database;

    var result = await db.rawQuery('SELECT * FROM $urlTable');

    return result;
  }

  // Insert operation :
  Future<int> insertUrl(Url url) async {
    Database db = await this.database;
    var result = await db.insert(urlTable, url.toMap());
    return result;
  }

  // Update operation :
  Future<int> updateUrl(Url url) async {
    Database db = await this.database;
    var result = await db.update(urlTable, url.toMap(), where: '$colId = ?', whereArgs: [url.id]);
    return result;
  }

  // Delete operation :
  Future<int> deleteUrl(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $urlTable WHERE $colId = $id');
    return result;
  }

  // Get number of note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $urlTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the Map List and Convert it to noteList
  Future <List<Url>> getUrlList() async {

    var urlMapList = await getUrlMapList();

    int count =  urlMapList.length;

    List<Url> urlList = List<Url>();

    for ( int i=0; i<count; i++ ) {
      urlList.add(Url.fromMapObject(urlMapList[i]));
    }

    return urlList;

  }

}