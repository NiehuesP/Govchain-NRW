package com.example.restservice.entities;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonValue;

@Entity
@Table(name="studentCourses")
public class StudentCourse implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	private int studentId;
	
	@Id
	private int courseId;
	
	private String completed;
	private String date;
	private String time;
	private int professorId;
	private int semesterId;
	
	public StudentCourse() {}
	
	public int getStudentId() {
		return studentId;
	}
	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}
	public int getCourseId() {
		return courseId;
	}
	public void setCourseId(int courseId) {
		this.courseId = courseId;
	}
	public String getCompleted() {
		return completed;
	}
	public void setCompleted(String completed) {
		this.completed = completed;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public int getProfessorId() {
		return professorId;
	}
	public void setProfessorId(int professorId) {
		this.professorId = professorId;
	}
	public int getSemesterId() {
		return semesterId;
	}
	public void setSemesterId(int semesterId) {
		this.semesterId = semesterId;
	}
	
	public StudentCourse(ResultSet rs) {
		try {
			if(!rs.isAfterLast()) {
			this.studentId = rs.getInt("studentId");
			this.courseId = rs.getInt("courseId");
			this.completed = rs.getString("completed");
			this.date = rs.getString("date");
			this.time = rs.getString("time");
			this.professorId = rs.getInt("professorId");
			this.semesterId = rs.getInt("semesterId");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@JsonValue
	public String info() {
		return "{" + 
	"\"studentId\": " + this.studentId +
	", \"courseId\": " + this.courseId +
	", \"completed\": \"" + this.completed + 
	"\", \"date\": \"" + this.date + 
	"\", \"time\": \"" + this.time + 
	"\", \"professorId\": " + this.professorId + 
	", \"semesterId\": " + this.semesterId + 
	"}";
	
	}
	
}
