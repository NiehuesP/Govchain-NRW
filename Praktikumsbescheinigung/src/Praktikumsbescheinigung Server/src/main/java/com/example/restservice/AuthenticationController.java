package com.example.restservice;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.restservice.exception.EntityNotFoundException;
import com.example.restservice.request.AuthenticationRequest;
import com.example.restservice.response.JwtTokenResponse;
import com.example.restservice.service.AuthenticationService;

@RestController
@RequestMapping
public class AuthenticationController {

	private AuthenticationService authenticationService;
	
	public AuthenticationController(AuthenticationService authenticationService) {
		this.authenticationService = authenticationService;
	}
	
	@PostMapping("/login")
	public ResponseEntity<JwtTokenResponse> createCustomer(@RequestBody AuthenticationRequest request) {
		return new ResponseEntity<>(authenticationService.generateJWToken(request.getUsername(), request.getPassword()), HttpStatus.OK);
	}
	
	@ExceptionHandler(EntityNotFoundException.class)
	public ResponseEntity<String> handleEntityNotFoundException(EntityNotFoundException ex) {
		return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_FOUND);
	}
}
