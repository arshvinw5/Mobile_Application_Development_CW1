import 'package:note_app/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //creating singleton design patter for database
  //creating instance
  static final DatabaseHelper instance = DatabaseHelper._init();
  //holds the actual SQLite database object.
  static Database? _database;
  //constructor
  DatabaseHelper._init();

  //creating actual get method to our database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await getDatabase();
    return _database!;
  }

  //function to setup database
  Future<Database> getDatabase() async {
    //directory to save database
    final dbDirectPath = await getDatabasesPath();
    //actual path to store data and name of our db
    final path = join(dbDirectPath, "note_db.db");
    //open up the db / creating tables
    final db = await openDatabase(path, version: 1, onCreate: _createDB);
    // we have to return db once we are open it
    return db;
  }

//version can be use whether do we need it to upgrade or downgrade it
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        modifiedTime TEXT NOT NULL
      )
    ''');

    // New table to store app-wide settings
    await db.execute('''
    CREATE TABLE settings (
      key TEXT PRIMARY KEY,
      value TEXT
    )
  ''');
  }

  //passing the note map
  Future<int> addNote(Note note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes() async {
    final db = await instance.database;
    final notes = await db.query('notes', orderBy: 'modifiedTime DESC');
    return notes.map((json) => Note.fromMap(json)).toList();
  }

  //Upgrade note
  Future<void> updateNote(Note note) async {
    final db = await database;
    // Debugging: Print the note to be updated
    print("Updating note in database: ${note.toMap()}");
    await db.update(
      'notes',
      note.toMap(), // Ensure your Note object has a toMap method to convert it to a Map
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  //delete notes
  Future<void> deleteNoteById(int id) async {
    final db = await instance.database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Method to save the theme mode setting
  Future<void> saveThemeSetting(bool isDarkMode) async {
    final db = await instance.database;
    await db.insert(
      'settings',
      {'key': 'isDarkMode', 'value': isDarkMode ? '1' : '0'},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Method to retrieve the theme setting
  Future<bool> loadThemeSetting() async {
    final db = await instance.database;
    final result = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['isDarkMode'],
    );

    if (result.isNotEmpty) {
      return result.first['value'] == '1';
    }
    return false; // default to light mode if not set
  }

  Future<void> setSetting(String key, String value) async {
    final db = await instance.database;
    await db.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await instance.database;
    final result = await db.query(
      'settings',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: [key],
    );
    if (result.isNotEmpty) {
      return result.first['value'] as String;
    }
    return null;
  }

  Future<void> addDummyNoteIfNeeded() async {
    // Check if the dummy note has been added previously
    final dummyNoteAdded = await getSetting('dummyNoteAdded');

    if (dummyNoteAdded != 'true') {
      // Add the dummy note if it hasn't been added before
      final dummyNote = Note(
        title: 'Welcome to Note App!',
        content:
            'Hello and welcome to your Note App! Here\'s a quick guide:\n\n'
            '1.Add a Note** - Tap "+" to create a new note.\n'
            '2.Edit a Note** - Tap on a note to edit.\n'
            '3.Delete a Note** - Swipe left to delete.\n\n'
            'Enjoy your note-taking journey!',
        modifiedTime: DateTime.now(),
        id: null,
      );

      await addNote(dummyNote);

      // Mark the dummy note as added in the settings table
      await setSetting('dummyNoteAdded', 'true');
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
