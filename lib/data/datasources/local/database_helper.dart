import 'package:sqflite/sqflite.dart';
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    if (!Platform.isAndroid && !Platform.isIOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'portfolio_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rating (
        id TEXT PRIMARY KEY,
        value REAL NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE rating_comments (
        id TEXT PRIMARY KEY,
        rating_id TEXT NOT NULL,
        text TEXT NOT NULL,
        type TEXT NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (rating_id) REFERENCES rating (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE projects (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        status TEXT NOT NULL,
        progress INTEGER NOT NULL,
        image_url TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        project_id TEXT NOT NULL,
        title TEXT NOT NULL,
        deadline TEXT,
        category TEXT,
        completed INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE courses (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        platform TEXT NOT NULL,
        date_completed TEXT NOT NULL,
        status TEXT NOT NULL,
        has_certificate INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE achievements (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        category TEXT NOT NULL,
        image_url TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE hours (
        id TEXT PRIMARY KEY,
        project_name TEXT NOT NULL,
        task TEXT NOT NULL,
        hours INTEGER NOT NULL,
        minutes INTEGER NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    final projects = [
      {
        'id': '1',
        'title': 'Мобильное приложение "Рабочее портфолио"',
        'description': 'Разработка Flutter приложения для учета рабочих проектов',
        'status': 'На паузе',
        'progress': 0,
        'image_url': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJ8nqfnmxH7hXRfEUDHi2JtMDf3_Ox69iS2g&s'
      },
      {
        'id': '2',
        'title': 'Корпоративный портал',
        'description': 'Веб-приложение для внутреннего использования компании',
        'status': 'Завершен',
        'progress': 100,
        'image_url': 'https://habrastorage.org/files/813/b47/91f/813b4791fb274fa98ab8bdb7eec03acb.png'
      },
      {
        'id': '3',
        'title': 'E-commerce платформа',
        'description': 'Интернет-магазин с системой управления заказами',
        'status': 'В планах',
        'progress': 0,
        'image_url': 'https://eurobyte.ru/img/articles/plyusy-i-minusy-internet-magazina/image1.png'
      },
      {
        'id': '4',
        'title': 'Система аналитики',
        'description': 'Система визуализации и анализа ключевых бизнес-метрик в реальном времени.',
        'status': 'На паузе',
        'progress': 30,
        'image_url': 'https://cdn-icons-png.flaticon.com/512/2721/2721264.png'
      }
    ];

    for (var p in projects) {
      await db.insert('projects', p);
    }

    final tasks = [
      {'id': '1', 'project_id': '1', 'title': 'Разработать архитектуру приложения', 'completed': 0},
      {'id': '2', 'project_id': '1', 'title': 'Создать интерфейс пользователя', 'completed': 0},
      {'id': '3', 'project_id': '1', 'title': 'Протестировать функционал', 'completed': 0},
    ];

    for (var t in tasks) {
      await db.insert('tasks', t);
    }

    final hours = [
      {'id': '1', 'project_name': 'Мобильное приложение', 'task': 'Разработка интерфейса', 'hours': 3, 'minutes': 30, 'date': '15.01.2024'},
      {'id': '2', 'project_name': 'Веб-сайт', 'task': 'Интеграция API', 'hours': 0, 'minutes': 0, 'date': ''},
      {'id': '3', 'project_name': 'Документация', 'task': 'Написание руководства', 'hours': 1, 'minutes': 45, 'date': '13.01.2024'},
      {'id': '4', 'project_name': 'Тестирование', 'task': 'Функциональное тестирование', 'hours': 4, 'minutes': 15, 'date': '12.01.2024'},
      {'id': '5', 'project_name': 'Дизайн', 'task': 'Создание макетов', 'hours': 2, 'minutes': 30, 'date': '11.01.2024'},
      {'id': '6', 'project_name': 'Совещание', 'task': 'Планирование спринта', 'hours': 1, 'minutes': 0, 'date': '10.01.2024'},
      {'id': '7', 'project_name': 'База данных', 'task': 'Оптимизация запросов', 'hours': 3, 'minutes': 0, 'date': '09.01.2024'},
      {'id': '8', 'project_name': 'Code Review', 'task': 'Проверка кода команды', 'hours': 2, 'minutes': 20, 'date': '08.01.2024'},
    ];

    for (var h in hours) {
      await db.insert('hours', h);
    }

    await db.insert('rating', {
      'id': 'main_rating',
      'value': 4.5,
    });

    final ratingComments = [
      {
        'id': 'positive_1',
        'rating_id': 'main_rating',
        'text': 'Хорошая организация рабочего процесса',
        'type': 'positive',
        'date': '01.01.2025'
      },
      {
        'id': 'positive_2',
        'rating_id': 'main_rating',
        'text': 'Своевременное выполнение задач',
        'type': 'positive',
        'date': '01.01.2025'
      },
      {
        'id': 'negative_1',
        'rating_id': 'main_rating',
        'text': 'Иногда задерживаются дедлайны',
        'type': 'negative',
        'date': '01.01.2025'
      },
    ];

    for (var c in ratingComments) {
      await db.insert('rating_comments', c);
    }
  }
}