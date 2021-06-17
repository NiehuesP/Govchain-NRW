import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:studybuddy/objects/course_object.dart';
import 'package:studybuddy/objects/course_progress_object.dart';
import 'package:studybuddy/objects/dummy_data.dart';
import 'package:studybuddy/objects/event_object.dart';
import 'package:studybuddy/objects/event_progress_object.dart';
import 'package:studybuddy/objects/event_settings_object.dart';
import 'package:studybuddy/objects/exam_data_object.dart';
import 'package:studybuddy/objects/exam_object.dart';
import 'package:studybuddy/objects/file_upload_object.dart';
import 'package:studybuddy/objects/professor_object.dart';
import 'package:studybuddy/objects/semester_object.dart';
import 'package:studybuddy/objects/student_course_object.dart';
import 'package:studybuddy/objects/student_event_object.dart';
import 'package:studybuddy/objects/student_exam_object.dart';
import 'package:studybuddy/objects/student_object.dart';
import 'package:studybuddy/objects/student_semester_object.dart';
import 'package:tuple/tuple.dart';

class DatabaseService {
  static final _databaseName = "studybuddy.db";
  static final _databaseVersion = 1;

  static final studentTable = 'students';
  static final courseTable = 'courses';
  static final eventTable = 'events';
  static final professorTable = 'professors';
  static final semesterTable = 'semesters';
  static final studentCourseTable = 'studentCourses';
  static final studentEventTable = 'studentEvents';
  static final studentSemesterTable = 'studentSemester';
  static final eventSettingsTable = 'eventSettings';
  static final examsTable = 'exams';
  static final studentExamTable = 'studentExams';
  static final tempUploadedFileTable = 'uploadedFiles';

  ////////////////////////////////////////////// Student Table //////////////////////////////////////////////

  static final studentColId = 'studentId';
  static final studentColFirstName = 'firstName';
  static final studentColLastName = 'lastName';
  static final studentColMatriculation = 'matriculation';
  static final studentColDateOfBirth = 'dateOfBirth';
  static final studentColUniversity = 'university';
  static final studentColFaculty = 'faculty';
  static final studentColField = 'field';
  static final studentColDegree = 'degree';
  static final studentColFhIdentifier = 'fhIdentifier';
  static final studentColPassword = 'password';

  void createStudentTable(Database db) async {
    await db.execute('''
          CREATE TABLE $studentTable (
            $studentColId INTEGER PRIMARY KEY,
            $studentColFirstName TEXT NOT NULL,
            $studentColLastName TEXT NOT NULL,
            $studentColMatriculation INTEGER,
            $studentColDateOfBirth TEXT,
            $studentColUniversity TEXT,
            $studentColFaculty TEXT,
            $studentColField TEXT,
            $studentColDegree TEXT,
            $studentColFhIdentifier TEXT,
            $studentColPassword TEXT,
            UNIQUE ( $studentColId )
          )
          ''');
  }

  ////////////////////////////////////////////// Student Table //////////////////////////////////////////////


  ////////////////////////////////////////////// Course Table //////////////////////////////////////////////

  static final courseColId = 'courseId';
  static final courseColName = 'name';
  static final courseColShortName = 'shortName';
  static final courseColSemesterId = 'semesterId';
  static final courseColProfessorId = 'professorId';

  void createCourseTable(Database db) async {
    await db.execute('''
          CREATE TABLE $courseTable (
            $courseColId INTEGER PRIMARY KEY,
            $courseColName TEXT NOT NULL,
            $courseColShortName TEXT NOT NULL,
            $courseColSemesterId INTEGER NOT NULL,
            $courseColProfessorId INTEGER NOT NULL,
            UNIQUE ( $courseColId )
          )
          ''');
  }

  ////////////////////////////////////////////// Course Table //////////////////////////////////////////////


  ////////////////////////////////////////////// Event Table //////////////////////////////////////////////

  static final eventColId = 'eventId';
  static final eventColDate = 'date';
  static final eventColName = 'name';
  static final eventColRoom = 'room';
  static final eventColTime = 'time';
  static final eventColCourseId = 'courseId';

  void createEventTable(Database db) async {
    await db.execute('''
          CREATE TABLE $eventTable (
            $eventColId INTEGER PRIMARY KEY,
            $eventColDate TEXT NOT NULL,
            $eventColName TEXT NOT NULL,
            $eventColRoom TEXT NOT NULL,
            $eventColTime TEXT NOT NULL,
            $eventColCourseId INTEGER NOT NULL,
            UNIQUE ( $eventColId )
          )
          ''');
  }

  ////////////////////////////////////////////// Event Table //////////////////////////////////////////////


  ////////////////////////////////////////////// Professor Table //////////////////////////////////////////////

  static final professorColId = 'professorId';
  static final professorColFirstName = 'firstName';
  static final professorColLastName = 'lastName';
  static final professorColTitle = 'title';
  static final professorColFhIdentifier = 'fhIdentifier';
  static final professorColPassword = 'password';

  void createProfessorTable(Database db) async {
    await db.execute('''
          CREATE TABLE $professorTable (
            $professorColId INTEGER PRIMARY KEY,
            $professorColFirstName TEXT NOT NULL,
            $professorColLastName TEXT NOT NULL,
            $professorColTitle TEXT NOT NULL,
            $professorColFhIdentifier TEXT,
            $professorColPassword TEXT,
            UNIQUE ( $professorColId )
          )
          ''');
  }

  ////////////////////////////////////////////// Professor Table //////////////////////////////////////////////


  ////////////////////////////////////////////// Semester Table //////////////////////////////////////////////

  static final semesterColId = 'semesterId';
  static final semesterColName = 'name';
  static final semesterColStartDate = 'startDate';
  static final semesterColEndDate = 'endDate';

  void createSemesterTable(Database db) async {
    await db.execute('''
          CREATE TABLE $semesterTable (
            $semesterColId INTEGER PRIMARY KEY,
            $semesterColName TEXT NOT NULL,
            $semesterColStartDate TEXT NOT NULL,
            $semesterColEndDate TEXT NOT NULL,
            UNIQUE ( $semesterColId )
          )
          ''');
  }

  ////////////////////////////////////////////// Semester Table //////////////////////////////////////////////


  ////////////////////////////////////////////// Student Course Table //////////////////////////////////////////////

  static final studentCourseColStudentId = 'studentId';
  static final studentCourseColCourseId = 'courseId';
  static final studentCourseColCompleted = 'completed';
  static final studentCourseColDate = 'date';
  static final studentCourseColTime = 'time';
  static final studentCourseColProfessorId = 'professorId';
  static final studentCourseColSemesterId = 'semesterId';

  void createStudentCourseTable(Database db) async {
    await db.execute('''
          CREATE TABLE $studentCourseTable (
            $studentCourseColStudentId INTEGER NOT NULL,
            $studentCourseColCourseId INTEGER NOT NULL,
            $studentCourseColCompleted TEXT NOT NULL,
            $studentCourseColDate TEXT,
            $studentCourseColTime TEXT,
            $studentCourseColProfessorId INTEGER,
            $studentCourseColSemesterId INTEGER,
            FOREIGN KEY ( $studentCourseColStudentId ) REFERENCES $studentTable($studentColId),
            FOREIGN KEY ( $studentCourseColCourseId ) REFERENCES $courseTable($courseColId),
            PRIMARY KEY ( $studentCourseColStudentId, $studentCourseColCourseId ),
            UNIQUE ( $studentCourseColStudentId, $studentCourseColCourseId )
          )
          ''');
  }

  ////////////////////////////////////////////// Student Course Table //////////////////////////////////////////////


  ////////////////////////////////////////////// Student Event Table //////////////////////////////////////////////

  static final studentEventColStudentId = 'studentId';
  static final studentEventColEventId = 'eventId';
  static final studentEventColProfessorId = 'professorId';
  static final studentEventColDate = 'date';
  static final studentEventColTime = 'time';
  static final studentEventColStatus = 'status';

  void createStudentEventTable(Database db) async {
    await db.execute('''
          CREATE TABLE $studentEventTable (
            $studentEventColStudentId INTEGER NOT NULL,
            $studentEventColEventId INTEGER NOT NULL,
            $studentEventColProfessorId INTEGER,
            $studentEventColDate TEXT,
            $studentEventColTime TEXT,
            $studentEventColStatus TEXT,
            FOREIGN KEY ( $studentEventColStudentId ) REFERENCES $studentTable($studentColId),
            FOREIGN KEY ( $studentEventColEventId ) REFERENCES $eventTable($eventColId),
            PRIMARY KEY ( $studentEventColStudentId, $studentEventColEventId ),
            UNIQUE ( $studentEventColStudentId, $studentEventColEventId )
          )
          ''');
  }

  ////////////////////////////////////////////// Student Event Table //////////////////////////////////////////////


  ////////////////////////////////////////////// Student Semester Table //////////////////////////////////////////////

  static final studentSemesterColStudentId = 'studentId';
  static final studentSemesterColSemesterId = 'semesterId';

  void createStudentSemesterTable(Database db) async {
    await db.execute('''
          CREATE TABLE $studentSemesterTable (
            $studentSemesterColStudentId INTEGER NOT NULL,
            $studentSemesterColSemesterId INTEGER NOT NULL,
            FOREIGN KEY ( $studentSemesterColStudentId ) REFERENCES $studentTable($studentColId),
            FOREIGN KEY ( $studentSemesterColSemesterId ) REFERENCES $semesterTable($semesterColId),
            PRIMARY KEY ( $studentSemesterColStudentId, $studentSemesterColSemesterId),
            UNIQUE ( $studentSemesterColStudentId, $studentSemesterColSemesterId)
          )
          ''');
  }

  ////////////////////////////////////////////// Student Semester Table //////////////////////////////////////////////


  ////////////////////////////////////////////// Event Settings Table //////////////////////////////////////////////
  
  static final eventSettingsColEventId = 'eventId';
  static final eventSettingsColProfessorId = 'professorId';
  static final eventSettingsColNeedUpload = 'needUpload';
  static final eventSettingsColAutoComplete = 'autoComplete';
  static final eventSettingsColNotifications = 'notifications';
  
