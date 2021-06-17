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
@Table(name = "students")
public class Student implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int studentId;
	
	private String firstName;
	private String lastName;
	private int matriculation;
	private String dateOfBirth;
	private String university;
	private String faculty;
	private String field;
	private String degree;
	private String fhIdentifier;
	private String password;
	
	public Student() {}

	public int getStudentId() {
		return studentId;
	}

	public void setStudentId(int studentId) {
		this.studentId = studentId;
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

	public int getMatriculation() {
		return matriculation;
	}

	public void setMatriculation(int matriculation) {
		this.matriculation = matriculation;
	}

	public String getDateOfBirth() {
		return dateOfBirth;
	}

	public void setDateOfBirth(String dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}

	public String getUniversity() {
		return university;
	}

	public void setUniversity(String university) {
		this.university = university;
	}

	public String getFaculty() {
		return faculty;
	}

	public void setFaculty(String faculty) {
		this.faculty = faculty;
	}

	public String getField() {
		return field;
	}

	public void setField(String field) {
		this.field = field;
	}

	public String getDegree() {
		return degree;
	}

	public void setDegree(String degree) {
		this.degree = degree;
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
	
	public Student(ResultSet rs) {
		try {
			if(!rs.isAfterLast()) {
			this.studentId = rs.getInt("studentId");
			this.firstName = rs.getString("firstName");
			this.lastName = rs.getString("firstName");
			this.matriculation = rs.getInt("matriculation");
			this.dateOfBirth = rs.getString("dateOfBirth");
			this.university = rs.getString("university");
			this.faculty = rs.getString("faculty");
			this.field = rs.getString("field");
			this.degree = rs.getString("degree");
			this.fhIdentifier = rs.getString("fhIdentifier");
			this.password = rs.getString("password");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	} 
	
	public Student(ResultSet rs, boolean priv) {
		try {
			if(!rs.isAfterLast()) {
				this.studentId = rs.getInt("studentId");
				this.firstName = rs.getString("firstName");
				this.lastName = rs.getString("lastName");
				this.matriculation = rs.getInt("matriculation");
				this.fhIdentifier = rs.getString("fhIdentifier");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@JsonValue
	public String info() {
		return "{" + 
	"\"studentId\": " + this.studentId +
	", \"firstName\": \"" + this.firstName +
	"\", \"lastName\": \"" + this.lastName + 
	"\", \"matriculation\": " + this.matriculation +
	", \"dateOfBirth\": \"" + this.dateOfBirth +
	"\", \"university\": \"" + this.university + 
	"\", \"faculty\": \"" + this.faculty + 
	"\", \"field\": \"" + this.field + 
	"\", \"degree\": \"" + this.degree + 
	"\", \"fhIdentifier\": \"" + this.fhIdentifier + 
	"\", \"password\": \"" + this.password + 
	"\"}";
	
	}
	
}
