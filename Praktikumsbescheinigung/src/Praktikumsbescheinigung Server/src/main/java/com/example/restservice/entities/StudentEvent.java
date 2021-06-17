package com.example.restservice.entities;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonValue;

@Entity
@Table(name="studentEvents")
public class StudentEvent implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	private int studentId;
	
	@Id
	private int eventId;
	
	private Integer professorId;
	private String date;
	private String time;
	private String status;
	
	public StudentEvent() {}
	
	public int getStudentId() {
		return studentId;
	}
	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}
	public int getEventId() {
		return eventId;
	}
	public void setEventId(int eventId) {
		this.eventId = eventId;
	}
	public Integer getProfessorId() {
		return professorId;
	}
	public void setProfessorId(Integer professorId) {
		this.professorId = professorId;
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
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	public StudentEvent(ResultSet rs) {
		try {
			if(!rs.isAfterLast()) {
			this.studentId = rs.getInt("studentId");
			this.eventId = rs.getInt("eventId");
			this.professorId = rs.getInt("professorId");
			this.date = rs.getString("date");
			this.time = rs.getString("time");
			this.status = rs.getString("status");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@JsonValue
	public String info() {
		return "{" + 
	"\"studentId\": " + this.studentId +
	", \"eventId\": " + this.eventId +
	", \"professorId\": " + this.professorId + 
	", \"date\": \"" + this.date + 
	"\", \"time\": \"" + this.time + 
	"\", \"status\": \"" + this.status + 
	"\"}";
	
	}
	
}
