package com.example.restservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Component;

import com.example.restservice.exception.JwtAuthenticationException;
import com.example.restservice.service.JWTokenService;

import io.jsonwebtoken.JwtException;

@Component
public class JwtAuthenticationProvider implements AuthenticationProvider {
	
	private final JWTokenService jwtService;
	
	public JwtAuthenticationProvider() {
		this(null);
	}
	
	@Autowired
	public JwtAuthenticationProvider(JWTokenService jwtService) {
		this.jwtService = jwtService;
	}
	
	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		
		try {
			String token = (String) authentication.getCredentials();
			String username = jwtService.getUsernameFromToken(token);
			
			return jwtService.validateToken(token)
					.map(aBoolean -> new JwtAuthenticatedProfile(username))
					.orElseThrow(() -> new JwtAuthenticationException("JWT Token validation failed"));
		} catch (JwtException ex) {
			throw new JwtAuthenticationException("Failed to verify token");
		}
	}
	
	@Override
	public boolean supports(Class<?> authentication) {
		return JwtAuthentication.class.equals(authentication);
	}
}
