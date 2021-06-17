package com.example.restservice.response;

import com.example.restservice.entities.StudentExam;

public class StudentExamResponse {
	StudentExam studentExam;
	
	public StudentExamResponse(StudentExam studentExam) {
		this.studentExam = studentExam;
	}

	public StudentExam getStudentExam() {
		return studentExam;
	}

	public void setStudentExam(StudentExam studentExam) {
		this.studentExam = studentExam;
	}
	
}
