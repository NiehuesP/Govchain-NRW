package com.example.restservice;

import java.io.IOException;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.example.restservice.entities.FileUpload;
import com.example.restservice.response.FileUploadResponse;
import com.example.restservice.service.DatabaseService;
import com.example.restservice.service.FileStorageService;

@RestController
public class FileController {
	
	@Autowired
	FileStorageService fileStorageService;
	
	@Autowired
	DatabaseService databaseService;
	
	@Autowired
	private SimpMessagingTemplate webSocket;
	
	@PostMapping("/uploadFile/{eventId}/{studentId}")
	public ResponseEntity<String> uploadFile(@RequestParam("file") MultipartFile file, @PathVariable int eventId, @PathVariable int studentId) {
		String fileName = fileStorageService.storeFile(file, eventId, studentId);
		System.out.println("File name: " + fileName);
		
		FileUpload fileUpload = new FileUpload();
		fileUpload.setEventId(eventId);
		fileUpload.setStudentId(studentId);
		fileUpload.setFileName(fileName);
		String time = ZonedDateTime.now().format( DateTimeFormatter.ISO_INSTANT );
		fileUpload.setUploadTime(time);
		fileUpload.setFileType(file.getContentType());
		fileUpload.setSize(file.getSize());
		long id = databaseService.insertFileUpload(fileUpload);
		if(id != 0) {
			fileUpload.setFileId(id);
		String studentDestination = "/topic/studentData/" + studentId;
		webSocket.convertAndSend(studentDestination, new ResponseEntity<>(new FileUploadResponse(fileUpload), HttpStatus.OK));
		
		int professorId = databaseService.getProfessorIdByEventId(eventId);
		
		
			if(professorId != -1) {
				String professorDestination = "/topic/professorData/" + professorId;
				webSocket.convertAndSend(professorDestination, new ResponseEntity<>(new FileUploadResponse(fileUpload), HttpStatus.OK));
			}
		}
		
		return new ResponseEntity<>("File successfully uploaded", HttpStatus.OK);
	}
	
	@PostMapping("/uploadMultipleFiles/{eventId}/{studentId}")
	public ResponseEntity<String> uploadMultipleFiles(@RequestParam("files") MultipartFile[] files, @PathVariable int eventId, @PathVariable int studentId) {
		Arrays.asList(files)
				.stream()
				.forEach(file -> {
					System.out.println(file.getOriginalFilename());
					uploadFile(file, eventId, studentId);
					
				});
		return new ResponseEntity<>("Files sucessfully uploaded", HttpStatus.OK);
				
	}
	
	@PostMapping("uploadCertificate/{courseId}/{studentId}")
	public ResponseEntity<String> uploadCertificate(@RequestParam("file") MultipartFile file, @PathVariable int courseId, @PathVariable int studentId) {
		String fileName = fileStorageService.storeCertificate(file, courseId, studentId);
		String studentDestionation = "/topic/studentData/" + studentId;
		webSocket.convertAndSend(studentDestionation, new ResponseEntity<>("Certificate ready! " + fileName, HttpStatus.OK));
		
		return new ResponseEntity<>("Certificate successfully uploaded", HttpStatus.OK);
	}
	
	@GetMapping("/downloadFile/{eventId}/{studentId}/{fileName:.+}")
	public ResponseEntity<Resource> downloadFile(@PathVariable int eventId, @PathVariable int studentId, @PathVariable String fileName, HttpServletRequest request) {
		Resource resource = fileStorageService.loadFileAsResource(eventId + "/" + studentId + "/" + fileName);
		System.out.println("test");
		
		String contentType = null;
		Long contentLength = null;
		try {
			System.out.println(resource.contentLength());
			System.out.println(resource.isReadable());
			contentType = request.getServletContext().getMimeType(resource.getFile().getAbsolutePath());
			contentLength = resource.getFile().length();
			System.out.println(contentType);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		if(contentType == null) {
			contentType = "application/octet-stream";
		}
		
		return ResponseEntity.ok()
				.contentType(MediaType.parseMediaType(contentType))
				.contentLength(contentLength)
				.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filname=\"" + resource.getFilename() + "\"")
				.body(resource);
	}
	
	@GetMapping("downloadCertificate/{courseId}/{studentId}/{fileName:.+}")
	public ResponseEntity<Resource> downloadCertificate(@PathVariable int courseId, @PathVariable int studentId, @PathVariable String fileName, HttpServletRequest request) {
		Resource resource = fileStorageService.loadCertificateAsResource(courseId + "/" + studentId + "/" + fileName);
		
		String contentType = null;
		Long contentLength = null;
		try {
			contentType = request.getServletContext().getMimeType(resource.getFile().getAbsolutePath());
			contentLength = resource.getFile().length();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		if(contentType == null) {
			contentType = "application/octet-stream";
		}
		
		return ResponseEntity.ok()
				.contentType(MediaType.parseMediaType(contentType))
				.contentLength(contentLength)
				.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + resource.getFilename() + "\"")
				.body(resource);
	}

}
