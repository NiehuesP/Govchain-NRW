package com.example.restservice.sqlite;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;


@Configuration
public class DBInitializeConfig {
	
	public static final String studentTable = "students";
	
	public static final String studentColId = "studentId";
	public static final String studentColFirstName = "firstName";
	public static final String studentColLastName = "lastName";
	public static final String studentColMatriculation = "matriculation";
	public static final String studentColDateOfBirth = "dateOfBirth";
	public static final String studentColUniversity = "university";
	public static final String studentColFaculty = "faculty";
	public static final String studentColField = "field";
	public static final String studentColDegree = "degree";
	public static final String studentColFhIdentifier = "fhIdentifier";
	public static final String studentColPassword = "password";
	 
	public static final String courseTable = "courses";
	 
	public static final String courseColId = "courseId";
	public static final String courseColName = "name";
	public static final String courseColShortName = "shortName";
	public static final String courseColSemesterId = "semesterId";
	public static final String courseColProfessorId = "professorId";
	 
	public static final String eventTable = "events";
	 
	public static final String eventColId = "eventId";
	public static final String eventColDate = "date";
	public static final String eventColName = "name";
	public static final String eventColRoom = "room";
	public static final String eventColTime = "time";
	public static final String eventColCourseId = "courseId";
	 
	public static final String professorTable = "professors";
	 
	public static final String professorColId = "professorId";
	public static final String professorColFirstName = "firstName";
	public static final String professorColLastName = "lastName";
	public static final String professorColTitle = "title";
	public static final String professorColFhIdentifier = "fhIdentifier";
	public static final String professorColPassword = "password";
	 
	public static final String semesterTable = "semesters";
	 
	public static final String semesterColId = "semesterId";
	public static final String semesterColName = "name";
	public static final String semesterColStartDate = "startDate";
	public static final String semesterColEndDate = "endDate";
	 
	public static final String studentCourseTable = "studentCourses";
	 
	public static final String studentCourseColStudentId = "studentId";
	public static final String studentCourseColCourseId = "courseId";
	public static final String studentCourseColCompleted = "completed";
	public static final String studentCourseColDate = "date";
	public static final String studentCourseColTime = "time";
	public static final String studentCourseColProfessorId = "professorId";
	public static final String studentCourseColSemesterId = "semesterId";
	 
	public static final String studentEventTable = "studentEvents";
	 
	public static final String studentEventColStudentId = "studentId";
	public static final String studentEventColEventId = "eventId";
	public static final String studentEventColProfessorId = "professorId";
	public static final String studentEventColDate = "date";
	public static final String studentEventColTime = "time";
	public static final String studentEventColStatus = "status";
	 
	public static final String studentSemesterTable = "studentSemester";
	 
	public static final String studentSemesterColStudentId = "studentId";
	public static final String studentSemesterColSemesterId = "semesterId";
	 
	public static final String eventSettingsTable = "eventSettings";
	 
	public static final String eventSettingsColEventId = "eventId";
	public static final String eventSettingsColProfessorId = "professorId";
	public static final String eventSettingsColNeedUpload = "needUpload";
	public static final String eventSettingsColAutoComplete = "autoComplete";
	public static final String eventSettingsColNotifications = "notifications";
	 
	public static final String examsTable = "exams";
	 
	public static final String examsColId = "examId";
	public static final String examsColCourseId = "courseId";
	public static final String examsColDate = "date";
	public static final String examsColTime = "time";
	public static final String examsColRoom = "room";
	public static final String examsColProfessorId = "professorId";
	 
	public static final String studentExamTable = "studentExams";
	 
	public static final String studentExamColStudentId = "studentId";
	public static final String studentExamColExamId = "examId";
	public static final String studentExamColStatus = "status";
	 
	public static final String tempUploadedFileTable = "uploadedFiles";
	 
	public static final String fileUploadColId = "fileId";
	public static final String fileUploadColEventId = "eventId";
	public static final String fileUploadColStudentId = "studentId";
	public static final String fileUploadColFileName = "fileName";
	public static final String fileUploadColUploadTime = "uploadTime";
	public static final String fileUploadColFileType = "fileType";
	public static final String fileUploadColSize = "size";

	@Autowired
	private DataSource dataSource;
	
	private Connection connection;
	private Statement statement;
	