  Future<bool> createEventSettingsTable(Database db) async {
    await db.execute('''
          CREATE TABLE $eventSettingsTable (
            $eventSettingsColEventId INTEGER NOT NULL,
            $eventSettingsColProfessorId INTEGER NOT NULL,
            $eventSettingsColNeedUpload TEXT NOT NULL,
            $eventSettingsColAutoComplete TEXT NOT NULL,
            $eventSettingsColNotifications TEXT NOT NULL,
            FOREIGN KEY ( $eventSettingsColEventId ) REFERENCES $eventTable($eventColId),
            FOREIGN KEY ( $eventSettingsColProfessorId ) REFERENCES $professorTable($professorColId),
            PRIMARY KEY ( $eventSettingsColEventId, $eventSettingsColProfessorId),
            UNIQUE ( $eventSettingsColEventId, $eventSettingsColProfessorId)
          )
          ''');
    return true;
  }

  ////////////////////////////////////////////// Event Settings Table //////////////////////////////////////////////


  ////////////////////////////////////////////// Exams Table //////////////////////////////////////////////

  static final examsColId = 'examId';
  static final examsColCourseId = 'courseId';
  static final examsColDate = 'date';
  static final examsColTime = 'time';
  static final examsColRoom = 'room';
  static final examsColProfessorId = 'professorId';

  Future<bool> createExamsTable(Database db) async {
    await db.execute('''
          CREATE TABLE $examsTable (
            $examsColId INTEGER PRIMARY KEY,
            $examsColCourseId INTEGER NOT NULL,
            $examsColDate TEXT NOT NULL,
            $examsColTime TEXT NOT NULL,
            $examsColRoom TEXT NOT NULL,
            $examsColProfessorId INTEGER NOT NULL,
            UNIQUE ( $examsColId )
          )
          ''');
    return true;
  }

  ////////////////////////////////////////////// Exams Table //////////////////////////////////////////////


  ////////////////////////////////////////////// Student Exam Table //////////////////////////////////////////////

  static final studentExamColStudentId = 'studentId';
  static final studentExamColExamId = 'examId';
  static final studentExamColStatus = 'status';

  Future<bool> createStudentExamTable(Database db) async {
    await db.execute('''
          CREATE TABLE $studentExamTable (
            $studentExamColStudentId INTEGER NOT NULL,
            $studentExamColExamId INTEGER NOT NULL,
            $studentExamColStatus TEXT NOT NULL,
            FOREIGN KEY ( $studentExamColStudentId ) REFERENCES $studentTable($studentColId),
            FOREIGN KEY ( $studentExamColExamId ) REFERENCES $examsTable($examsColId),
            PRIMARY KEY ( $studentExamColStudentId, $studentExamColExamId),
            UNIQUE ( $studentExamColStudentId, $studentExamColExamId )
          )
          ''');
    return true;
  }

  ////////////////////////////////////////////// Student Exam Table //////////////////////////////////////////////


  ////////////////////////////////////////////// Temp FileUpload Table //////////////////////////////////////////////

  static final fileUploadColId = "fileId";
  static final fileUploadColEventId = 'eventId';
  static final fileUploadColStudentId = 'studentId';
  static final fileUploadColFileName = 'fileName';
  static final fileUploadColUploadTime = 'uploadTime';
  static final fileUploadColFileType = 'fileType';
  static final fileUploadColSize = 'size';

  Future<bool> createFileUploadTable(Database db) async {
    await db.execute('''
          CREATE TABLE $tempUploadedFileTable (
            $fileUploadColId INTEGER PRIMARY KEY,
            $fileUploadColEventId INTEGER NOT NULL,
            $fileUploadColStudentId INTEGER NOT NULL,
            $fileUploadColFileName TEXT NOT NULL,
            $fileUploadColUploadTime TEXT NOT NULL,
            $fileUploadColFileType TEXT NOT NULL,
            $fileUploadColSize INTEGER
          )
          ''');
    return true;
  }

  ////////////////////////////////////////////// Temp FileUpload Table //////////////////////////////////////////////

  // make this a singleton class
  DatabaseService._privateConstructor();

  static final DatabaseService instance = DatabaseService._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database tables
  Future _onCreate(Database db, int version) async {
    createStudentTable(db);
    createProfessorTable(db);
    createSemesterTable(db);
    createCourseTable(db);
    createEventTable(db);
    createStudentCourseTable(db);
    createStudentEventTable(db);
    createStudentSemesterTable(db);
    createEventSettingsTable(db);
    createExamsTable(db);
    createStudentExamTable(db);
    createFileUploadTable(db);

    Future.delayed(
        Duration(milliseconds: 250),
            () =>
                DummyData()
    );


    db.rawQuery("CREATE INDEX status ON $studentEventTable ($studentEventColStatus)");
    db.rawQuery("CREATE INDEX studentEvent ON $studentEventTable ($studentEventColStudentId)");
    db.rawQuery("CREATE INDEX event ON $studentEventTable ($studentEventColEventId)");
    db.rawQuery("CREATE INDEX semester ON $studentSemesterTable ($studentSemesterColSemesterId)");
    db.rawQuery("CREATE INDEX studentSem ON $studentSemesterTable ($studentSemesterColStudentId)");
    db.rawQuery("CREATE INDEX course ON $studentCourseTable ($studentCourseColCourseId)");
    db.rawQuery("CREATE INDEX studentCourse ON $studentCourseTable ($studentCourseColStudentId)");
  }

  // Helper methods

