import 'package:flutter_assignment/models/course_data.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CourseDatabase {
  static final CourseDatabase instance = CourseDatabase._init();

  static Database? _database;

  CourseDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("course.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    final textType = "TEXT NOT NULL";
    final intType = "INTEGER NOT NULL";

    await db.execute('''
      CREATE TABLE $tableNotes (
        ${CourseFields.id} $idType
        ${CourseFields.name} $textType
        ${CourseFields.description} $textType
        ${CourseFields.language} $textType
        ${CourseFields.watchersCount} $intType
        ${CourseFields.stargazerCount} $intType
      )
    ''');
  }

  Future<CourseData> create(CourseData courseData) async {
    final db = await instance.database;

    final id = await db.insert(tableNotes, courseData.toJson());
    return courseData.copy(id: id);
  }

  Future<CourseData> readCourse(int id) async {
    final db = await instance.database;

    final maps = await db.query(tableNotes,
        columns: CourseFields.values,
        where: '${CourseFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return CourseData.fromJson(maps.first);
    } else {
      throw Exception("ID $id not Found");
    }
  }

  Future<List<CourseData>> readAllCourses() async {
    final db = await instance.database;

    final result = await db.query(tableNotes);
    return result.map((json) => CourseData.fromJson(json)).toList();
  }

  Future<int> update(CourseData courseData) async {
    final db = await instance.database;

    return await db.update(
      tableNotes,
      courseData.toJson(),
      where: '${CourseFields.id} = ?',
      whereArgs: [courseData.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${CourseFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await instance.database;

    db.close();
  }
}
