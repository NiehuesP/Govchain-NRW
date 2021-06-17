package com.example.restservice;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;


@Controller
public class SocketController {

	@MessageMapping("/studentData/{studentId}")
	@SendTo("/topic/studentData/{studentId}")
	public void studentData(@DestinationVariable int studentId) throws Exception {
		System.out.println("WebSocket hit student: " + studentId);
	}
	
	@MessageMapping("/professorData/{professorId}")
	@SendTo("/topic/professorData/{professorId}")
	public void professorData(@DestinationVariable int professorId) throws Exception {
		System.out.println("WebSocket hit prof: " + professorId);
	}
}
