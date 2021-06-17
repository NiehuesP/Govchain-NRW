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
@Table(name="professors")
public class Professor implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	private int professorId;
	
	private String firstName;
	private String lastName;
	private String title;
	private String fhIdentifier;
	private String password;
	
	public Professor() {}
	
	public int getProfessorId() {
		return professorId;
	}
	public void setProfessorId(int professorId) {
		this.professorId = professorId;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getFhIdentifier() {
		return fhIdentifier;
	}
	public void setFhIdentifier(String fhIdentifier) {
		this.fhIdentifier = fhIdentifier;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	
	public Professor(ResultSet rs) {
		try {
			if(!rs.isAfterLast()) {
			this.professorId = rs.getInt("professorId");
			this.firstName = rs.getString("firstName");
			this.lastName = rs.getString("lastName");
			this.title = rs.getString("title");
			this.fhIdentifier = rs.getString("fhIdentifier");
			this.password = rs.getString("password");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public Professor(ResultSet rs, boolean priv) {
		try {
			if(!rs.isAfterLast()) {
				this.professorId = rs.getInt("professorId");
				this.firstName = rs.getString("firstName");
				this.lastName = rs.getString("lastName");
				this.title = rs.getString("title");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@JsonValue
	public String info() {
		return "{" + 
	"\"professorId\": " + this.professorId +
	", \"firstName\": \"" + this.firstName +
	"\", \"lastName\": \"" + this.lastName + 
	"\", \"title\": \"" + this.title +
	"\", \"fhIdentifier\": \"" + this.fhIdentifier +
	"\", \"password\": \"" + this.password +
	"\"}";
	
	}

}
