package com.example.restservice.entities;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonValue;

@Entity
@Table(name="studentExams")
public class StudentExam implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	private int studentId;
	
	@Id
	private int examId;
	
	private String status;
	
	public StudentExam() {}

	public int getStudentId() {
		return studentId;
	}

	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}

	public int getExamId() {
		return examId;
	}

	public void setExamId(int examId) {
		this.examId = examId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	public StudentExam(ResultSet rs) {
		try {
			if(!rs.isAfterLast()) {
			this.studentId = rs.getInt("studentId");
			this.examId = rs.getInt("examId");
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
	", \"examId\": " + this.examId +
	", \"status\": \"" + this.status + 
	"\"}";
	
	}
	
}
