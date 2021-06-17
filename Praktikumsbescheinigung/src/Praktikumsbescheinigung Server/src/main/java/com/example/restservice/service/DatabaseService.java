package com.example.restservice.service;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Optional;

import javax.sql.DataSource;

import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.restservice.entities.Course;
import com.example.restservice.entities.Event;
import com.example.restservice.entities.EventSettings;
import com.example.restservice.entities.Exam;
import com.example.restservice.entities.FileUpload;
import com.example.restservice.entities.Professor;
import com.example.restservice.entities.Semester;
import com.example.restservice.entities.Student;
import com.example.restservice.entities.StudentCourse;
import com.example.restservice.entities.StudentEvent;
import com.example.restservice.entities.StudentExam;
import com.example.restservice.entities.StudentSemester;
import com.example.restservice.response.ProfessorDataResponse;
import com.example.restservice.response.StudentDataResponse;

import static com.example.restservice.sqlite.DBInitializeConfig.*;

@Service
public class DatabaseService {
	
	@Autowired
	DataSource dataSource;
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	public Student getLoginStudent(String username, String password) {
		String sql = String.format("SELECT * FROM %s WHERE %s = '%s' AND %s = '%s'", studentTable, studentColFhIdentifier, username, studentColPassword, password);
		try (Connection conn = dataSource.getConnection()) {
		Statement stmt = conn.createStatement();
		
				
		Student student = new Student(stmt.executeQuery(sql));
		
		stmt.close();
		conn.close();
		return student;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public ProfessorDataResponse getAllDataForProfessor(int professorId) {
		List<Student> studentList = getStudentListByProfessorId(professorId);
		List<Semester> semesterList = getSemesterListByProfessorId(professorId);
		List<Course> courseList = getCourseListByProfessorId(professorId);
		List<Event> eventList = getEventListByProfessorId(professorId);
		List<StudentCourse> studentCourseList = getStudentCourseListByProfessorId(professorId);
		List<StudentEvent> studentEventList = getStudentEventListByProfessorId(professorId);
		List<Exam> examList = getExamListByProfessorId(professorId);
		List<StudentExam> studentExamList = getStudentExamListByProfessorId(professorId);
		List<EventSettings> eventSettingsList = getEventSettingsListByProfessorId(professorId);
		List<FileUpload> fileUploadList = getFileUploadListByProfessorId(professorId);
		
		return new ProfessorDataResponse(studentList, semesterList, courseList, eventList, studentCourseList, studentEventList, examList, studentExamList, eventSettingsList, fileUploadList);
	}
	
	
	public StudentDataResponse getAllDataForStudent(int studentId) {
		List<StudentSemester> studentSemesterList = getStudentSemesterListByStudentId(studentId);
		List<StudentExam> studentExamList = getStudentExamListByStudentId(studentId);
		List<StudentCourse> studentCourseList = getStudentCourseListByStudentId(studentId);
		List<StudentEvent> studentEventList = getStudentEventListByStudentId(studentId);
		List<Exam> examList = getExamListByStudentId(studentId);
		List<Semester> semesterList = getSemesterListByStudentId(studentId);
		List<Course> courseList = getCourseListByStudentId(studentId);
		List<Event> eventList = getEventListByStudentId(studentId);
		List<Professor> professorList = getProfessorListByStudentId(studentId);
		List<FileUpload> fileUploadList = getFileUploadListByStudentId(studentId);
		List<EventSettings> eventSettingsList = getEventSettingsListByStudentId(studentId);
		
		return new StudentDataResponse(professorList, semesterList, courseList, eventList, studentCourseList, studentEventList, studentSemesterList, examList, studentExamList, fileUploadList, eventSettingsList);
	}
	
	public List<FileUpload> getFileUploadListByProfessorId(int professorId) {
		List<FileUpload> fileUploadList = new ArrayList<>();
		String sql = "SELECT DISTINCT * FROM " + tempUploadedFileTable + " WHERE " + tempUploadedFileTable + "." + fileUploadColEventId + " IN (SELECT " + eventTable + "." + eventColId + " FROM " + eventTable + " WHERE " + eventTable + "." + eventColCourseId + " IN (SELECT " + courseTable + "." + courseColId + " FROM " + courseTable + " WHERE " + courseTable + "." + courseColProfessorId + " = " + professorId + ")) OR " + tempUploadedFileTable + "." + fileUploadColEventId + " IN (SELECT " + studentEventTable + "." + studentEventColEventId + " FROM " + studentEventTable + " WHERE " + studentEventTable + "." + studentEventColProfessorId + " = " + professorId + ")";
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				FileUpload fileUpload = new FileUpload(rs);
				fileUploadList.add(fileUpload);
			}
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return fileUploadList;
	}
	
	public List<FileUpload> getFileUploadListByStudentId(int studentId) {
		List<FileUpload> fileUploadList = new ArrayList<>();
		String sql = "SELECT * FROM " + tempUploadedFileTable + " WHERE " + fileUploadColStudentId + " = " + studentId;
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				FileUpload fileUpload = new FileUpload(rs);
				fileUploadList.add(fileUpload);
			}
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return fileUploadList;
	}
	
