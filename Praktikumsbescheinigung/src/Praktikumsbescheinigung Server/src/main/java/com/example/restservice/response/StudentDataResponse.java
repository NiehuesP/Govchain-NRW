package com.example.restservice.response;


import java.util.ArrayList;
import java.util.List;

import com.example.restservice.entities.Course;
import com.example.restservice.entities.Event;
import com.example.restservice.entities.EventSettings;
import com.example.restservice.entities.Exam;
import com.example.restservice.entities.FileUpload;
import com.example.restservice.entities.Professor;
import com.example.restservice.entities.Semester;
import com.example.restservice.entities.StudentCourse;
import com.example.restservice.entities.StudentEvent;
import com.example.restservice.entities.StudentExam;
import com.example.restservice.entities.StudentSemester;

public class StudentDataResponse {
	List<Professor> professorList = new ArrayList<>();
	List<Semester> semesterList = new ArrayList<>();
	List<Course> courseList = new ArrayList<>();
	List<Event> eventList = new ArrayList<>();
	List<StudentCourse> studentCourseList = new ArrayList<>(); 
	List<StudentEvent> studentEventList = new ArrayList<>();
	List<StudentSemester> studentSemesterList = new ArrayList<>();
	List<Exam> examList = new ArrayList<>();
	List<StudentExam> studentExamList = new ArrayList<>();
	List<FileUpload> fileUploadList = new ArrayList<>();
	List<EventSettings> eventSettingsList = new ArrayList<>();
	
	public StudentDataResponse(List<Professor> professorList, List<Semester> semesterList, List<Course> courseList, List<Event> eventList, List<StudentCourse> studentCourseList, List<StudentEvent> studentEventList, List<StudentSemester> studentSemesterList, List<Exam> examList, List<StudentExam> studentExamList, List<FileUpload> fileUploadList, List<EventSettings> eventSettingsList) {
		this.professorList = professorList;
		this.semesterList = semesterList;
		this.courseList = courseList;
		this.eventList = eventList;
		this.studentCourseList = studentCourseList;
		this.studentEventList = studentEventList;
		this.studentSemesterList = studentSemesterList;
		this.examList = examList;
		this.studentExamList = studentExamList;
		this.fileUploadList = fileUploadList;
		this.eventSettingsList = eventSettingsList;
	}
	
	public List<Professor> getProfessorList() {
		return professorList;
	}
	public void setProfessorList(List<Professor> professorList) {
		this.professorList = professorList;
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
	public List<StudentSemester> getStudentSemesterList() {
		return studentSemesterList;
	}
	public void setStudentSemesterList(List<StudentSemester> studentSemesterList) {
		this.studentSemesterList = studentSemesterList;
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
	
	public List<FileUpload> getFileUploadList() {
		return fileUploadList;
	}
	
	public void setFileUploadList(List<FileUpload> fileUploadList) {
		this.fileUploadList = fileUploadList;
	}
	
	public List<EventSettings> getEventSettingsList() {
		return eventSettingsList;
	}
	
	public void setEventSettingsList(List<EventSettings> eventSettingsList) {
		this.eventSettingsList = eventSettingsList;
	}
}