	@PostConstruct
	public void initialize(){
		try {

			connection = dataSource.getConnection();
			statement = connection.createStatement();
			
			createStudentTable();
			createCourseTable();
			createEventTable();
			createProfessorTable();
			createSemesterTable();
			createStudentCourseTable();
			createStudentEventTable();
			createStudentSemesterTable();
			createEventSettingsTable();
			createExamsTable();
			createStudentExamsTable();
			createUploadedFileTable();
			
			addDummyData();
			
			
			statement.close();
			connection.close();
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	private void createStudentTable() throws SQLException {
		statement.execute("DROP TABLE IF EXISTS " + studentTable);
		statement.executeUpdate(
				"CREATE TABLE " + studentTable + " (" +
			            studentColId +  " INTEGER PRIMARY KEY AUTOINCREMENT," +
			            studentColFirstName + " TEXT NOT NULL," + 
			            studentColLastName + " TEXT NOT NULL," +
			            studentColMatriculation + " INTEGER NOT NULL," +
			            studentColDateOfBirth + " TEXT NOT NULL," +
			            studentColUniversity + " TEXT NOT NULL," +
			            studentColFaculty + " TEXT NOT NULL," +
			            studentColField + " TEXT NOT NULL," + 
			            studentColDegree + " TEXT NOT NULL," +
			            studentColFhIdentifier + " TEXT NOT NULL," +
			            studentColPassword + " TEXT NOT NULL)"
				);
	}
	
	private void createCourseTable() throws SQLException {
		statement.execute("DROP TABLE IF EXISTS " + courseTable);
		statement.executeUpdate(
		          "CREATE TABLE " + courseTable + " (" +
		            courseColId + " INTEGER PRIMARY KEY AUTOINCREMENT," +
		            courseColName + " TEXT NOT NULL," +
		            courseColShortName + " TEXT NOT NULL," +
		            courseColSemesterId + " INTEGER NOT NULL," +
		            courseColProfessorId + " INTEGER NOT NULL)"  
		          );
	}
	
	private void createEventTable() throws SQLException {
		statement.execute("DROP TABLE IF EXISTS " + eventTable);
		statement.executeUpdate(
		          "CREATE TABLE " + eventTable + " (" +
		            eventColId + " INTEGER PRIMARY KEY AUTOINCREMENT," +
		            eventColDate + " TEXT NOT NULL," +
		            eventColName + " TEXT NOT NULL," +
		            eventColRoom + " TEXT NOT NULL," +
		            eventColTime + " TEXT NOT NULL," +
		            eventColCourseId + " INTEGER NOT NULL)"
		          );
	}
	
	private void createProfessorTable() throws SQLException {
		statement.execute("DROP TABLE IF EXISTS " + professorTable);
		statement.executeUpdate(
		          "CREATE TABLE " + professorTable + " (" +
		            professorColId + " INTEGER PRIMARY KEY AUTOINCREMENT," +
		            professorColFirstName + " TEXT NOT NULL," +
		            professorColLastName + " TEXT NOT NULL," +
		            professorColTitle + " TEXT NOT NULL, "+
		            professorColFhIdentifier + " TEXT NOT NULL, " +
		            professorColPassword + " TEXT NOT NULL)"
		          );
	}
	
	private void createSemesterTable() throws SQLException {
		statement.execute("DROP TABLE IF EXISTS " + semesterTable);
		statement.executeUpdate(
		          "CREATE TABLE " + semesterTable + " (" +
		            semesterColId + " INTEGER PRIMARY KEY AUTOINCREMENT," +
		            semesterColName + " TEXT NOT NULL," +
		            semesterColStartDate + " TEXT NOT NULL," +
		            semesterColEndDate + " TEXT NOT NULL)"
		          );
	}
	
	private void createStudentCourseTable() throws SQLException {
		statement.execute("DROP TABLE IF EXISTS " + studentCourseTable);
		statement.executeUpdate(
		          "CREATE TABLE " + studentCourseTable + " (" +
		            studentCourseColStudentId + " INTEGER NOT NULL," +
		            studentCourseColCourseId + " INTEGER NOT NULL," +
		            studentCourseColCompleted + " TEXT NOT NULL," +
		            studentCourseColDate + " TEXT," +
		            studentCourseColTime + " TEXT," +
		            studentCourseColProfessorId + " INTEGER," +
		            studentCourseColSemesterId + " INTEGER," +
		            "FOREIGN KEY ( " + studentCourseColStudentId + " ) REFERENCES " + studentTable + "(" + studentColId+ ")," +
		            "FOREIGN KEY ( " + studentCourseColCourseId + " ) REFERENCES " + courseTable + "(" + courseColId + ")," +
		            "PRIMARY KEY ( " + studentCourseColStudentId + ", " + studentCourseColCourseId + " ))"
		          );
	}
	
	private void createStudentEventTable() throws SQLException {
		statement.execute("DROP TABLE IF EXISTS " + studentEventTable);
		statement.executeUpdate(
		          "CREATE TABLE " + studentEventTable + " (" +
		            studentEventColStudentId + " INTEGER NOT NULL," +
		            studentEventColEventId + " INTEGER NOT NULL," +
		            studentEventColProfessorId + " INTEGER," +
		            studentEventColDate + " TEXT," +
		            studentEventColTime + " TEXT," +
		            studentEventColStatus + " TEXT," +
		            "FOREIGN KEY ( " + studentEventColStudentId + " ) REFERENCES " + studentTable + "(" + studentColId + ")," +
		            "FOREIGN KEY ( " + studentEventColEventId + " ) REFERENCES " + eventTable + "(" + eventColId + ")," +
		            "PRIMARY KEY ( " + studentEventColStudentId + ", " + studentEventColEventId + " ))"
		          );
	}
	
	private void createStudentSemesterTable() throws SQLException {
		statement.execute("DROP TABLE IF EXISTS " + studentSemesterTable);
		statement.executeUpdate(
		          "CREATE TABLE " + studentSemesterTable + " (" +
		            studentSemesterColStudentId + " INTEGER NOT NULL," +
		            studentSemesterColSemesterId + " INTEGER NOT NULL," +
		            "FOREIGN KEY ( " + studentSemesterColStudentId + " ) REFERENCES " + studentTable + "(" + studentColId + ")," +
		            "FOREIGN KEY ( " + studentSemesterColSemesterId + " ) REFERENCES " + semesterTable + "(" + semesterColId + ")," +
		            "PRIMARY KEY ( " + studentSemesterColStudentId + ", " + studentSemesterColSemesterId + "))"
		          );
	}
	
	private void createEventSettingsTable() throws SQLException {
		statement.execute("DROP TABLE IF EXISTS " + eventSettingsTable);
		statement.executeUpdate(
		          "CREATE TABLE " + eventSettingsTable + " (" +
		            eventSettingsColEventId + " INTEGER NOT NULL," +
		            eventSettingsColProfessorId + " INTEGER NOT NULL," +
		            eventSettingsColNeedUpload + " TEXT NOT NULL," +
		            eventSettingsColAutoComplete + " TEXT NOT NULL," +
		            eventSettingsColNotifications + " TEXT NOT NULL," +
		            "FOREIGN KEY ( " + eventSettingsColEventId + " ) REFERENCES " + eventTable + "(" + eventColId + ")," +
		            "FOREIGN KEY ( " + eventSettingsColProfessorId + " ) REFERENCES " + professorTable + "(" + professorColId + ")," +
		            "PRIMARY KEY ( " + eventSettingsColEventId + ", " + eventSettingsColProfessorId + "))"
		          );
	}
	
	private void createExamsTable() throws SQLException {
		statement.execute("DROP TABLE IF EXISTS " + examsTable);
		statement.executeUpdate(
		          "CREATE TABLE " + examsTable + " (" +
		            examsColId + " INTEGER PRIMARY KEY AUTOINCREMENT," +
		            examsColCourseId + " INTEGER NOT NULL," +
		            examsColDate + " TEXT NOT NULL," +
		            examsColTime + " TEXT NOT NULL," +
		            examsColRoom + " TEXT NOT NULL," +
		            examsColProfessorId + " INTEGER NOT NULL)"
		          );
	}
	
	private void createStudentExamsTable() throws SQLException {
		statement.execute("DROP TABLE IF EXISTS " + studentExamTable);
		statement.executeUpdate(
		          "CREATE TABLE " + studentExamTable + " (" +
		            studentExamColStudentId + " INTEGER NOT NULL," +
		            studentExamColExamId + " INTEGER NOT NULL," +
		            studentExamColStatus + " TEXT NOT NULL," +
		            "FOREIGN KEY ( " + studentExamColStudentId + " ) REFERENCES " + studentTable + "(" + studentColId + ")," +
		            "FOREIGN KEY ( " + studentExamColExamId + " ) REFERENCES " + examsTable + "(" + examsColId + ")," +
		            "PRIMARY KEY ( " + studentExamColStudentId + ", " + studentExamColExamId + "))"
		          );
	}
	
	private void createUploadedFileTable() throws SQLException {
		statement.execute("DROP TABLE IF EXISTS " + tempUploadedFileTable);
		statement.executeUpdate(
		          "CREATE TABLE " + tempUploadedFileTable + " (" +
		            fileUploadColId + " INTEGER PRIMARY KEY AUTOINCREMENT," +
		            fileUploadColEventId + " INTEGER NOT NULL," +
		            fileUploadColStudentId + " INTEGER NOT NULL," +
		            fileUploadColFileName + " TEXT NOT NULL," +
		            fileUploadColUploadTime + " TEXT NOT NULL, " +
		            fileUploadColFileType + " TEXT NOT NULL, " +
		            fileUploadColSize + " INTEGER NOT NULL)"
		          );
	}
	
	private void addDummyData() throws SQLException {
		addStudent();
		addProfessor();
		addSemester();
	    addCourses();
	    addEvents();
	    addStudentCourses();
	    addStudentEvents();
	    addStudentSemesters();
	    addEventSettings();
	    addExams();
	    addStudentExams();
		
	}
	
	private void addStudent() throws SQLException {
		statement.executeUpdate(
				"INSERT INTO " + studentTable +
				"(" + studentColFirstName + "," + studentColLastName + "," + studentColMatriculation + "," + 
						studentColDateOfBirth + "," + studentColUniversity + "," + studentColFaculty + "," +
						studentColField + "," + studentColDegree + "," + studentColFhIdentifier + "," +
						studentColPassword + ") " +
				"VALUES ('Max','Mustermann',1234567,'01.01.1990','Muster-Hochschule','FB01 Musterfachbereich'," +
						"'Musterfach','Musterabschluss','mm3067s','test')"
				);
	}
	
	private void addProfessor() throws SQLException {
		statement.executeUpdate(
				"INSERT INTO " + professorTable +
				"(" + professorColFirstName + "," + professorColLastName + "," + professorColTitle + "," +
						professorColFhIdentifier + "," + professorColPassword + ") " +
				"VALUES ('Erika', 'Musterfrau', 'Prof. Dr.', 'em5602p', 'test')"
				);
	}
	
	private void addSemester() throws SQLException {
		statement.executeUpdate(
				"INSERT INTO " + semesterTable +
				"(" + semesterColName + "," + semesterColStartDate + "," + semesterColEndDate + ") " +
						"VALUES ('Sommersemester 2021', '01.03.2021', '31.08.2021')"
				);
	}
	
	private void addCourses() throws SQLException {
		statement.executeUpdate(
				"INSERT INTO " + courseTable +
				"(" + courseColName + "," + courseColShortName + "," + courseColSemesterId + "," + courseColProfessorId + ") " +
						"VALUES ('Musterkurs','MK', 1, 1)"
				);
	}
	
	private void addEvents() throws SQLException {
		statement.executeUpdate(
				"INSERT INTO " + eventTable +
				"(" + eventColDate + "," + eventColName + "," + eventColRoom + "," + eventColTime + "," + eventColCourseId + ") " +
				"VALUES ('01.05.2021', 'Musterpraktikum', 'Musterraum', '08:15-10:45', 1)"
				);
	}
	
	private void addStudentCourses() throws SQLException {
		statement.executeUpdate(
				"INSERT INTO " + studentCourseTable +
				"(" + studentCourseColStudentId + "," + studentCourseColCourseId + "," + studentCourseColCompleted + "," +
				studentCourseColDate + "," + studentCourseColTime + "," + studentCourseColProfessorId + "," + studentCourseColSemesterId + ") " +
				"VALUES (1, 1, 'true', '02.05.2021', '11:34', 1, 1)"
				);
		
		//Values (1, 1, 'false', null, null, null, 1) for unfinished courses
	}
	
	private void addStudentEvents() throws SQLException {
		statement.executeUpdate(
				"INSERT INTO " + studentEventTable +
				"(" + studentEventColStudentId + "," + studentEventColEventId + "," + studentEventColProfessorId + "," + 
				studentEventColDate + "," + studentEventColTime + "," + studentEventColStatus + ") " +
				"VALUES (1, 1, 1, '02.05.2021', '11:33', 'completed')"
				);
		
		//Values (1, 1, null, null, null, 'none') for unfinished events
		//Possible status are: none, upload, waiting, failed and completed		    
	}
	
	private void addStudentSemesters() throws SQLException {
		statement.executeUpdate(
				"INSERT INTO " + studentSemesterTable +
				"(" + studentSemesterColStudentId + "," + studentSemesterColSemesterId + ") " +
				"VALUES (1, 1)"
				);
	}
	
	private void addEventSettings() throws SQLException {
		statement.executeUpdate(
				"INSERT INTO " + eventSettingsTable + 
				"(" + eventSettingsColEventId + "," + eventSettingsColProfessorId + "," + eventSettingsColNeedUpload + "," +
				eventSettingsColAutoComplete + "," + eventSettingsColNotifications + ") " +
				"VALUES (1, 1, 'true', 'false', 'false')"
				);
	}
	
	private void addExams() throws SQLException {
		statement.executeUpdate(
				"INSERT INTO " + examsTable + 
				"(" + examsColCourseId + "," + examsColDate + "," + examsColTime + "," + examsColRoom + "," +
				examsColProfessorId + ") " +
				"VALUES (1, '01.06.2021', '08:15-10:45', 'Musterraum', 1)"
				);
	}
	
	private void addStudentExams() throws SQLException {
		statement.executeUpdate(
				"INSERT INTO " + studentExamTable + 
				"(" + studentExamColStudentId + "," + studentExamColExamId + "," + studentExamColStatus + ") " +
				"VALUES (1, 1, 'present')"
				);
		
		//Possible status are: approved, enrolled, present and absent
	}
}