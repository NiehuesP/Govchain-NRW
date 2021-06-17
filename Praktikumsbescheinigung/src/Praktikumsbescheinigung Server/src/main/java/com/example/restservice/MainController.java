package com.example.restservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.restservice.entities.EventSettings;
import com.example.restservice.entities.StudentEvent;
import com.example.restservice.entities.StudentExam;
import com.example.restservice.exception.BadRequestException;
import com.example.restservice.exception.EntityNotFoundException;
import com.example.restservice.response.EventSettingsResponse;
import com.example.restservice.response.LastEventResponse;
import com.example.restservice.response.ProfessorDataResponse;
import com.example.restservice.response.StudentDataResponse;
import com.example.restservice.response.StudentEventResponse;
import com.example.restservice.response.StudentExamResponse;
import com.example.restservice.service.DatabaseService;

@RestController
@RequestMapping
public class MainController {
	
	@Autowired
	DatabaseService databaseService;
	
	@Autowired
	private SimpMessagingTemplate webSocket;
	
	@GetMapping("/main/s")
	public ResponseEntity<StudentDataResponse> getMainStudentData(@RequestParam(value="studentId", defaultValue="-1") int studentId) {
		if(studentId != -1) {
			return new ResponseEntity<>(databaseService.getAllDataForStudent(studentId), HttpStatus.OK);
		} else {
			throw new BadRequestException("No student id specified");
		}
		
	}
	
	@GetMapping("/main/p")
	public ResponseEntity<ProfessorDataResponse> getMainProfessorData(@RequestParam(value="professorId", defaultValue="-1") int professorId) {
		if(professorId != -1) {
			return new ResponseEntity<>(databaseService.getAllDataForProfessor(professorId), HttpStatus.OK);
		} else {
			throw new BadRequestException("No professor id specified");
		}
		
	}
	
	@PostMapping("/main/eventSettings")
	public ResponseEntity<String> updateEventSettings(@RequestBody EventSettings eventSettings) {
		if(eventSettings == null) {
			throw new BadRequestException("No EventSettings sent");
		} 
		if(databaseService.updateEventSettings(eventSettings)) {
			int professorId = databaseService.getProfessorIdByEventId(eventSettings.getEventId());
			
			if(eventSettings.getProfessorId() == null || eventSettings.getProfessorId() == professorId) {
				String professorDestination = "/topic/professorData/" + professorId;
				webSocket.convertAndSend(professorDestination, new ResponseEntity<>(new EventSettingsResponse(eventSettings), HttpStatus.OK));
			} else {
				if(professorId != -1) {
					String professorDestination = "/topic/professorData/" + professorId;
					webSocket.convertAndSend(professorDestination, new ResponseEntity<>(new EventSettingsResponse(eventSettings), HttpStatus.OK));
				}
				String professorDestination = "/topic/professorData/" + eventSettings.getProfessorId();
				webSocket.convertAndSend(professorDestination, new ResponseEntity<>(new EventSettingsResponse(eventSettings), HttpStatus.OK));
			}
			
			return new ResponseEntity<>("EventSettings successfully updated", HttpStatus.OK);
		}
		
		return new ResponseEntity<>("EventSettings were up to date", HttpStatus.OK);
	}
	
	@PostMapping("/main/studentExam")
	public ResponseEntity<String> updateStudentEvent(@RequestBody StudentExam studentExam) {
		if(studentExam == null) {
			throw new BadRequestException("No StudentExam sent");
		}
		if(databaseService.updateStudentExam(studentExam)) {
			int professorId = databaseService.getProfessorIdByExamId(studentExam.getExamId());
			
			if(professorId != -1) {
				String professorDestination = "/topic/professorData/" + professorId;
				webSocket.convertAndSend(professorDestination, new ResponseEntity<>(new StudentExamResponse(studentExam), HttpStatus.OK));
			}
			
			return new ResponseEntity<>("StudentExam successfully updated", HttpStatus.OK);
		}
		
		return new ResponseEntity<>("StudentExam was up to date", HttpStatus.OK);
	}
	
	@PostMapping("/main/studentEvent")
	public ResponseEntity<LastEventResponse> updateStudentEvent(@RequestBody StudentEvent studentEvent) {
		if(studentEvent == null) {
			throw new BadRequestException("No StudentEvent sent");
		}
		if(databaseService.updateStudentEvent(studentEvent)) {
			if(studentEvent.getStatus().equals("failed")) {
				databaseService.deleteFileUpload(studentEvent.getEventId(), studentEvent.getStudentId());
			}
			String studentDestination = "/topic/studentData/" + studentEvent.getStudentId();
			webSocket.convertAndSend(studentDestination, new ResponseEntity<>(new StudentEventResponse(studentEvent), HttpStatus.OK));
			
			int professorId = databaseService.getProfessorIdByEventId(studentEvent.getEventId());
			
			if(studentEvent.getProfessorId() == null || studentEvent.getProfessorId() == professorId) {
				String professorDestination = "/topic/professorData/" + professorId;
				webSocket.convertAndSend(professorDestination, new ResponseEntity<>(new StudentEventResponse(studentEvent), HttpStatus.OK));
			} else {
				if(professorId != -1) {
					String professorDestination = "/topic/professorData/" + professorId;
					webSocket.convertAndSend(professorDestination, new ResponseEntity<>(new StudentEventResponse(studentEvent), HttpStatus.OK));
				}
				String professorDestination = "/topic/professorData/" + studentEvent.getProfessorId();
				webSocket.convertAndSend(professorDestination, new ResponseEntity<>(new StudentEventResponse(studentEvent), HttpStatus.OK));
			}
			
			if(databaseService.isLastStudentEvent(studentEvent)) {
				return new ResponseEntity<>(new LastEventResponse("StudentEvent successfully updated", true), HttpStatus.OK);
			}
			
			return new ResponseEntity<>(new LastEventResponse("StudentEvent successfully updated", false), HttpStatus.OK);
		}
		
		return new ResponseEntity<>(new LastEventResponse("StudentEvent was up to date", false), HttpStatus.OK);
	}
		
	@ExceptionHandler(BadRequestException.class)
	public ResponseEntity<String> handleBadRequestException(BadRequestException ex) {
		return new ResponseEntity<>(ex.getMessage(), HttpStatus.BAD_REQUEST);
	}
	
	
	@ExceptionHandler(EntityNotFoundException.class)
	public ResponseEntity<String> handleEntityNotFoundException(EntityNotFoundException ex) {
		return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_FOUND);
	}
	
}
