
import 'package:studybuddy/services/database_service.dart';

class DummyData {
  DatabaseService databaseService;
  DummyData() {
    databaseService = DatabaseService.instance;
  }
}