  insertProfessorData(dynamic jsonObject) {
    List<dynamic> studentList = jsonObject["studentList"];
    List<dynamic> semesterList = jsonObject["semesterList"];
    List<dynamic> courseList = jsonObject["courseList"];
    List<dynamic> eventList = jsonObject["eventList"];
    List<dynamic> studentCourseList = jsonObject["studentCourseList"];
    List<dynamic> studentEventList = jsonObject["studentEventList"];
    List<dynamic> examList = jsonObject["examList"];
    List<dynamic> studentExamList = jsonObject["studentExamList"];
    List<dynamic> eventSettingsList = jsonObject["eventSettingsList"];
    List<dynamic> fileUploadList = jsonObject["fileUploadList"];
    Batch batch = _database.batch();

    //TODO: Change to INSERT OR REPLACE

    studentList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[studentColId]);
      values.add(element[studentColFirstName]);
      values.add(element[studentColLastName]);
      values.add(element[studentColMatriculation]);
      values.add(element[studentColFhIdentifier]);
      print(values);
      batch.rawInsert("INSERT OR IGNORE INTO $studentTable ($studentColId, $studentColFirstName, $studentColLastName, $studentColMatriculation, $studentColFhIdentifier) VALUES (?, ?, ?, ?, ?)", values);
    });

    semesterList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[semesterColId]);
      values.add(element[semesterColName]);
      values.add(element[semesterColStartDate]?.split('.')?.reversed?.join('-'));
      values.add(element[semesterColEndDate]?.split('.')?.reversed?.join('-'));
      batch.rawInsert("INSERT OR IGNORE INTO $semesterTable ($semesterColId, $semesterColName, $semesterColStartDate, $semesterColEndDate) VALUES (?, ?, ?, ?)", values);
    });

    courseList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[courseColId]);
      values.add(element[courseColName]);
      values.add(element[courseColShortName]);
      values.add(element[courseColSemesterId]);
      values.add(element[courseColProfessorId]);
      batch.rawInsert("INSERT OR IGNORE INTO $courseTable ($courseColId, $courseColName, $courseColShortName, $courseColSemesterId, $courseColProfessorId) VALUES (?, ?, ?, ?, ?)", values);
    });

    eventList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[eventColId]);
      values.add(element[eventColDate]?.split('.')?.reversed?.join('-'));
      values.add(element[eventColName]);
      values.add(element[eventColRoom]);
      values.add(element[eventColTime]);
      values.add(element[eventColCourseId]);
      batch.rawInsert("INSERT OR IGNORE INTO $eventTable ($eventColId, $eventColDate, $eventColName, $eventColRoom, $eventColTime, $eventColCourseId) VALUES (?, ?, ?, ?, ?, ?)", values);
    });

    studentCourseList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[studentCourseColStudentId]);
      values.add(element[studentCourseColCourseId]);
      values.add(element[studentCourseColCompleted]);
      values.add(element[studentCourseColDate]?.split('.')?.reversed?.join('-'));
      values.add(element[studentCourseColTime]);
      values.add(element[studentCourseColProfessorId]);
      values.add(element[studentCourseColSemesterId]);
      batch.rawInsert("INSERT OR IGNORE INTO $studentCourseTable ($studentCourseColStudentId, $studentCourseColCourseId, $studentCourseColCompleted, $studentCourseColDate, $studentCourseColTime, $studentCourseColProfessorId, $studentCourseColSemesterId) VALUES (?, ?, ?, ?, ?, ?, ?)", values);
    });

    studentEventList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[studentEventColStudentId]);
      values.add(element[studentEventColEventId]);
      values.add(element[studentEventColProfessorId]);
      values.add(element[studentEventColDate]?.split('.')?.reversed?.join('-'));
      values.add(element[studentEventColTime]);
      values.add(element[studentEventColStatus]);
      batch.rawInsert("INSERT OR IGNORE INTO $studentEventTable ($studentEventColStudentId, $studentEventColEventId, $studentEventColProfessorId, $studentEventColDate, $studentEventColTime, $studentEventColStatus) VALUEs (?, ?, ?, ?, ?, ?)", values);
    });

    examList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[examsColId]);
      values.add(element[examsColCourseId]);
      values.add(element[examsColDate]?.split('.')?.reversed?.join('-'));
      values.add(element[examsColTime]);
      values.add(element[examsColRoom]);
      values.add(element[examsColProfessorId]);
      batch.rawInsert("INSERT OR IGNORE INTO $examsTable ($examsColId, $examsColCourseId, $examsColDate, $examsColTime, $examsColRoom, $examsColProfessorId) VALUES (?, ?, ?, ?, ?, ?)", values);
    });

    studentExamList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[studentExamColStudentId]);
      values.add(element[studentExamColExamId]);
      values.add(element[studentExamColStatus]);
      batch.rawInsert("INSERT OR IGNORE INTO $studentExamTable ($studentExamColStudentId, $studentExamColExamId, $studentExamColStatus) VALUES (?, ?, ?)", values);
    });

    eventSettingsList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[eventSettingsColEventId]);
      values.add(element[eventSettingsColProfessorId]);
      values.add(element[eventSettingsColNeedUpload]);
      values.add(element[eventSettingsColAutoComplete]);
      values.add(element[eventSettingsColNotifications]);
      batch.rawInsert("INSERT OR IGNORE INTO $eventSettingsTable ($eventSettingsColEventId, $eventSettingsColProfessorId, $eventSettingsColNeedUpload, $eventSettingsColAutoComplete, $eventSettingsColNotifications) VALUES (?, ?, ?, ?, ?)", values);
    });

    fileUploadList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[fileUploadColId]);
      values.add(element[fileUploadColEventId]);
      values.add(element[fileUploadColStudentId]);
      values.add(element[fileUploadColFileName]);
      values.add(element[fileUploadColUploadTime]);
      values.add(element[fileUploadColFileType]);
      values.add(element[fileUploadColSize]);
      batch.rawInsert("INSERT OR IGNORE INTO $tempUploadedFileTable ($fileUploadColId, $fileUploadColEventId, $fileUploadColStudentId, $fileUploadColFileName, $fileUploadColUploadTime, $fileUploadColFileType, $fileUploadColSize) VALUES (?, ?, ?, ?, ?, ?, ?)", values);
    });

    batch.commit();
  }

  insertStudentData(dynamic jsonObject) {
    List<dynamic> professorList = jsonObject["professorList"];
    List<dynamic> semesterList = jsonObject["semesterList"];
    List<dynamic> courseList = jsonObject["courseList"];
    List<dynamic> eventList = jsonObject["eventList"];
    List<dynamic> studentCourseList = jsonObject["studentCourseList"];
    List<dynamic> studentEventList = jsonObject["studentEventList"];
    List<dynamic> studentSemesterList = jsonObject["studentSemesterList"];
    List<dynamic> examList = jsonObject["examList"];
    List<dynamic> studentExamList = jsonObject["studentExamList"];
    List<dynamic> fileUploadList = jsonObject["fileUploadList"];
    List<dynamic> eventSettingsList = jsonObject["eventSettingsList"];
    print(eventSettingsList);
    Batch batch = _database.batch();

    //TODO: Change to INSERT OR REPLACE

    professorList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[professorColId]);
      values.add(element[professorColFirstName]);
      values.add(element[professorColLastName]);
      values.add(element[professorColTitle]);
      batch.rawInsert("INSERT OR IGNORE INTO $professorTable ($professorColId, $professorColFirstName, $professorColLastName, $professorColTitle) VALUES (?, ?, ?, ?)", values);
    });

    semesterList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[semesterColId]);
      values.add(element[semesterColName]);
      values.add(element[semesterColStartDate]?.split('.')?.reversed?.join('-'));
      values.add(element[semesterColEndDate]?.split('.')?.reversed?.join('-'));
      batch.rawInsert("INSERT OR IGNORE INTO $semesterTable ($semesterColId, $semesterColName, $semesterColStartDate, $semesterColEndDate) VALUES (?, ?, ?, ?)", values);
    });

    courseList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[courseColId]);
      values.add(element[courseColName]);
      values.add(element[courseColShortName]);
      values.add(element[courseColSemesterId]);
      values.add(element[courseColProfessorId]);
      batch.rawInsert("INSERT OR IGNORE INTO $courseTable ($courseColId, $courseColName, $courseColShortName, $courseColSemesterId, $courseColProfessorId) VALUES (?, ?, ?, ?, ?)", values);
    });

    eventList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[eventColId]);
      values.add(element[eventColDate]?.split('.')?.reversed?.join('-'));
      values.add(element[eventColName]);
      values.add(element[eventColRoom]);
      values.add(element[eventColTime]);
      values.add(element[eventColCourseId]);
      batch.rawInsert("INSERT OR IGNORE INTO $eventTable ($eventColId, $eventColDate, $eventColName, $eventColRoom, $eventColTime, $eventColCourseId) VALUES (?, ?, ?, ?, ?, ?)", values);
    });

    studentCourseList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[studentCourseColStudentId]);
      values.add(element[studentCourseColCourseId]);
      values.add(element[studentCourseColCompleted]);
      values.add(element[studentCourseColDate]?.split('.')?.reversed?.join('-'));
      values.add(element[studentCourseColTime]);
      values.add(element[studentCourseColProfessorId]);
      values.add(element[studentCourseColSemesterId]);
      batch.rawInsert("INSERT OR IGNORE INTO $studentCourseTable ($studentCourseColStudentId, $studentCourseColCourseId, $studentCourseColCompleted, $studentCourseColDate, $studentCourseColTime, $studentCourseColProfessorId, $studentCourseColSemesterId) VALUES (?, ?, ?, ?, ?, ?, ?)", values);
    });

    studentEventList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[studentEventColStudentId]);
      values.add(element[studentEventColEventId]);
      values.add(element[studentEventColProfessorId]);
      values.add(element[studentEventColDate]?.split('.')?.reversed?.join('-'));
      values.add(element[studentEventColTime]);
      values.add(element[studentEventColStatus]);
      batch.rawInsert("INSERT OR IGNORE INTO $studentEventTable ($studentEventColStudentId, $studentEventColEventId, $studentEventColProfessorId, $studentEventColDate, $studentEventColTime, $studentEventColStatus) VALUEs (?, ?, ?, ?, ?, ?)", values);
    });

    studentSemesterList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[studentSemesterColStudentId]);
      values.add(element[studentSemesterColSemesterId]);
      batch.rawInsert("INSERT OR IGNORE INTO $studentSemesterTable ($studentSemesterColStudentId, $studentSemesterColSemesterId) VALUES (?, ?)", values);
    });

    examList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[examsColId]);
      values.add(element[examsColCourseId]);
      values.add(element[examsColDate]?.split('.')?.reversed?.join('-'));
      values.add(element[examsColTime]);
      values.add(element[examsColRoom]);
      values.add(element[examsColProfessorId]);
      batch.rawInsert("INSERT OR IGNORE INTO $examsTable ($examsColId, $examsColCourseId, $examsColDate, $examsColTime, $examsColRoom, $examsColProfessorId) VALUES (?, ?, ?, ?, ?, ?)", values);
    });

    studentExamList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[studentExamColStudentId]);
      values.add(element[studentExamColExamId]);
      values.add(element[studentExamColStatus]);
      batch.rawInsert("INSERT OR IGNORE INTO $studentExamTable ($studentExamColStudentId, $studentExamColExamId, $studentExamColStatus) VALUES (?, ?, ?)", values);
    });

    fileUploadList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[fileUploadColId]);
      values.add(element[fileUploadColEventId]);
      values.add(element[fileUploadColStudentId]);
      values.add(element[fileUploadColFileName]);
      values.add(element[fileUploadColUploadTime]);
      values.add(element[fileUploadColFileType]);
      values.add(element[fileUploadColSize]);
      batch.rawInsert("INSERT OR IGNORE INTO $tempUploadedFileTable ($fileUploadColId, $fileUploadColEventId, $fileUploadColStudentId, $fileUploadColFileName, $fileUploadColUploadTime, $fileUploadColFileType, $fileUploadColSize) VALUES (?, ?, ?, ?, ?, ?, ?)", values);
    });

    eventSettingsList.forEach((element) {
      element = jsonDecode(element);
      List<dynamic> values = [];
      values.add(element[eventSettingsColEventId]);
      values.add(element[eventSettingsColProfessorId]);
      values.add(element[eventSettingsColNeedUpload]);
      values.add(element[eventSettingsColAutoComplete]);
      values.add(element[eventSettingsColNotifications]);
      batch.rawInsert("INSERT OR IGNORE INTO $eventSettingsTable ($eventSettingsColEventId, $eventSettingsColProfessorId, $eventSettingsColNeedUpload, $eventSettingsColAutoComplete, $eventSettingsColNotifications) VALUES (?, ?, ?, ?, ?)", values);
    });

    batch.commit();
  }

  ////////////////////////////////////////////// Student Methods //////////////////////////////////////////////

  // Inserts a student object in the database. The return value is the id of the
  // inserted row.
  Future<int> insertStudent(StudentObject student) async {
    Database db = await instance.database;
    if(getStudentByMatriculation(student.matriculation) != null) {
      return await db.insert(studentTable, student.toMap());
    }
    return null;
  }

  // Gets a student object from the database by id. The return value is the student object
  // belonging to the id or null if no student object with that id exists in the database
  Future<StudentObject> getStudentById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(studentTable, where: '$studentColId = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return new StudentObject.fromMapObject(results.first);
    }

    return null;
  }

  // Gets a student object from the database by id. The return value is the student object
  // belonging to the id or null if no student object with that id exists in the database
  Future<StudentObject> getStudentByMatriculation(int matriculation) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(studentTable, where: '$studentColMatriculation = ?', whereArgs: [matriculation]);

    if (results.isNotEmpty) {
      return new StudentObject.fromMapObject(results.first);
    }

    return null;
  }

  // All of the rows are returned as a list, where each list element
  // is a student object
  Future<List<StudentObject>> getAllStudents() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> students = await db.query(studentTable);
    List<StudentObject> studentList = [];

    for (Map<String, dynamic> student in students) {
      studentList.add(StudentObject.fromMapObject(student));
    }

    return studentList;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryStudentRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $studentTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateStudent(StudentObject student) async {
    Database db = await instance.database;
    return await db.update(studentTable, student.toMap(),
        where: '$studentColId = ?', whereArgs: [student.id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteStudent(int id) async {
    Database db = await instance.database;
    return await db
        .delete(studentTable, where: '$studentColId = ?', whereArgs: [id]);
  }

  ////////////////////////////////////////////// Student Methods //////////////////////////////////////////////


  ////////////////////////////////////////////// Course Methods //////////////////////////////////////////////

  // Inserts a course object in the database. The return value is the id of the
  // inserted row.
  Future<int> insertCourse(CourseObject course) async {
    Database db = await instance.database;
    return await db.insert(courseTable, course.toMap());
  }

  // Gets a course object from the database by id. The return value is the course object
  // belonging to the id or null if no course object with that id exists in the database
  Future<CourseObject> getCourseById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(courseTable, where: '$courseColId = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return CourseObject.fromMapObject(results.first);
    }

    return null;
  }

  // All of the rows are returned as a list, where each list element
  // is a course object
  Future<List<CourseObject>> getAllCourses() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> courses = await db.query(courseTable);
    List<CourseObject> courseList = [];

    for (Map<String, dynamic> course in courses) {
      courseList.add(CourseObject.fromMapObject(course));
    }

    return courseList;
  }

  // All of the courses belonging to one professor are returned as a list, where
  // each list element is a course object
  Future<List<CourseObject>> getAllCoursesOfProfessor(int profId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> courses = await db.query(courseTable, where: '$courseColProfessorId = ?', whereArgs: [profId]);
    List<CourseObject> courseList = [];

    for (Map<String, dynamic> course in courses) {
      courseList.add(CourseObject.fromMapObject(course));
    }

    return courseList;
  }

  Future<Map<CourseObject, Map<EventObject, Tuple2<int,int>>>> getAllCoursesAndEventsOfProfessor(int professorId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.rawQuery("SELECT $eventTable.*, $eventTable.$eventColName AS eventName, $courseTable.*, requests, participants FROM $eventTable INNER JOIN $courseTable ON ($courseTable.$courseColId = $eventTable.$eventColCourseId) INNER JOIN (SELECT COUNT(*) AS participants, sum($studentEventTable.$studentEventColStatus = 'waiting') AS requests, $studentEventTable.$studentEventColEventId FROM $studentEventTable GROUP BY $studentEventTable.$studentEventColEventId) $studentEventTable ON ($studentEventTable.$studentEventColEventId = $eventTable.$eventColId) WHERE $courseTable.$courseColProfessorId = $professorId");
    Map<CourseObject, Map<EventObject, Tuple2<int, int>>> eventStatusMap = LinkedHashMap();
    results.forEach((element) {
      EventObject event = EventObject.fromMapObject(element);
      event.name = element["eventName"];
      CourseObject course = CourseObject.fromMapObject(element);
      Map<EventObject, Tuple2<int, int>> eventMap = LinkedHashMap();
      eventMap.putIfAbsent(event, () => Tuple2<int, int>(element['requests'], element['participants']));
      eventStatusMap.putIfAbsent(course, () => eventMap);
    });

    return eventStatusMap;
  }

  Future<Map<StudentObject, String>> getAllStudentsOfEvent(int eventId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.rawQuery("SELECT $studentTable.*, $studentEventTable.$studentEventColStatus FROM $studentTable INNER JOIN (SELECT $studentEventTable.$studentEventColStudentId, $studentEventTable.$studentEventColEventId, $studentEventTable.$studentEventColStatus FROM $studentEventTable WHERE $studentEventTable.$studentEventColEventId = $eventId GROUP BY $studentEventTable.$studentEventColStudentId) $studentEventTable ON ($studentEventTable.$studentEventColStudentId = $studentTable.$studentColId) ");
    Map<StudentObject, String> studentMap = LinkedHashMap();
    results.forEach((element) {
      StudentObject student = StudentObject.fromMapObject(element);
      studentMap.putIfAbsent(student, () => element['status']);
    });

    return studentMap;
  }

  // All of the courses belonging to one professor and one semester are returned
  // as a list, where each list element is a course object
  Future<List<CourseObject>> getAllCoursesOfProfAndSemester(
      int profId, int semesterId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> courses = await db.query(courseTable,
        where: '$courseColProfessorId = ? AND $courseColSemesterId = ?',
        whereArgs: [profId, semesterId]);
    List<CourseObject> courseList = [];

    for (Map<String, dynamic> course in courses) {
      courseList.add(CourseObject.fromMapObject(course));
    }

    return courseList;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryCourseRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $courseTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateCourse(CourseObject course) async {
    Database db = await instance.database;
    return await db.update(courseTable, course.toMap(),
        where: '$courseColId = ?', whereArgs: [course.id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteCourse(int id) async {
    Database db = await instance.database;
    return await db
        .delete(courseTable, where: '$courseColId = ?', whereArgs: [id]);
  }

  ////////////////////////////////////////////// Course Methods //////////////////////////////////////////////


  ////////////////////////////////////////////// Event Methods //////////////////////////////////////////////

  // Inserts an event object in the database. The return value is the id of the
  // inserted row.
  Future<int> insertEvent(EventObject event) async {
    Database db = await instance.database;
    return await db.insert(eventTable, event.toMap());
  }

  // Gets an event object from the database by id. The return value is the event object
  // belonging to the id or null if no event object with that id exists in the database
  Future<EventObject> getEventById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(eventTable, where: '$eventColId = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return EventObject.fromMapObject(results.first);
    }

    return null;
  }

  // All of the rows are returned as a list, where each list element
  // is an event object
  Future<List<EventObject>> getAllEvents() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> events = await db.query(eventTable);
    List<EventObject> eventList = [];

    for (Map<String, dynamic> event in events) {
      eventList.add(EventObject.fromMapObject(event));
    }

    return eventList;
  }

  // All of the events belonging to one course are returned as a list, where
  // each list element is an event object
  Future<List<EventObject>> getAllEventsOfCourse(int courseId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> events = await db.query(eventTable, where: '$eventColCourseId = ?', whereArgs: [courseId], orderBy: '$eventColDate DESC');
    List<EventObject> eventList = [];

    for (Map<String, dynamic> event in events) {
      eventList.add(EventObject.fromMapObject(event));
    }

    return eventList;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryEventRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $eventTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateEvent(EventObject event) async {
    Database db = await instance.database;
    return await db.update(eventTable, event.toMap(),
        where: '$eventColId = ?', whereArgs: [event.id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteEvent(int id) async {
    Database db = await instance.database;
    return await db
        .delete(eventTable, where: '$eventColId = ?', whereArgs: [id]);
  }

  ////////////////////////////////////////////// Event Methods //////////////////////////////////////////////


  ////////////////////////////////////////////// Professor Methods //////////////////////////////////////////////

  // Inserts a professor object in the database. The return value is the id of the
  // inserted row.
  Future<int> insertProfessor(ProfessorObject professor) async {
    Database db = await instance.database;
    return await db.insert(professorTable, professor.toMap());
  }

  // Gets a professor object from the database by id. The return value is the professor object
  // belonging to the id or null if no professor object with that id exists in the database
  Future<ProfessorObject> getProfessorById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(professorTable, where: '$professorColId = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return ProfessorObject.fromMapObject(results.first);
    }

    return null;
  }

  // All of the rows are returned as a list, where each list element
  // is a professor object
  Future<List<ProfessorObject>> getAllProfessors() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> professors = await db.query(professorTable);
    List<ProfessorObject> professorList = [];

    for (Map<String, dynamic> professor in professors) {
      professorList.add(ProfessorObject.fromMapObject(professor));
    }

    return professorList;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryProfessorRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $professorTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateProfessor(ProfessorObject professor) async {
    Database db = await instance.database;
    return await db.update(professorTable, professor.toMap(),
        where: '$professorColId = ?', whereArgs: [professor.id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteProfessor(int id) async {
    Database db = await instance.database;
    return await db
        .delete(professorTable, where: '$professorColId = ?', whereArgs: [id]);
  }

  ////////////////////////////////////////////// Professor Methods //////////////////////////////////////////////


  ////////////////////////////////////////////// Semester Methods //////////////////////////////////////////////

  // Inserts a semester object in the database. The return value is the id of the
  // inserted row.
  Future<int> insertSemester(SemesterObject semester) async {
    Database db = await instance.database;
    return await db.insert(semesterTable, semester.toMap());
  }

  // Gets a semester object from the database by id. The return value is the semester object
  // belonging to the id or null if no semester object with that id exists in the database
  Future<SemesterObject> getSemesterById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(semesterTable, where: '$semesterColId = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return SemesterObject.fromMapObject(results.first);
    }

    return null;
  }

  // All of the rows are returned as a list, where each list element
  // is a student object
  Future<List<SemesterObject>> getAllSemester() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> semesters = await db.query(semesterTable);
    List<SemesterObject> semesterList = [];

    for (Map<String, dynamic> semester in semesters) {
      semesterList.add(SemesterObject.fromMapObject(semester));
    }

    return semesterList;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> querySemesterRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $semesterTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateSemester(SemesterObject semester) async {
    Database db = await instance.database;
    return await db.update(semesterTable, semester.toMap(),
        where: '$semesterColId = ?', whereArgs: [semester.id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteSemester(int id) async {
    Database db = await instance.database;
    return await db
        .delete(semesterTable, where: '$semesterColId = ?', whereArgs: [id]);
  }

  ////////////////////////////////////////////// Semester Methods //////////////////////////////////////////////


  ////////////////////////////////////////////// Student Course Methods //////////////////////////////////////////////

  // Inserts a studentCourse object in the database. The return value is the id of the
  // inserted row.
  Future<int> insertStudentCourse(StudentCourseObject studentCourse) async {
    Database db = await instance.database;
    return await db.insert(studentCourseTable, studentCourse.toMap());
  }

  // Gets a studentCourse object from the database by id. The return value is the studentCourse object
  // belonging to the id or null if no studentCourse object with that id exists in the database
  Future<StudentCourseObject> getStudentCourseById(int studentId, int courseId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(studentCourseTable, where: '$studentCourseColStudentId = ? AND $studentCourseColCourseId', whereArgs: [studentId, courseId]);

    if (results.isNotEmpty) {
      return StudentCourseObject.fromMapObject(results.first);
    }

    return null;
  }

  // All of the rows are returned as a list, where each list element
  // is a studentCourse object
  Future<List<StudentCourseObject>> getAllStudentCourses() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentCourses = await db.query(studentCourseTable);
    List<StudentCourseObject> studentCourseList = [];

    for (Map<String, dynamic> studentCourse in studentCourses) {
      studentCourseList.add(StudentCourseObject.fromMapObject(studentCourse));
    }

    return studentCourseList;
  }

  // All of the rows for a specific student are returned as a list, where each list element
  // is a studentCourse object
  Future<List<StudentCourseObject>> getAllStudentCoursesOfStudent(int studentId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentCourses = await db.query(studentCourseTable, where: '$studentCourseColStudentId = ?', whereArgs: [studentId]);
    List<StudentCourseObject> studentCourseList = [];

    for (Map<String, dynamic> studentCourse in studentCourses) {
      studentCourseList.add(StudentCourseObject.fromMapObject(studentCourse));
    }

    return studentCourseList;
  }

  // All of the rows for a specific course are returned as a list, where each list element
  // is a studentCourse object
  Future<List<StudentCourseObject>> getAllStudentCoursesOfCourse(int courseId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentCourses = await db.query(studentCourseTable, where: '$studentCourseColCourseId = ?', whereArgs: [courseId]);
    List<StudentCourseObject> studentCourseList = [];

    for (Map<String, dynamic> studentCourse in studentCourses) {
      studentCourseList.add(StudentCourseObject.fromMapObject(studentCourse));
    }

    return studentCourseList;
  }

  // All of the rows for a specific professor are returned as a list, where each list element
  // is a studentCourse object
  Future<List<StudentCourseObject>> getAllStudentCoursesOfProf(int professorId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentCourses = await db.query(studentCourseTable, where: '$studentCourseColProfessorId = ?', whereArgs: [professorId]);
    List<StudentCourseObject> studentCourseList = [];

    for (Map<String, dynamic> studentCourse in studentCourses) {
      studentCourseList.add(StudentCourseObject.fromMapObject(studentCourse));
    }

    return studentCourseList;
  }

  // All of the rows for a specific student and semester are returned as a list, where each list element
  // is a studentCourse object
  Future<List<StudentCourseObject>> getAllStudentCoursesOfStudentSemester(int studentId, int semesterId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentCourses = await db.query(studentCourseTable, where: '$studentCourseColStudentId = ? AND $studentCourseColSemesterId = ?', whereArgs: [studentId, semesterId]);
    List<StudentCourseObject> studentCourseList = [];

    for (Map<String, dynamic> studentCourse in studentCourses) {
      studentCourseList.add(StudentCourseObject.fromMapObject(studentCourse));
    }

    return studentCourseList;
  }

  // All of the rows for a specific student that are completed are returned as a list, where each list element
  // is a studentCourse object
  Future<List<StudentCourseObject>> getAllCompletedStudentCoursesOfStudent(int studentId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentCourses = await db.query(studentCourseTable, where: '$studentCourseColStudentId = ? AND $studentCourseColCompleted = ?', whereArgs: [studentId, 'true'], orderBy: "$studentCourseColDate ASC");
    List<StudentCourseObject> studentCourseList = [];

    for (Map<String, dynamic> studentCourse in studentCourses) {
      studentCourseList.add(StudentCourseObject.fromMapObject(studentCourse));
    }

    return studentCourseList;
  }

  // All of the rows for a specific student that are completed are returned as a list, where each list element
  // is a studentCourse object
  Future<List<StudentCourseObject>> getAllCompletedStudentCoursesOfStudentSemester(int studentId, semesterId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentCourses = await db.query(studentCourseTable, where: '$studentCourseColStudentId = ? AND $studentCourseColSemesterId = ? AND $studentCourseColCompleted = ?', whereArgs: [studentId, semesterId, 'true']);
    List<StudentCourseObject> studentCourseList = [];

    for (Map<String, dynamic> studentCourse in studentCourses) {
      studentCourseList.add(StudentCourseObject.fromMapObject(studentCourse));
    }

    return studentCourseList;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryStudentCourseRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $studentCourseTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateStudentCourse(StudentCourseObject studentCourse) async {
    Database db = await instance.database;
    return await db.update(studentCourseTable, studentCourse.toMap(),
        where: '$studentCourseColStudentId = ? AND $studentCourseColCourseId = ?', whereArgs: [studentCourse.studentId, studentCourse.courseId]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteStudentCourse(int studentId, int courseId) async {
    Database db = await instance.database;
    return await db
        .delete(studentCourseTable, where: '$studentCourseColStudentId = ? AND $studentCourseColCourseId', whereArgs: [studentId, courseId]);
  }

  ////////////////////////////////////////////// Student Course Methods //////////////////////////////////////////////


  ////////////////////////////////////////////// Student Event Methods //////////////////////////////////////////////

  // Inserts a studentEvent object in the database. The return value is the id of the
  // inserted row.
  Future<int> insertStudentEvent(StudentEventObject studentEvent) async {
    Database db = await instance.database;
    return await db.insert(studentEventTable, studentEvent.toMap());
  }

  // Gets a studentEvent object from the database by id. The return value is the studentEvent object
  // belonging to the id or null if no studentEvent object with that id exists in the database
  Future<StudentEventObject> getStudentEventById(int studentId, int eventId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(studentEventTable, where: '$studentEventColStudentId = ? AND $studentEventColEventId = ?', whereArgs: [studentId, eventId]);

    if (results.isNotEmpty) {
      return StudentEventObject.fromMapObject(results.first);
    }

    return null;
  }

  // All of the rows are returned as a list, where each list element
  // is a studentEvent object
  Future<List<StudentEventObject>> getAllStudentEvents() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentEvents = await db.query(studentEventTable);
    List<StudentEventObject> studentEventList = [];

    for (Map<String, dynamic> studentEvent in studentEvents) {
      studentEventList.add(StudentEventObject.fromMapObject(studentEvent));
    }

    return studentEventList;
  }

  // All of the rows for a specific student are returned as a list, where each list element
  // is a studentEvent object
  Future<List<StudentEventObject>> getAllStudentEventsOfStudent(int studentId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentEvents = await db.query(studentEventTable, where: '$studentEventColStudentId = ?', whereArgs: [studentId]);
    List<StudentEventObject> studentEventList = [];

    for (Map<String, dynamic> studentEvent in studentEvents) {
      studentEventList.add(StudentEventObject.fromMapObject(studentEvent));
    }

    return studentEventList;
  }

  Future<List<StudentEventObject>> getAllCompletedStudentEventsOfStudent(int studentId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentEvents = await db.query(studentEventTable, where: '$studentEventColStudentId = ? AND $studentEventColStatus = ?', whereArgs:  [studentId, "completed"]);
    List<StudentEventObject> studentEventList = [];

    for(Map<String, dynamic> studentEvent in studentEvents) {
      studentEventList.add(StudentEventObject.fromMapObject(studentEvent));
    }

    return studentEventList;
  }

  // All of the rows for a specific event are returned as a list, where each list element
  // is a studentEvent object
  Future<List<StudentEventObject>> getAllStudentEventsOfEvent(int eventId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentEvents = await db.query(studentEventTable, where: '$studentEventColEventId = ?', whereArgs: [eventId]);
    List<StudentEventObject> studentEventList = [];

    for (Map<String, dynamic> studentEvent in studentEvents) {
      studentEventList.add(StudentEventObject.fromMapObject(studentEvent));
    }

    return studentEventList;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryStudentEventRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $studentEventTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateStudentEvent(StudentEventObject studentEvent) async {
    Database db = await instance.database;
    return await db.update(studentEventTable, studentEvent.toMap(),
        where: '$studentEventColStudentId = ? AND $studentEventColEventId = ?', whereArgs: [studentEvent.studentId, studentEvent.eventId]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteStudentEvent(int studentId, eventId) async {
    Database db = await instance.database;
    return await db
        .delete(studentEventTable, where: '$studentEventColStudentId = ? AND $studentEventColEventId = ?', whereArgs: [studentId, eventId]);
  }
  ////////////////////////////////////////////// Student Event Methods //////////////////////////////////////////////


  ////////////////////////////////////////////// Student Semester Methods //////////////////////////////////////////////

  // Inserts a studentSemester object in the database. The return value is the id of the
  // inserted row.
  Future<int> insertStudentSemester(StudentSemesterObject studentSemester) async {
    Database db = await instance.database;
    return await db.insert(studentSemesterTable, studentSemester.toMap());
  }

  // Gets a studentSemester object from the database by id. The return value is the studentSemester object
  // belonging to the id or null if no studentSemester object with that id exists in the database
  Future<StudentSemesterObject> getStudentSemesterById(int studentId, int semesterId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(studentSemesterTable, where: '$studentSemesterColStudentId = ? AND $studentSemesterColSemesterId', whereArgs: [studentId, semesterId]);

    if (results.isNotEmpty) {
      return StudentSemesterObject.fromMapObject(results.first);
    }

    return null;
  }

  // All of the rows are returned as a list, where each list element
  // is a studentSemester object
  Future<List<StudentSemesterObject>> getAllStudentSemesters() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentSemesters = await db.query(studentSemesterTable);
    List<StudentSemesterObject> studentSemesterList = [];

    for (Map<String, dynamic> studentSemester in studentSemesters) {
      studentSemesterList.add(StudentSemesterObject.fromMapObject(studentSemester));
    }

    return studentSemesterList;
  }

  // All of the rows for a specific student are returned as a list, where each list element
  // is a studentSemester object
  Future<List<int>> getAllStudentSemesterIdsOfStudent(int studentId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentSemesters = await db.query(studentSemesterTable, columns: [studentSemesterColSemesterId], where: '$studentSemesterColStudentId = ?', whereArgs: [studentId], orderBy: "$studentSemesterColSemesterId ASC");
    List<int> studentSemesterList = [];
    studentSemesters.forEach((element) {
      studentSemesterList.add(element.values.first);
    });

    return studentSemesterList;
  }

  // All of the rows for a specific semester are returned as a list, where each list element
  // is a studentSemester object
  Future<List<StudentSemesterObject>> getAllStudentSemestersOfSemester(int semesterId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> studentSemesters = await db.query(studentSemesterTable, where: '$studentSemesterColSemesterId = ?', whereArgs:  [semesterId]);
    List<StudentSemesterObject> studentSemesterList = [];

    for (Map<String, dynamic> studentSemester in studentSemesters) {
      studentSemesterList.add(StudentSemesterObject.fromMapObject(studentSemester));
    }

    return studentSemesterList;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryStudentSemesterRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $studentSemesterTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateStudentSemester(StudentSemesterObject studentSemester) async {
    Database db = await instance.database;
    return await db.update(studentSemesterTable, studentSemester.toMap(),
        where: '$studentSemesterColStudentId = ? AND $studentSemesterColSemesterId = ?', whereArgs: [studentSemester.studentId, studentSemester.semesterId]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteStudentSemester(int studentId, int semesterId) async {
    Database db = await instance.database;
    return await db
        .delete(studentSemesterTable, where: '$studentSemesterColStudentId = ? AND $studentSemesterColSemesterId = ?', whereArgs: [studentId, semesterId]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteStudentSemesterStudentId(int id) async {
    Database db = await instance.database;
    return await db
        .delete(studentSemesterTable, where: '$studentSemesterColStudentId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteStudentSemesterSemesterId(int id) async {
    Database db = await instance.database;
    return await db
        .delete(studentSemesterTable, where: '$studentSemesterColSemesterId = ?', whereArgs: [id]);
  }

  ////////////////////////////////////////////// Student Semester Methods //////////////////////////////////////////////


  ////////////////////////////////////////////// Event Settings Methods //////////////////////////////////////////////

  // Inserts a eventSettings object in the database. The return value is the id of the
  // inserted row.
  Future<int> insertEventSettings(EventSettingsObject eventSettings) async {
    Database db = await instance.database;
    return await db.insert(eventSettingsTable, eventSettings.toMap());
  }

  // Gets a eventSettings object from the database by id. The return value is the eventSettings object
  // belonging to the id or null if no eventSettings object with that id exists in the database
  Future<EventSettingsObject> getEventSettingsById(int eventId, int professorId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(eventSettingsTable, where: '$eventSettingsColEventId = ? AND $eventSettingsColProfessorId = ?', whereArgs: [eventId, professorId]);

    if (results.isNotEmpty) {
      return EventSettingsObject.fromMapObject(results.first);
    }

    return null;
  }

  // All of the rows are returned as a list, where each list element
  // is an eventSettings object
  Future<List<EventSettingsObject>> getAllEventSettings() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> eventSettings = await db.query(eventSettingsTable);
    List<EventSettingsObject> eventSettingsList = [];

    for (Map<String, dynamic> eventSetting in eventSettings) {
      eventSettingsList.add(EventSettingsObject.fromMapObject(eventSetting));
    }

    return eventSettingsList;
  }

  // All of the rows for a specific event are returned as a list, where each list element
  // is an eventSettings object
  Future<List<EventSettingsObject>> getAllEventSettingsOfEvent(int eventId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> results = await db.query(eventSettingsTable, where: '$eventSettingsColEventId = ?', whereArgs: [eventId],);
    List<EventSettingsObject> eventSettingsList = [];
    results.forEach((element) {
      eventSettingsList.add(EventSettingsObject.fromMapObject(element));
    });

    return eventSettingsList;
  }

  // All of the rows for a specific professor are returned as a list, where each list element
  // is an eventSettings object
  Future<List<EventSettingsObject>> getAllEventSettingsOfProfessor(int professorId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> results = await db.query(eventSettingsTable, where: '$eventSettingsColProfessorId = ?', whereArgs:  [professorId]);
    List<EventSettingsObject> eventSettingsList = [];

    for (Map<String, dynamic> eventSettings in results) {
      eventSettingsList.add(EventSettingsObject.fromMapObject(eventSettings));
    }

    return eventSettingsList;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryEventSettingsRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $eventSettingsTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateEventSettings(EventSettingsObject eventSettings) async {
    Database db = await instance.database;
    return await db.update(eventSettingsTable, eventSettings.toMap(),
        where: '$eventSettingsColEventId = ? AND $eventSettingsColProfessorId = ?', whereArgs: [eventSettings.eventId, eventSettings.professorId]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteEventSettings(int eventId, int professorId) async {
    Database db = await instance.database;
    return await db
        .delete(eventSettingsTable, where: '$eventSettingsColEventId = ? AND $eventSettingsColProfessorId = ?', whereArgs: [eventId, professorId]);
  }

  // Deletes the rows specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteEventSettingsEventId(int id) async {
    Database db = await instance.database;
    return await db
        .delete(eventSettingsTable, where: '$eventSettingsColEventId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteEventSettingsProfessorId(int id) async {
    Database db = await instance.database;
    return await db
        .delete(eventSettingsTable, where: '$eventSettingsColProfessorId = ?', whereArgs: [id]);
  }

  ////////////////////////////////////////////// Event Settings Methods //////////////////////////////////////////////


  ////////////////////////////////////////////// Exam Methods //////////////////////////////////////////////

  // Inserts an exam object in the database. The return value is the id of the
  // inserted row.
  Future<int> insertExam(ExamObject exam) async {
    Database db = await instance.database;
    return await db.insert(examsTable, exam.toMap());
  }

  // Gets an exam object from the database by id. The return value is the exam object
  // belonging to the id or null if no exam object with that id exists in the database
  Future<ExamObject> getExamById(int examId,) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(examsTable, where: '$examsColId = ?', whereArgs: [examId]);

    if (results.isNotEmpty) {
      return ExamObject.fromMapObject(results.first);
    }

    return null;
  }

  // All of the rows are returned as a list, where each list element
  // is an exam object
  Future<List<ExamObject>> getAllExams() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> results = await db.query(examsTable);
    List<ExamObject> examList = [];

    for (Map<String, dynamic> result in results) {
      examList.add(ExamObject.fromMapObject(result));
    }

    return examList;
  }

  // All of the rows for a specific course are returned as a list, where each list element
  // is an exam object
  Future<List<ExamObject>> getAllExamsOfCourse(int courseId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> results = await db.query(examsTable, where: '$examsColCourseId = ?', whereArgs: [courseId],);
    List<ExamObject> examList = [];
    results.forEach((element) {
      examList.add(ExamObject.fromMapObject(element));
    });

    return examList;
  }

  // All of the rows for a specific professor are returned as a list, where each list element
  // is an exam object
  Future<List<ExamObject>> getAllExamsOfProfessor(int professorId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> results = await db.query(examsTable, where: '$examsColProfessorId = ?', whereArgs:  [professorId]);
    List<ExamObject> examList = [];

    for (Map<String, dynamic> exam in results) {
      examList.add(ExamObject.fromMapObject(exam));
    }

    return examList;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryExamRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $examsTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateExam(ExamObject exam) async {
    Database db = await instance.database;
    return await db.update(examsTable, exam.toMap(),
        where: '$examsColId = ?', whereArgs: [exam.examId]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteExam(int examId) async {
    Database db = await instance.database;
    return await db
        .delete(examsTable, where: '$examsColId = ?', whereArgs: [examId]);
  }

  ////////////////////////////////////////////// Exam Methods //////////////////////////////////////////////


  ////////////////////////////////////////////// Student Exam Methods //////////////////////////////////////////////

  // Inserts a studentExam object in the database. The return value is the id of the
  // inserted row.
  Future<int> insertStudentExam(StudentExamObject studentExam) async {
    Database db = await instance.database;
    return await db.insert(studentExamTable, studentExam.toMap());
  }

  // Gets a studentExam object from the database by id. The return value is the studentExam object
  // belonging to the id or null if no studentExam object with that id exists in the database
  Future<StudentExamObject> getStudentExamById(int studentId, int examId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(studentExamTable, where: '$studentExamColStudentId = ? AND $studentExamColExamId = ?', whereArgs: [studentId, examId]);

    if (results.isNotEmpty) {
      return StudentExamObject.fromMapObject(results.first);
    }

    return null;
  }

  // All of the rows are returned as a list, where each list element
  // is a studentExam object
  Future<List<StudentExamObject>> getAllStudentExams() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> results = await db.query(studentExamTable);
    List<StudentExamObject> studentExamList = [];

    for (Map<String, dynamic> result in results) {
      studentExamList.add(StudentExamObject.fromMapObject(result));
    }

    return studentExamList;
  }

  // All of the rows for a specific student are returned as a list, where each list element
  // is a studentExam object
  Future<List<StudentExamObject>> getAllStudentExamsOfStudent(int studentId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> results = await db.query(studentExamTable, where: '$studentExamColStudentId = ?', whereArgs: [studentId],);
    List<StudentExamObject> studentExamList = [];
    results.forEach((element) {
      studentExamList.add(StudentExamObject.fromMapObject(element));
    });

    return studentExamList;
  }

  // All of the rows for a specific exam are returned as a list, where each list element
  // is a studentExam object
  Future<List<StudentExamObject>> getAllStudentExamsOfExam(int examId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> results = await db.query(studentExamTable, where: '$studentExamColExamId = ?', whereArgs:  [examId]);
    List<StudentExamObject> studentExamList = [];

    for (Map<String, dynamic> result in results) {
      studentExamList.add(StudentExamObject.fromMapObject(result));
    }

    return studentExamList;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryStudentExamRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $studentExamTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateStudentExam(StudentExamObject studentExam) async {
    Database db = await instance.database;
    return await db.update(studentExamTable, studentExam.toMap(),
        where: '$studentExamColStudentId = ? AND $studentExamColExamId = ?', whereArgs: [studentExam.studentId, studentExam.examId]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteStudentExam(int studentId, int examId) async {
    Database db = await instance.database;
    return await db
        .delete(studentExamTable, where: '$studentExamColStudentId = ? AND $studentExamColExamId = ?', whereArgs: [studentId, examId]);
  }

  // Deletes the rows specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteStudentExamStudentId(int id) async {
    Database db = await instance.database;
    return await db
        .delete(studentExamTable, where: '$studentExamColStudentId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteStudentExamExamId(int id) async {
    Database db = await instance.database;
    return await db
        .delete(studentExamTable, where: '$studentExamColExamId = ?', whereArgs: [id]);
  }

  ////////////////////////////////////////////// Student Exam Methods //////////////////////////////////////////////


  ////////////////////////////////////////////// File Upload Methods //////////////////////////////////////////////

  // Inserts a fileUpload object in the database. The return value is the id of the
  // inserted row.
  Future<int> insertFileUpload(FileUploadObject fileUpload) async {
    Database db = await instance.database;
    return await db.insert(tempUploadedFileTable, fileUpload.toMap());
  }

  // Gets a fileUpload object from the database by id. The return value is the fileUpload object
  // belonging to the id or null if no fileUpload object with that id exists in the database
  Future<FileUploadObject> getFileUploadById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(tempUploadedFileTable, where: '$fileUploadColId = ?', whereArgs: [id]);

    if (results.isNotEmpty) {
      return FileUploadObject.fromMapObject(results.first);
    }

    return null;
  }

  // All of the rows are returned as a list, where each list element
  // is a fileUpload object
  Future<List<FileUploadObject>> getAllFileUploads() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> fileUploads = await db.query(tempUploadedFileTable);
    List<FileUploadObject> fileUploadList = [];

    for (Map<String, dynamic> fileUpload in fileUploads) {
      fileUploadList.add(FileUploadObject.fromMapObject(fileUpload));
    }

    return fileUploadList;
  }

  // All of the rows for a specific student and event are returned as a list, where each list element
  // is a fileUpload object
  Future<List<FileUploadObject>> getAllFileUploadsOfStudentAndEvent(int studentId, int eventId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> fileUploads = await db.query(tempUploadedFileTable, where: '$fileUploadColStudentId = ? AND $fileUploadColEventId = ?', whereArgs: [studentId, eventId]);
    List<FileUploadObject> fileUploadList = [];

    for (Map<String, dynamic> fileUpload in fileUploads) {
      fileUploadList.add(FileUploadObject.fromMapObject(fileUpload));
    }

    return fileUploadList;
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryFileUploadRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tempUploadedFileTable'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> updateFileUpload(FileUploadObject fileUpload) async {
    Database db = await instance.database;
    return await db.update(tempUploadedFileTable, fileUpload.toMap(),
        where: '$fileUploadColId = ?', whereArgs: [fileUpload.id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> deleteFileUpload(int id) async {
    Database db = await instance.database;
    return await db
        .delete(tempUploadedFileTable, where: '$fileUploadColId = ?', whereArgs: [id]);
  }

  Future<int> deleteFileUploadFromStudentEvent(int eventId, int studentId) async {
    Database db = await instance.database;
    return await db.delete(tempUploadedFileTable, where: '$fileUploadColEventId = ? AND $fileUploadColStudentId = ?', whereArgs: [eventId, studentId]);
  }

  ////////////////////////////////////////////// File Upload Methods //////////////////////////////////////////////


  ////////////////////////////////////////////// Helper Methods //////////////////////////////////////////////


  Future<String> getProfessorNameById(int profId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.query(professorTable, columns: [professorColTitle, professorColFirstName, professorColLastName], where: '$professorColId = ?', whereArgs: [profId]);

    if (results.isNotEmpty) {
      List<dynamic> profName = results.first.values.toList();
      return "${profName[0]} ${profName[1]} ${profName[2]}";
    }

    return null;
  }

  Future<dynamic> getLogin(String fhIdentity, String password) async {
    Database db = await instance.database;
    if(fhIdentity.endsWith("s")) {
      List<Map<String, dynamic>> results = await db.query(studentTable,
          where: '$studentColFhIdentifier = ? AND $studentColPassword = ?',
          whereArgs: [fhIdentity, password]);

      if (results.isNotEmpty) {
        return StudentObject.fromMapObject(results.first);
      }
    } else {
      List<Map<String, dynamic>> results = await db.query(professorTable,
          where: '$professorColFhIdentifier = ? AND $professorColPassword = ?',
          whereArgs: [fhIdentity, password]);

      if (results.isNotEmpty) {
        return ProfessorObject.fromMapObject(results.first);
      }
    }

    return null;
  }

  Future<List<SemesterObject>> getAllSemesterOfStudent(int studentId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.rawQuery("SELECT * FROM $semesterTable WHERE $semesterColId IN (SELECT $studentSemesterColSemesterId FROM $studentSemesterTable WHERE $studentSemesterColStudentId = $studentId) ORDER BY $semesterColStartDate DESC");
    List<SemesterObject> semesterList = [];
    results.forEach((element) {
      semesterList.add(SemesterObject.fromMapObject(element));
    });

    return semesterList;
  }

  Future<int> getCompletedEventCountOfCourse(int studentId, int courseId) async {
    Database db = await instance.database;
    int length = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $eventTable WHERE $eventColCourseId = $courseId AND $eventColId IN ( SELECT $studentEventColEventId FROM $studentEventTable WHERE $studentEventColStudentId = $studentId AND $studentEventColStatus = "completed" )'));
    return length;
  }

  Future<int> getCompletedCourseCountOfStudent(int studentId, int semesterId) async {
    Database db = await instance.database;
    int length = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $studentCourseTable WHERE $studentCourseColStudentId = $studentId AND $studentCourseColSemesterId = $semesterId AND $studentCourseColCompleted = "true"'));
    return length;
  }

  Future<int> getEventCountOfCourse(int courseId) async {
    Database db = await instance.database;
    int length = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $eventTable WHERE $eventColCourseId = $courseId'));
    return length;
  }

  Future<int> getCourseCountOfStudent(int studentId, int semesterId) async {
    Database db = await instance.database;
    int length = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $studentCourseTable WHERE $studentCourseColStudentId = $studentId AND $studentCourseColSemesterId = $semesterId'));
    return length;
  }

  Future<Map<SemesterObject, Tuple2<int, int>>> getCurrentSemesterMap(int studentId) async {
    List<SemesterObject> semesterList = await getAllSemesterOfStudent(studentId);
    SemesterObject currentSemester = semesterList.first;
    Map<SemesterObject, Tuple2<int, int>> currentSemesterMap = LinkedHashMap();
    int completedCourses = await getCompletedCourseCountOfStudent(studentId, currentSemester.id);
    int totalCourses = await getCourseCountOfStudent(studentId, currentSemester.id);
    currentSemesterMap.putIfAbsent(currentSemester, () => Tuple2<int, int>(completedCourses, totalCourses));

    return currentSemesterMap;
  }

  Future<Map<SemesterObject, Map<CourseObject, CourseProgressObject>>> getSemesterCourseMapForStudent(int studentId) async {
    List<SemesterObject> semesterList = await getAllSemesterOfStudent(studentId);
    Map<SemesterObject, Map<CourseObject, CourseProgressObject>> semesterCourseMap = LinkedHashMap();
    for(SemesterObject semester in semesterList) {
      Map<CourseObject, CourseProgressObject> courseMap = await getAllCoursesOfStudentSemester(studentId, semester);
      semesterCourseMap.putIfAbsent(semester, () => courseMap);
    }
    return semesterCourseMap;
  }
  
  Future<Map<CourseObject, CourseProgressObject>> getAllCoursesOfStudentSemester(int studentId, SemesterObject semester) async {
    Database db = await instance.database;
    String semesterName = semester.name;
    Map<CourseObject, CourseProgressObject> courseMap = LinkedHashMap();
    List<Map<String, dynamic>> results = await db.rawQuery("SELECT $studentCourseTable.$studentCourseColCompleted, $studentCourseTable.$studentCourseColProfessorId AS profId, $studentCourseTable.$studentCourseColDate, $studentCourseTable.$studentCourseColTime, $courseTable.*, completedEvents, totalEvents FROM $studentCourseTable INNER JOIN $courseTable ON ($courseTable.$courseColId = $studentCourseTable.$studentCourseColCourseId) INNER JOIN (SELECT $eventTable.$eventColCourseId, sum($studentEventTable.$studentEventColStatus = 'completed') AS completedEvents, COUNT(*) AS totalEvents FROM $eventTable INNER JOIN (SELECT $studentEventTable.$studentEventColEventId, $studentEventTable.$studentEventColStatus FROM $studentEventTable WHERE $studentEventTable.$studentEventColStudentId = $studentId GROUP BY $studentEventTable.$studentEventColEventId) $studentEventTable ON ($studentEventTable.$studentEventColEventId = $eventTable.$eventColId) GROUP BY $eventTable.$eventColCourseId) $eventTable ON ($eventTable.$eventColCourseId = $courseTable.$courseColId) WHERE $studentCourseTable.$studentCourseColStudentId = $studentId AND $studentCourseTable.$studentCourseColSemesterId = ${semester.id}");
    for(Map<String, dynamic> result in results) {
        CourseObject course = CourseObject.fromMapObject(result);
        int completedEvents = result["completedEvents"];
        int totalEvents = result["totalEvents"];
        if(totalEvents == completedEvents && result["completed"] == "false") {
          DateTime now = DateTime.now();
          StudentCourseObject studentCourse = StudentCourseObject(studentId, course.id, "true", "${now.day.toString().padLeft(2, "0")}.${now.month.toString().padLeft(2,"0")}.${now.year}", "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}", course.professorId, semester.id);
          updateStudentCourse(studentCourse);
          result["completed"] = "true";
          result["profId"] = course.professorId;
          result["date"] = "${now.day.toString().padLeft(2, "0")}.${now.month.toString().padLeft(2,"0")}.${now.year}";
          result["time"] = "${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}";
        }
        String professorName;
        if (result["completed"] == "true") {
          professorName = await getProfessorNameById(result["profId"]);
        } else {
          professorName = await getProfessorNameById(course.professorId);
        }
        CourseProgressObject courseProgress = CourseProgressObject(result["completed"] == "true", semesterName, professorName, result["date"], result["time"], completedEvents, totalEvents);
        courseMap.putIfAbsent(course, () => courseProgress);
    }
    return courseMap;
  }

  Future<Map<EventObject, EventProgressObject>> getEventMapForCourse(int studentId, int courseId) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> results = await db.rawQuery("SELECT $eventTable.*, $studentEventTable.$studentEventColDate AS studentEventDate, $studentEventTable.$studentEventColTime AS studentEventTime, $studentEventColStatus, $studentEventColProfessorId FROM $eventTable INNER JOIN (SELECT $studentEventTable.* FROM $studentEventTable WHERE $studentEventColStudentId = $studentId) $studentEventTable ON ($studentEventTable.$studentEventColEventId = $eventTable.$eventColId) WHERE $eventTable.$eventColCourseId = $courseId ORDER BY $eventTable.$eventColDate ASC");

    Map<EventObject, EventProgressObject> eventMap = LinkedHashMap();
    for(Map<String, dynamic> element in results) {
      EventObject event = EventObject.fromMapObject(element);
      String profName;
      if(element["professorId"] != null) {
        profName = await getProfessorNameById(element["professorId"]);
      }
      EventProgressObject eventProgress = EventProgressObject(element["status"], profName, element["studentEventDate"]?.split('-')?.reversed?.join('.'), element["studentEventTime"]);
      eventMap.putIfAbsent(event, () => eventProgress);
    }

    return eventMap;
  }

  Future<Map<List<FileUploadObject>, StudentEventObject>> getFileUploadMapByStudentAndEvent(int studentId, int eventId) async {
    List<FileUploadObject> fileUploadList = await getAllFileUploadsOfStudentAndEvent(studentId, eventId);
    StudentEventObject studentEvent = await getStudentEventById(studentId, eventId);
    Map<List<FileUploadObject>, StudentEventObject> fileUploadMap = LinkedHashMap();
    fileUploadMap.putIfAbsent(fileUploadList, () => studentEvent);
    return fileUploadMap;
  }
  
  Future<Map<CourseObject, Map<EventObject, String>>> getEventStatusMap(int studentId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.rawQuery("SELECT $studentEventColStatus, $eventTable.*, $courseTable.* FROM $studentEventTable INNER JOIN $eventTable ON ($studentEventTable.$studentEventColEventId = $eventTable.$eventColId) INNER JOIN $courseTable ON ($courseTable.$courseColId = $eventTable.$eventColCourseId) WHERE $studentEventColStudentId = $studentId AND ($studentEventColStatus = 'upload' OR $studentEventColStatus = 'waiting' OR $studentEventColStatus = 'failed') ORDER BY $studentEventColStatus DESC");
    Map<CourseObject, Map<EventObject, String>> eventStatusMap = LinkedHashMap();
    results.forEach((element) {
      EventObject event = EventObject.fromMapObject(element);
      CourseObject course = CourseObject.fromMapObject(element);
      String status = element['status'];
      Map<EventObject, String> eventMap = LinkedHashMap();
      eventMap.putIfAbsent(event, () => status);
      eventStatusMap.putIfAbsent(course, () => eventMap);
    });

    return eventStatusMap;
  }
  
  Future<Map<CourseObject, Map<EventObject, int>>> getEventStatusMapProf(int professorId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.rawQuery("SELECT $eventTable.*, $courseTable.*, requests FROM $eventTable INNER JOIN $courseTable ON ($courseTable.$courseColId = $eventTable.$eventColCourseId) INNER JOIN (SELECT COUNT(*) AS requests, $studentEventTable.$studentEventColEventId FROM $studentEventTable WHERE $studentEventTable.$studentEventColStatus = 'waiting' GROUP BY $studentEventTable.$studentEventColEventId) $studentEventTable ON ($studentEventTable.$studentEventColEventId = $eventTable.$eventColId) WHERE $courseTable.$courseColProfessorId = $professorId");
    Map<CourseObject, Map<EventObject, int>> eventStatusMap = LinkedHashMap();
    results.forEach((element) {
      EventObject event = EventObject.fromMapObject(element);
      CourseObject course = CourseObject.fromMapObject(element);
      int requests = element['requests'];
      Map<EventObject, int> eventMap = LinkedHashMap();
      eventMap.putIfAbsent(event, () => requests);
      eventStatusMap.putIfAbsent(course, () => eventMap);
    });

    return eventStatusMap;
  }

  Future<Map<EventObject, String>> getNextEventsMap(int studentId) async {
    Database db = await instance.database;
    DateTime now = DateTime.now();
    String nowDate = now.toString().split(" ").first;
    DateTime week = now.add(Duration(days: 21));
    String weekDate = week.toString().split(" ").first;
    List<Map<String, dynamic>> results = await db.rawQuery('SELECT $eventTable.*, $courseTable.$courseColName AS courseName FROM $eventTable INNER JOIN $courseTable ON ($courseTable.$courseColId = $eventTable.$eventColCourseId) WHERE $eventColDate >= "$nowDate" AND $eventColDate <= "$weekDate" AND $eventTable.$eventColId IN (SELECT $studentEventTable.$studentEventColEventId FROM $studentEventTable WHERE $studentEventColStudentId = $studentId AND $studentEventColStatus = "none") ORDER BY $eventColDate ASC');
    Map<EventObject, String> nextEventsMap = LinkedHashMap();
    for(Map<String, dynamic> result in results) {
      EventObject event = EventObject.fromMapObject(result);
      nextEventsMap.putIfAbsent(event, () => result["courseName"]);
    }

    return nextEventsMap;
  }

  Future<Map<EventObject, String>> getNextEventsMapProf(int professorId) async {
    Database db = await instance.database;
    DateTime now = DateTime.now();
    String nowDate = now.toString().split(" ").first;
    DateTime week = now.add(Duration(days: 21));
    String weekDate = week.toString().split(" ").first;
    List<Map<String, dynamic>> results = await db.rawQuery('SELECT $eventTable.*, $courseTable.$courseColName AS courseName FROM $eventTable INNER JOIN $courseTable ON($courseTable.$courseColId = $eventTable.$eventColCourseId) WHERE $eventColDate >= "$nowDate" AND $eventColDate <= "$weekDate" AND $courseColProfessorId = $professorId ORDER BY $eventColDate ASC');
    Map<EventObject, String> nextEventsMap = LinkedHashMap();
    results.forEach((element) {
      EventObject event = EventObject.fromMapObject(element);
      nextEventsMap.putIfAbsent(event, () => element["courseName"]);
    });

    return nextEventsMap;
  }

  Future<Map<String, Map<String, EventSettingsObject>>> getEventSettingsMap(int professorId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.rawQuery('SELECT $courseTable.$courseColName AS courseName, $eventTable.$eventColName AS eventName, $eventSettingsTable.* FROM $eventSettingsTable INNER JOIN $eventTable ON ($eventTable.$eventColId = $eventSettingsTable.$eventSettingsColEventId) INNER JOIN $courseTable ON ($courseTable.$courseColId = $eventTable.$eventColCourseId) WHERE $eventSettingsTable.$eventSettingsColProfessorId = $professorId');
    Map<String, Map<String, EventSettingsObject>> eventSettingsMap = LinkedHashMap();
    Map<String, EventSettingsObject> settingsMap = LinkedHashMap();
    String courseName;
    String prevCourseName;
    results.forEach((element) {
      courseName = element["courseName"];
      if(prevCourseName != courseName && prevCourseName != null) {
        eventSettingsMap.putIfAbsent(prevCourseName, () => settingsMap);
        settingsMap = LinkedHashMap();
      }
      prevCourseName = courseName;
      settingsMap.putIfAbsent(element["eventName"], () => EventSettingsObject.fromMapObject(element));
    });

    eventSettingsMap.putIfAbsent(courseName, () => settingsMap);

    return eventSettingsMap;
  }

  Future<Map<String, List<ExamDataObject>>> getExamMap(int professorId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.rawQuery('SELECT $examsTable.*, $courseTable.$courseColName AS courseName, $studentExamTable.$studentExamColStatus FROM $examsTable INNER JOIN $courseTable ON ($courseTable.$courseColId = $examsTable.$examsColCourseId) INNER JOIN $studentExamTable ON ($studentExamTable.$studentExamColExamId = $examsTable.$examsColId) WHERE $examsTable.$examsColProfessorId = $professorId ORDER BY $examsTable.$examsColCourseId');
    Map<String, List<ExamDataObject>> examMap = LinkedHashMap();
    String courseName;
    String prevCourseName;
    ExamObject exam;
    ExamObject prevExam;
    int enrolledCount = 0;
    int approvedCount = 0;

    List<ExamDataObject> examList = [];
    results.forEach((element) {
      exam = ExamObject.fromMapObject(element);
      courseName = element["courseName"];
      if(prevExam != null && prevExam.examId != exam.examId ) {
        ExamDataObject examData = ExamDataObject.fromExamObject(prevExam);
        examData.enrolledCount = enrolledCount;
        examData.approvedCount = approvedCount;
        examList.add(examData);
        enrolledCount = 0;
        approvedCount = 0;
      }
      prevExam = exam;

      if (prevCourseName != courseName && prevCourseName != null) {

          examMap.putIfAbsent(prevCourseName, () => examList);
          examList = [];
      }
      prevCourseName = courseName;

      if(element["$studentExamColStatus"] != "approved") {
        enrolledCount++;
      }
      approvedCount++;
    });

    ExamDataObject examData = ExamDataObject.fromExamObject(exam);
    examData.enrolledCount = enrolledCount;
    examData.approvedCount = approvedCount;
    examList.add(examData);
    examMap.putIfAbsent(courseName, () => examList);

    return examMap;
  }

  Future<Map<StudentObject, String>> getExamStudentMap(int examId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> results = await db.rawQuery('SELECT $studentExamTable.$studentExamColStatus, $studentTable.* FROM $studentExamTable INNER JOIN $studentTable ON ($studentTable.$studentColId = $studentExamTable.$studentExamColStudentId) WHERE $studentExamTable.$studentExamColExamId = $examId AND $studentExamColStatus != "approved"');
    Map<StudentObject, String> examStudentMap = LinkedHashMap();

    results.forEach((element) {
      StudentObject student = StudentObject.fromMapObject(element);
      examStudentMap.putIfAbsent(student, () => element["status"]);
    });

    return examStudentMap;
  }

}
