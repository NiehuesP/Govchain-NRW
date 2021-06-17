package com.example.restservice.entities;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonValue;

@Entity
@Table(name="exams")
public class Exam implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int examId;
	
	private int courseId;
	private String date;
	private String time;
	private String room;
	private int professorId;
	
	public Exam() {}
	
	public int getExamId() {
		return examId;
	}
	public void setExamId(int examId) {
		this.examId = examId;
	}
	public int getCourseId() {
		return courseId;
	}
	public void setCourseId(int courseId) {
		this.courseId = courseId;
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
	public String getRoom() {
		return room;
	}
	public void setRoom(String room) {
		this.room = room;
	}
	public int getProfessorId() {
		return professorId;
	}
	public void setProfessorId(int professorId) {
		this.professorId = professorId;
	}
	
	public Exam(ResultSet rs) {
		try {
			if(!rs.isAfterLast()) {
			this.examId = rs.getInt("examId");
			this.courseId = rs.getInt("courseId");
			this.date = rs.getString("date");
			this.time = rs.getString("time");
			this.room = rs.getString("room");
			this.professorId = rs.getInt("professorId");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@JsonValue
	public String info() {
		return "{" + 
	"\"examId\": " + this.examId +
	", \"courseId\": " + this.courseId +
	", \"date\": \"" + this.date +
	"\", \"time\": \"" + this.time + 
	"\", \"room\": \"" + this.room +
	"\", \"professorId\": " + this.professorId +
	"}";
	
	}

}
