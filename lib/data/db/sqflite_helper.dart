// Importing the necessary packages
import 'dart:convert';

import 'package:sqflite_sqlcipher/sqflite.dart';

// Importing the form model and the database query
import '../model/form_model.dart';
import 'db_query.dart';

// SqfLiteHelper class with Query mixin
class SqfLiteHelper with Query {
  // Database instance
  Database? db;

  // Function to create tables in the database
  Future<void> createTables(Database db) async {
    // Execute the query to create the form table
    await db.execute(createFormTable);
    await db.execute(createFormResponseTable);
  }

  // Function to initialize the SQL database
  Future<Database> initializeSqlDB() async {
    // Get the database path
    var path = await getDatabasesPath();

    // Open the database with the given path, version, and password
    // If the database is not initialized, it will be created
    db ??= await openDatabase(
      "$path/$dbName",
      version: dbVersion,
      password: "123", //CHANGE PASSWORD AS NEEDED
      onCreate: (db, version) async {
        // Create tables in the database
        await createTables(db);
      },
    );
    return db!;
  }

  // Function to insert a form response into the database
  Future<void> insertFormResponse(List<FormModel> formResponses) async {
    // Get the database instance
    Database db = this.db ?? await initializeSqlDB();
    Batch batch = db.batch();
    for (var formResponse in formResponses) {
      // Insert the form response into the form table
      batch.insert(Query.formTable, formResponse.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  // Function to fetch all form responses from the database
  Future<List<FormModel>> fetchFormResponse([String? formName]) async {
    // Get the database instance
    Database db = this.db ?? await initializeSqlDB();

    // Query the form table
    var formResponse =
        await db.query(Query.formTable, where: formName != null ? "form_name = ?" : null, whereArgs: formName != null ? [formName] : null);

    // List to store the form responses
    List<FormModel> responses = [];

    // Loop through each response and add it to the list
    for (var response in formResponse) {
      responses.add(FormModel.fromJson(response));
    }

    // Return the list of form responses
    return responses;
  }

  Future<void> saveResponse(String formName, Map<String, dynamic> response) async {
    Database db = this.db ?? await initializeSqlDB();

    await db.insert(Query.formResponse, {"form_name": formName, "response": jsonEncode(response)}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateSyncStatus(List<int> id) async {
    Database db = this.db ?? await initializeSqlDB();
    await db.update(Query.formResponse, {"sync_status": 1}, where: "id in (${id.join(",")})");
  }

  Future<List<Map<String, dynamic>>> getUnSyncedResponses() async {
    Database db = this.db ?? await initializeSqlDB();
    return await db.query(Query.formResponse, where: "sync_status = ?", whereArgs: [0]);
  }
}
