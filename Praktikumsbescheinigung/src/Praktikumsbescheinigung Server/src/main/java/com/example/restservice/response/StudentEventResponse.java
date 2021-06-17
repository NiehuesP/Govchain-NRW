package com.example.restservice.response;

import com.example.restservice.entities.StudentEvent;

public class StudentEventResponse {
	StudentEvent studentEvent;
	
	public StudentEventResponse(StudentEvent studentEvent) {
		this.studentEvent = studentEvent;
	}

	public StudentEvent getStudentEvent() {
		return studentEvent;
	}

	public void setStudentEvent(StudentEvent studentEvent) {
		this.studentEvent = studentEvent;
	}
	
}
