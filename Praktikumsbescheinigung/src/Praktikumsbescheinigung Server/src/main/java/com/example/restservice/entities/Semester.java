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
@Table(name = "semesters")
public class Semester implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int semesterId;
	
	private String name;
	private String startDate;
	private String endDate;
	
	public Semester() {}
	
	public int getSemesterId() {
		return semesterId;
	}
	public void setSemesterId(int semesterId) {
		this.semesterId = semesterId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	
	public Semester(ResultSet rs) {
		try {
			if(!rs.isAfterLast()) {
			this.semesterId = rs.getInt("semesterId");
			this.name = rs.getString("name");
			this.startDate = rs.getString("startDate");
			this.endDate = rs.getString("endDate");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@JsonValue
	public String info() {
		return "{" + 
	"\"semesterId\": " + this.semesterId +
	", \"name\": \"" + this.name +
	"\", \"startDate\": \"" + this.startDate + 
	"\", \"endDate\": \"" + this.endDate +
	"\"}";
	
	}

}
