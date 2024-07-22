// This mixin contains queries related to the database.
mixin Query {
  // Version of the database
  int dbVersion = 1;
  // Name of the database
  String dbName = "polaris.db";

  // ----------------- TABLE NAMES BEGIN---------------------- //

  // Name of the language table
  static const String langTable = 'language';
  // Name of the form table
  static const String formTable = "form";
  // Name of the form response table
  static const String formResponse = "responses";

  // Query to create the form table
  String createFormTable = '''CREATE TABLE `$formTable`(
    `id` INTEGER,
    `form_name` TEXT NOT NULL UNIQUE,
    `fields` TEXT,
    PRIMARY KEY("id" AUTOINCREMENT)
  )''';

  // Query to create the form response table
  // sync_status is used to check if the response is synced or not -> 0 means not synced, 1 means synced
  String createFormResponseTable = '''CREATE TABLE `$formResponse`(
    `id` INTEGER,
    `form_name` TEXT NOT NULL,
    `response` TEXT,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `sync_status` INTEGER DEFAULT 0,
    PRIMARY KEY("id" AUTOINCREMENT)
  )''';
}
