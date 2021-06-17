package com.example.restservice;

import java.util.ArrayList;
import java.util.Collection;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;

public class JwtAuthenticatedProfile implements Authentication {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private final String username;
	
	public JwtAuthenticatedProfile(String username) {
		this.username = username;
	}
	
	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return new ArrayList<>();
	}
	
	@Override
	public Object getCredentials() {
		return null;
	}
	
	@Override
	public Object getDetails() {
		return null;
	}
	
	@Override
	public Object getPrincipal() {
		return username;
	}
	
	@Override
	public boolean isAuthenticated() {
		return true;
	}
	
	@Override
	public void setAuthenticated(boolean isAuthenticated) throws IllegalArgumentException {
		
	}
	
	@Override
	public String getName() {
		return username;
	}
}
