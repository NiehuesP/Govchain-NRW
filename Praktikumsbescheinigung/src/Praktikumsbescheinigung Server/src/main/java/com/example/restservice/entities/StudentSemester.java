package com.example.restservice.entities;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonValue;

@Entity
@Table(name="studentSemesters")
public class StudentSemester implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	private int studentId;
	
	@Id
	private int semesterId;
	
	public StudentSemester() {}

	public int getStudentId() {
		return studentId;
	}

	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}

	public int getSemesterId() {
		return semesterId;
	}

	public void setSemesterId(int semesterId) {
		this.semesterId = semesterId;
	}
	
	public StudentSemester(ResultSet rs) {
		try {
			if(!rs.isAfterLast()) {
			this.studentId = rs.getInt("studentId");
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
	", \"semesterId\": " + this.semesterId +
	"}";
	
	}

}
