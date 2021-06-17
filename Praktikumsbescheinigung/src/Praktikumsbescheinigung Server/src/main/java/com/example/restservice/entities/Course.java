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
@Table(name = "courses")
public class Course implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int courseId;
	
	private String name;
	private String shortName;
	private int semesterId;
	private int professorId;
	
	public Course() {}

	public int getCourseId() {
		return courseId;
	}

	public void setCourseId(int courseId) {
		this.courseId = courseId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getShortName() {
		return shortName;
	}

	public void setShortName(String shortName) {
		this.shortName = shortName;
	}

	public int getSemesterId() {
		return semesterId;
	}

	public void setSemesterId(int semesterId) {
		this.semesterId = semesterId;
	}

	public int getProfessorId() {
		return professorId;
	}

	public void setProfessorId(int professorId) {
		this.professorId = professorId;
	}
	
	public Course(ResultSet rs) {
		try {
			if(!rs.isAfterLast()) {
			this.courseId = rs.getInt("courseId");
			this.name = rs.getString("name");
			this.shortName = rs.getString("shortName");
			this.semesterId = rs.getInt("semesterId");
			this.professorId = rs.getInt("professorId");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@JsonValue
	public String info() {
		
		return"{" +
	" \"courseId\": " + this.courseId +
	", \"name\": \"" + this.name +
	"\", \"shortName\": \"" + this.shortName + 
	"\", \"semesterId\": " + this.semesterId +
	", \"professorId\": " + this.professorId + 
	"}";
		
	}
}