	public List<Student> getStudentListByProfessorId(int professorId) {
		List<Student> studentList = new ArrayList<>();
		String sql = "SELECT DISTINCT " + studentTable + "." + studentColId + ", " + studentTable + "." + studentColFirstName + ", " + studentTable + "." + studentColLastName + ", " + studentTable + "." + studentColMatriculation + ", " + studentTable + "." + studentColFhIdentifier + " FROM " + studentTable + " WHERE " + studentTable + "." + studentColId + " IN (SELECT " + studentCourseTable + "." + studentCourseColStudentId + " FROM " + studentCourseTable + " WHERE " + studentCourseTable + "." + studentCourseColCourseId + " IN (SELECT " + courseTable + "." + courseColId + " FROM " + courseTable + " WHERE " + courseTable + "." + courseColProfessorId + " = " + professorId + ")) OR " + studentTable + "." + studentColId + " IN (SELECT " + studentExamTable + "." + studentExamColStudentId + " FROM " + studentExamTable + " WHERE " + studentExamTable + "." + studentExamColExamId + " IN (SELECT " + examsTable + "." + examsColId + " FROM " + examsTable + " WHERE " + examsTable + "." + examsColProfessorId + " = " + professorId + ")) OR " + studentTable + "." + studentColId + " IN (SELECT " + studentEventTable + "." + studentEventColStudentId + " FROM " + studentEventTable + " WHERE " + studentEventTable + "." + studentEventColEventId + " IN (SELECT " + eventTable + "." + eventColId + " FROM " + eventTable + " WHERE " + eventTable + "." + eventColCourseId + " IN (SELECT " + courseTable + "." + courseColId + " FROM " + courseTable + " WHERE " + courseTable + "." + courseColProfessorId + " = " + professorId + " )))";
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				Student student = new Student(rs, true);
				studentList.add(student);
			}
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return studentList;
	}
	
	public List<Semester> getSemesterListByProfessorId(int professorId) {
		List<Semester> semesterList = new ArrayList<>();
		String sql = "SELECT * FROM " + semesterTable + " WHERE " + semesterTable + "." + semesterColId + " IN (SELECT " + courseTable + "." + courseColSemesterId + " FROM " + courseTable + " WHERE " + courseColProfessorId + " = " + professorId + ")";
		try(Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				Semester semester = new Semester(rs);
				semesterList.add(semester);
			}
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return semesterList;
	}
	
	public List<StudentCourse> getStudentCourseListByProfessorId(int professorId) {
		List<StudentCourse> studentCourseList = new ArrayList<>();
		String sql = "SELECT * FROM " + studentCourseTable + " WHERE " + studentCourseTable + "." + studentCourseColCourseId + " IN (SELECT " + courseTable + "." + courseColId + " FROM " + courseTable + " WHERE " + courseColProfessorId + " = " + professorId + ")";
		try(Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				StudentCourse studentCoure = new StudentCourse(rs);
				studentCourseList.add(studentCoure);
			}
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return studentCourseList;
	}
	
	public List<StudentEvent> getStudentEventListByProfessorId(int professorId) {
		List<StudentEvent> studentEventList = new ArrayList<>();
		String sql = "SELECT * FROM " + studentEventTable + " WHERE " + studentEventTable + "." + studentEventColEventId + " IN (SELECT " + eventTable + "." + eventColId + " FROM " + eventTable + " WHERE " + eventTable + "." + eventColCourseId + " IN (SELECT " + courseTable + "." + courseColId + " FROM " + courseTable + " WHERE " + courseTable + "." + courseColProfessorId + " = " + professorId + "))";
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				StudentEvent studentEvent = new StudentEvent(rs);
				studentEventList.add(studentEvent);
			}
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return studentEventList;
	}
	
	public List<Event> getEventListByProfessorId(int professorId) {
		List<Event> eventList = new ArrayList<>();
		String sql = "SELECT * FROM " + eventTable + " WHERE " + eventTable + "." + eventColCourseId + " IN (SELECT " + courseTable + "." + courseColId + " FROM " + courseTable + " WHERE " + courseTable + "." + courseColProfessorId + " = " + professorId + ") OR " + eventTable + "." + eventColId + " IN (SELECT " + eventSettingsTable + "." + eventSettingsColEventId + " FROM " + eventSettingsTable + " WHERE " + eventSettingsTable + "." + eventSettingsColProfessorId + " = " + professorId + ")";
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				Event event = new Event(rs);
				eventList.add(event);
			}
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return eventList;
	}
	
	public List<Course> getCourseListByProfessorId(int professorId) {
		List<Course> courseList = new ArrayList<>();
		String sql = "SELECT * FROM " + courseTable + " WHERE " + courseColProfessorId + " = " + professorId;
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				Course course = new Course(rs);
				courseList.add(course);
			}
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return courseList;
	}
	
	public List<EventSettings> getEventSettingsListByProfessorId(int professorId) {
		List<EventSettings> eventSettingsList = new ArrayList<>();
		String sql = "SELECT * FROM " + eventSettingsTable + " WHERE " + eventSettingsColProfessorId + " = " + professorId;
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				EventSettings eventSettings = new EventSettings(rs);
				eventSettingsList.add(eventSettings);
			}
			
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return eventSettingsList;
	}
	
	public List<Exam> getExamListByProfessorId(int professorId) {
		List<Exam> examList = new ArrayList<>();
		String sql = "SELECT * FROM " + examsTable + " WHERE " + examsColProfessorId + " = " + professorId;
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				Exam exam = new Exam(rs);
				examList.add(exam);
			}
			
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return examList;
	}
	
	private List<StudentExam> getStudentExamListByProfessorId(int professorId) {
		List<StudentExam> studentExamList = new ArrayList<>();
		String sql = "SELECT * FROM " + studentExamTable + " WHERE " + studentExamTable + "." + studentExamColExamId + " IN ( SELECT " + examsTable + "." + examsColId + " FROM " + examsTable + " WHERE " + examsColProfessorId + " = " + professorId + " )";
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				StudentExam studentExam = new StudentExam(rs);
				studentExamList.add(studentExam);
			}
			
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return studentExamList;
	}
	
	private List<Professor> getProfessorListByStudentId(int studentId) {
		List<Professor> professorList = new ArrayList<>();
		String sql = "SELECT DISTINCT " + professorTable + "." + professorColFirstName + "," + professorTable + "." + professorColLastName + "," + professorTable + "." + professorColTitle + "," + professorTable + "." + professorColId + " FROM " + professorTable + " WHERE " + professorTable + "." + professorColId + " IN (SELECT " + courseTable + "." + courseColProfessorId + " FROM " + courseTable + " WHERE " + courseTable + "." + courseColId + " IN (SELECT " + studentCourseTable + "." + studentCourseColCourseId + " FROM " + studentCourseTable + " WHERE " + studentCourseTable + "." + studentCourseColStudentId + " = " + studentId + ") ) OR " + professorTable + "." + professorColId + " IN (SELECT " + studentCourseTable + "." + studentCourseColProfessorId + " FROM " + studentCourseTable + " WHERE " + studentCourseTable + "." + studentCourseColStudentId + " = " + studentId + ") OR " + professorTable + "." + professorColId + " IN (SELECT " + studentEventTable + "." + studentEventColProfessorId + " FROM " + studentEventTable + " WHERE " + studentEventTable + "." + studentEventColStudentId + " = " + studentId + ")";
		try(Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				Professor professor = new Professor(rs, true);
				professorList.add(professor);
			}
			
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return professorList;
	}
	
	private List<EventSettings> getEventSettingsListByStudentId(int studentId) {
		List<EventSettings> eventSettingsList = new ArrayList<>();
		String sql = "SELECT * FROM " + eventSettingsTable + " WHERE " + eventSettingsTable + "." + eventSettingsColEventId + " IN (SELECT " + studentEventTable + "." + studentEventColEventId + " FROM " + studentEventTable + " WHERE " + studentEventColStudentId + " = " + studentId + ")";
		try(Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				EventSettings eventSettings = new EventSettings(rs);
				eventSettingsList.add(eventSettings);
			}
			
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return eventSettingsList;
	}
	
	private List<Event> getEventListByStudentId(int studentId) {
		List<Event> eventList = new ArrayList<>();
		String sql = "SELECT * FROM " + eventTable + " WHERE " + eventTable + "." + eventColId + " IN (SELECT " + studentEventTable + "." + studentEventColEventId + " FROM " + studentEventTable + " WHERE " + studentEventColStudentId  + " = " + studentId + ")";
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				Event event = new Event(rs);
				eventList.add(event);
			}
			
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return eventList;
	}
	
	private List<Course> getCourseListByStudentId(int studentId) {
		List<Course> courseList = new ArrayList<>();
		String sql = "SELECT * FROM " + courseTable + " WHERE " + courseTable + "." + courseColId + " IN (SELECT " + studentCourseTable + "." + studentCourseColCourseId + " FROM " + studentCourseTable + " WHERE " + studentCourseColStudentId + " = " + studentId + ")";
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				Course course = new Course(rs);
				courseList.add(course);
			}
			
			rs.close();
			stmt.close();
			conn.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
		return courseList;
	}
	
	private List<Semester> getSemesterListByStudentId(int studentId) {
		List<Semester> semesterList = new ArrayList<>();
		String sql = "SELECT * FROM " + semesterTable + " WHERE " + semesterTable + "." + semesterColId + " IN (SELECT " + studentSemesterTable + "." + studentSemesterColSemesterId + " FROM " + studentSemesterTable + " WHERE " + studentSemesterColStudentId + " = " + studentId + ")";
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				Semester semester = new Semester(rs);
				semesterList.add(semester);
			}
			
			rs.close();
			stmt.close();
			conn.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
		return semesterList;
	}
	
	private List<Exam> getExamListByStudentId(int studentId) {
		List<Exam> examList = new ArrayList<>();
		String sql = "SELECT * FROM " + examsTable + " WHERE " + examsTable + "." + examsColId + " IN (SELECT " + studentExamTable + "." + studentExamColExamId + " FROM " + studentExamTable + " WHERE " + studentExamColStudentId + " = " + studentId + ")";
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				Exam exam = new Exam(rs);
				examList.add(exam);
			}
			
			rs.close();
			stmt.close();
			conn.close();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return examList;
	}
	
	public List<StudentEvent> getStudentEventListByStudentId(int studentId) {
		List<StudentEvent> studentEventList = new ArrayList<>();
		String sql = "SELECT * FROM " + studentEventTable + " WHERE " + studentEventColStudentId + " = " + studentId;
		try(Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				StudentEvent studentEvent = new StudentEvent(rs);
				studentEventList.add(studentEvent);
			}
			
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return studentEventList;
	}
	
	public List<StudentCourse> getStudentCourseListByStudentId(int studentId) {
		List<StudentCourse> studentCourseList = new ArrayList<>();
		String sql = "SELECT * FROM " + studentCourseTable + " WHERE " + studentCourseColStudentId + " = " + studentId;
		try(Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				StudentCourse studentCourse = new StudentCourse(rs);
				studentCourseList.add(studentCourse);
			}
			
			rs.close();
			stmt.close();
			conn.close();
		} catch(SQLException e) {
			e.printStackTrace();
		}
		return studentCourseList;
	}
	
	public List<StudentExam> getStudentExamListByStudentId(int studentId) {
		List<StudentExam> studentExamList = new ArrayList<>();
		String sql = "SELECT * FROM " + studentExamTable + " WHERE " + studentExamColStudentId + " = " + studentId;
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				StudentExam studentExam = new StudentExam(rs);
				studentExamList.add(studentExam);
			}
			
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return studentExamList;
	}
	
	public List<StudentSemester> getStudentSemesterListByStudentId(int studentId) {
		List<StudentSemester> studentSemesterList = new ArrayList<>();
		String sql = "SELECT * FROM " + studentSemesterTable + " WHERE " + studentSemesterColStudentId + " = " + studentId;
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			while(rs.next()) {
				StudentSemester studentSemester = new StudentSemester(rs);
				studentSemesterList.add(studentSemester);
			}
			
			rs.close();
			stmt.close();
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return studentSemesterList;
	}
	
	public boolean isLastStudentEvent(StudentEvent studentEvent) {
		Event event = getEventById(studentEvent.getEventId());
		if(event == null) {
			return false;
		}
		
		String sql = "SELECT " + eventColDate + " FROM " + eventTable + " WHERE " + eventColCourseId + " = " + event.getCourseId();
		try(Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			
			DateFormat df = new SimpleDateFormat("dd.MM.yyyy");
			Date eventDate = df.parse(event.getDate());
			
			while(rs.next()) {
				Date date = df.parse(rs.getString(eventColDate));
				System.out.println("Date: " + date);
				System.out.println("eventDate: " + eventDate);
				if(eventDate.before(date)) {
					return false;
				}
			}
			return true;
			
		} catch(SQLException | ParseException e) {
			e.printStackTrace();
		}
		
		return false;
	}
	
	public Event getEventById(int eventId) {
		String sql = "SELECT * FROM " + eventTable + " WHERE " + eventColId + " = " + eventId;
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			Event event = new Event(stmt.executeQuery(sql));
			
			stmt.close();
			conn.close();
			
			return event;
		} catch(SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	public Map<Course, Map<Event, String>> getEventStatusMap(int studentId) {
		String sql = "SELECT " + studentEventColStatus + ", " + eventTable + ".*, " + courseTable + ".* FROM " + studentEventTable + " INNER JOIN " + eventTable + " ON (" + studentEventTable + "." + studentEventColEventId + " = " + eventTable + "." + eventColId + ") INNER JOIN " + courseTable + " ON (" + courseTable + "." + courseColId + " = " + eventTable + "." + eventColCourseId + ") WHERE " + studentEventColStudentId + " = " + studentId + " AND (" + studentEventColStatus + " = 'upload' OR " + studentEventColStatus + " = 'waiting' OR " + studentEventColStatus + " = 'failed') ORDER BY " + studentEventColStatus + " DESC";
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			
			Map<Course, Map<Event, String>> eventStatusMap = new LinkedHashMap<>();
			while(rs.next()) {
				Course course = new Course(rs);
				Event event = new Event(rs);
				String status = rs.getString("status");
				Map<Event, String> eventMap = new LinkedHashMap<>();
				eventMap.putIfAbsent(event, status);
				eventStatusMap.putIfAbsent(course, eventMap);
			}
			rs.close();
			stmt.close();
			conn.close();
			return eventStatusMap;
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public Map<Course, Map<Event, Integer>> getProfEventStatusMap(int professorId) {
		String sql = "SELECT " + eventTable + ".*, " + courseTable + ".*, requests FROM " + eventTable + " INNER JOIN " + courseTable + " ON (" + courseTable + "." + courseColId + " = " + eventTable + "." + eventColCourseId + ") INNER JOIN (SELECT COUNT(*) AS requests, " + studentEventTable + "." + studentEventColEventId + " FROM " + studentEventTable + " WHERE " + studentEventTable + "." + studentEventColStatus + " = 'waiting' GROUP BY " + studentEventTable + "." + studentEventColEventId + ") " + studentEventTable + " ON (" + studentEventTable + "." + studentEventColEventId + " = " + eventTable + "." + eventColId + ") WHERE " + courseTable + "." + courseColProfessorId + " = " + professorId;
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			
			Map<Course, Map<Event, Integer>> eventStatusMap = new LinkedHashMap<>();
			while(rs.next()) {
				Course course = new Course(rs);
				Event event = new Event(rs);
				int requests = rs.getInt("requests");
				Map<Event, Integer> eventMap = new LinkedHashMap<>();
				eventMap.putIfAbsent(event, requests);
				eventStatusMap.putIfAbsent(course, eventMap);
			}
			rs.close();
			stmt.close();
			conn.close();
			return eventStatusMap;	
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public Map<Event, String> getNextEventsMap(int studentId) {
		Date now = new Date(System.currentTimeMillis());
	    String nowDate = now.toString().split(" ")[0];
	    Date week = new Date(now.getTime() + 21*24*60*60*1000);
	    String weekDate = week.toString().split(" ")[0];
		String sql = "SELECT " + eventTable + ".*, " + courseTable + "." + courseColName + " AS courseName FROM " + eventTable + " INNER JOIN " + courseTable + " ON (" + courseTable + "." + courseColId + " = " + eventTable + "." + eventColCourseId + ") WHERE " + eventColDate + " >= \"" + nowDate + "\" AND " + eventColDate + " <= \"" + weekDate + "\" AND " + eventTable + "." + eventColId + " IN (SELECT " + studentEventTable + "." + studentEventColEventId + " FROM " + studentEventTable + " WHERE " + studentEventColStudentId + " = " + studentId + " AND " + studentEventColStatus + " = \"none\") ORDER BY " + eventColDate + " ASC";
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			
			Map<Event, String> nextEventsMap = new LinkedHashMap<>();
			while(rs.next()) {
				Event event = new Event(rs);
				nextEventsMap.putIfAbsent(event, rs.getString("courseName"));
			}
			rs.close();
			stmt.close();
			conn.close();
			return nextEventsMap;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public Map<Event, String> getProfNextEventsMap(int professorId) {
		Date now = new Date(System.currentTimeMillis());
	    String nowDate = now.toString().split(" ")[0];
	    Date week = new Date(now.getTime() + 21*24*60*60*1000);
	    String weekDate = week.toString().split(" ")[0];
		String sql = "SELECT " + eventTable + ".*, " + courseTable + "." + courseColName + " AS courseName FROM " + eventTable + " INNER JOIN " + courseTable + " ON(" + courseTable + "." + courseColId + " = " + eventTable + "." + eventColCourseId + ") WHERE " + eventColDate + " >= \"" + nowDate + "\" AND " + eventColDate + " <= \"" + weekDate + "\" AND " + courseColProfessorId + " = " + professorId + " ORDER BY " + eventColDate + " ASC";
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			
			Map<Event, String> nextEventsMap = new LinkedHashMap<>();
			while(rs.next()) {
				Event event = new Event(rs);
				nextEventsMap.putIfAbsent(event, rs.getString("courseName"));
			}
			rs.close();
			stmt.close();
			conn.close();
			return nextEventsMap;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public Optional<Student> findStudentByUsername(String username) {
		String sql = String.format("SELECT * FROM %s WHERE %s = '%s'", studentTable, studentColFhIdentifier, username);
		
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
		Student student = new Student(stmt.executeQuery(sql));
		if(student.getFhIdentifier() != null) {
			student.setPassword(passwordEncoder.encode(student.getPassword()));
		} else {
			student = null;
		}
		stmt.close();
		conn.close();
		return Optional.ofNullable(student);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public Professor getLoginProfessor(String username, String password) {
		String sql = String.format("SELECT * FROM %s WHERE %s = '%s' AND %s = '%s'", professorTable, professorColFhIdentifier, username, professorColPassword, password);
		try (Connection conn = dataSource.getConnection()) {
		Statement stmt = conn.createStatement();
		
				
		Professor professor = new Professor(stmt.executeQuery(sql));
		
		stmt.close();
		conn.close();
		return professor;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public Optional<Professor> findProfessorByUsername(String username) {
		String sql = String.format("SELECT * FROM %s WHERE %s = '%s'", professorTable, professorColFhIdentifier, username);
		
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
		Professor professor = new Professor(stmt.executeQuery(sql));
		if(professor.getFhIdentifier() != null) {
			professor.setPassword(passwordEncoder.encode(professor.getPassword()));
		} else {
			professor = null;
		}
		stmt.close();
		conn.close();
		return Optional.ofNullable(professor);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public int getProfessorIdByEventId(int eventId) {
		String sql = "SELECT " + courseTable + "." + courseColProfessorId + " FROM " + courseTable + " WHERE " + courseTable + "." + courseColId + " IN (SELECT " + eventTable + "." + eventColCourseId + " FROM " + eventTable + " WHERE " + eventColId + " = " + eventId + ")";
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			if(rs.isAfterLast()) {
				rs.close();
				stmt.close();
				conn.close();
				return -1;
			}
			int professorId = rs.getInt("professorId");
			rs.close();
			stmt.close();
			conn.close();
			return professorId;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int getProfessorIdByExamId(int examId) {
		String sql = "SELECT " + examsColProfessorId + " FROM " + examsTable + " WHERE " + examsColId + " = " + examId;
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			
			ResultSet rs = stmt.executeQuery(sql);
			if(rs.isAfterLast()) {
				rs.close();
				stmt.close();
				conn.close();
				return -1;
			}
			int professorId = rs.getInt("professorId");
			rs.close();
			stmt.close();
			conn.close();
			return professorId;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public boolean updateStudentExam(StudentExam studentExam) {
		String sql = "UPDATE " + studentExamTable + " SET " + studentExamColStatus + " = '" + studentExam.getStatus() + "' WHERE " + studentExamColStudentId + " = " + studentExam.getStudentId() + " AND " + studentExamColExamId + " = " + studentExam.getExamId();
		try (Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			int id = stmt.executeUpdate(sql);
			
			stmt.close();
			conn.close();
			if (id != 1) {
				return false;
			}
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean updateEventSettings(EventSettings eventSettings) {
		String sql = "UPDATE " + eventSettingsTable + " SET " + eventSettingsColNeedUpload + " = '" + eventSettings.isNeedUpload() + "', " + eventSettingsColAutoComplete + " = '" + eventSettings.isAutoComplete() + "', " + eventSettingsColNotifications + " = '" + eventSettings.isNotifications() + "' WHERE " + eventSettingsColProfessorId + " = " + eventSettings.getProfessorId() + " AND " + eventSettingsColEventId + " = " + eventSettings.getEventId();
		try(Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			int id = stmt.executeUpdate(sql);
			
			stmt.close();
			conn.close();
			
			if(id != 1) {
				return false;
			}
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean updateStudentEvent(StudentEvent studentEvent) {
		String sql = "UPDATE " + studentEventTable + " SET " + studentEventColProfessorId + " = " + studentEvent.getProfessorId() + ", " + studentEventColDate + " = '" + studentEvent.getDate() + "', " + studentEventColTime + " = '" + studentEvent.getTime() + "', " + studentEventColStatus + " = '" + studentEvent.getStatus() + "' WHERE " + studentEventColStudentId + " = " + studentEvent.getStudentId() + " AND " + studentEventColEventId + " = " + studentEvent.getEventId();
		try(Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			int id = stmt.executeUpdate(sql);
			
			stmt.close();
			conn.close();
			
			if(id != 1) {
				return false;
			}
			
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public long insertFileUpload(FileUpload fileUpload) {
		String sql = "INSERT INTO " + tempUploadedFileTable  + " (" + fileUploadColEventId + ", " + fileUploadColStudentId + ", " + fileUploadColFileName + ", " + fileUploadColUploadTime + ", " + fileUploadColFileType + ", " + fileUploadColSize + ") VALUES (" + fileUpload.getEventId() + ", " + fileUpload.getStudentId() + ", '" + fileUpload.getFileName() + "', '" + fileUpload.getUploadTime() + "', '" + fileUpload.getFileType() + "', " + fileUpload.getSize() + ")";
		try(Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			stmt.executeUpdate(sql);
			long id = stmt.getGeneratedKeys().getLong(1);
			System.out.println("fileId: " + id);
			
			stmt.close();
			conn.close();
			
			return id;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	public void deleteFileUpload(int eventId, int studentId) {
		String sql = "DELETE FROM " + tempUploadedFileTable + " WHERE " + fileUploadColEventId + " = " + eventId + " AND " + fileUploadColStudentId + " = " + studentId;
		try(Connection conn = dataSource.getConnection()) {
			Statement stmt = conn.createStatement();
			stmt.executeUpdate(sql);
			
			stmt.close();
			conn.close();
		
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
