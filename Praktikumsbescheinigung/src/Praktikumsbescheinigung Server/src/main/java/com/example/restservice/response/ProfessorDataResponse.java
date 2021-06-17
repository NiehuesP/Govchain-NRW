package com.example.restservice.response;


import java.util.ArrayList;
import java.util.List;

import com.example.restservice.entities.Course;
import com.example.restservice.entities.Event;
import com.example.restservice.entities.EventSettings;
import com.example.restservice.entities.Exam;
import com.example.restservice.entities.FileUpload;
import com.example.restservice.entities.Semester;
import com.example.restservice.entities.Student;
import com.example.restservice.entities.StudentCourse;
import com.example.restservice.entities.StudentEvent;
import com.example.restservice.entities.StudentExam;

public class ProfessorDataResponse {
	List<Student> studentList = new ArrayList<>();
	List<Semester> semesterList = new ArrayList<>();
	List<Course> courseList = new ArrayList<>();
	List<Event> eventList = new ArrayList<>();
	List<StudentCourse> studentCourseList = new ArrayList<>(); 
	List<StudentEvent> studentEventList = new ArrayList<>();
	List<Exam> examList = new ArrayList<>();
	List<StudentExam> studentExamList = new ArrayList<>();
	List<EventSettings> eventSettingsList = new ArrayList<>();
	List<FileUpload> fileUploadList = new ArrayList<>();
	
	public ProfessorDataResponse(List<Student> studentList, List<Semester> semesterList, List<Course> courseList, List<Event> eventList, List<StudentCourse> studentCourseList, List<StudentEvent> studentEventList, List<Exam> examList, List<StudentExam> studentExamList, List<EventSettings> eventSettingsList, List<FileUpload> fileUploadList) {
		this.studentList = studentList;
		this.semesterList = semesterList;
		this.courseList = courseList;
		this.eventList = eventList;
		this.studentCourseList = studentCourseList;
		this.studentEventList = studentEventList;
		this.examList = examList;
		this.studentExamList = studentExamList;
		this.eventSettingsList = eventSettingsList;
		this.fileUploadList = fileUploadList;
	}
	
	public List<Student> getStudentList() {
		return studentList;
	}
	public void setStudentList(List<Student> studentList) {
		this.studentList = studentList;
	}
	public List<Semester> getSemesterList() {
		return semesterList;
	}
	public void setSemesterList(List<Semester> semesterList) {
		this.semesterList = semesterList;
	}
	public List<Course> getCourseList() {
		return courseList;
	}
	public void setCourseList(List<Course> courseList) {
		this.courseList = courseList;
	}
	public List<Event> getEventList() {
		return eventList;
	}
	public void setEventList(List<Event> eventList) {
		this.eventList = eventList;
	}
	public List<StudentCourse> getStudentCourseList() {
		return studentCourseList;
	}
	public void setStudentCourseList(List<StudentCourse> studentCourseList) {
		this.studentCourseList = studentCourseList;
	}
	public List<StudentEvent> getStudentEventList() {
		return studentEventList;
	}
	public void setStudentEventList(List<StudentEvent> studentEventList) {
		this.studentEventList = studentEventList;
	}
	
	public List<Exam> getExamList() {
		return examList;
	}
	public void setExamList(List<Exam> examList) {
		this.examList = examList;
	}
	public List<StudentExam> getStudentExamList() {
		return studentExamList;
	}
	public void setStudentExamList(List<StudentExam> studentExamList) {
		this.studentExamList = studentExamList;
	}

	public List<EventSettings> getEventSettingsList() {
		return eventSettingsList;
	}

	public void setEventSettingsList(List<EventSettings> eventSettingsList) {
		this.eventSettingsList = eventSettingsList;
	}
	
	public List<FileUpload> getFileUploadList() {
		return fileUploadList;
	} 
	
	public void setFileUploadList(List<FileUpload> fileUploadList) {
		this.fileUploadList = fileUploadList;
	}
	
}
