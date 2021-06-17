package com.example.restservice.response;

import com.example.restservice.entities.Professor;
import com.example.restservice.entities.Student;

public class JwtTokenResponse {
	private String token;
	private Student student;
	private Professor professor;
	
	public JwtTokenResponse(String token, Student student) {
		this.token = token;
		this.student = student;
	}
	
	public JwtTokenResponse(String token, Professor professor) {
		this.token = token;
		this.professor = professor;
	}
	
	public String getToken() {
		return token;
	}
	
	public void setToken(String token) {
		this.token = token;
	}
	
	public Student getStudent() {
		return student;
	}
	
	public void setStudent(Student student) {
		this.student = student;
	}
	
	public Professor getProfessor() {
		return professor;
	}
	
	public void setProfessor(Professor professor) {
		this.professor = professor;
	}
}
