package com.example.restservice.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.restservice.entities.Professor;
import com.example.restservice.entities.Student;
import com.example.restservice.exception.EntityNotFoundException;
import com.example.restservice.response.JwtTokenResponse;

@Service
public class AuthenticationService {

	private JWTokenService jwtokenService;
	private PasswordEncoder passwordEncoder;
	
	@Autowired
	DatabaseService databaseService;
	
	public AuthenticationService(JWTokenService jwtokenService, PasswordEncoder passwordEncoder) {
		this.jwtokenService = jwtokenService;
		this.passwordEncoder = passwordEncoder;
	}
	
	public JwtTokenResponse generateJWToken(String username, String password) {
		if(username.endsWith("s")) {
			Student student = databaseService.getLoginStudent(username, password);
		
		return databaseService.findStudentByUsername(username)
				.filter(account -> passwordEncoder.matches(password, account.getPassword()))
				.map(account -> new JwtTokenResponse(jwtokenService.generateToken(username), student))
				.orElseThrow(() ->
						new EntityNotFoundException("Account not found")
				);
		} else {
			Professor professor = databaseService.getLoginProfessor(username, password);
			
			return databaseService.findProfessorByUsername(username)
					.filter(account -> passwordEncoder.matches(password, account.getPassword()))
					.map(account -> new JwtTokenResponse(jwtokenService.generateToken(username), professor))
					.orElseThrow(() ->
							new EntityNotFoundException("Account not found")
					);
		}
	}
}
