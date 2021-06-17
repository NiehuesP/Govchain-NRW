package com.example.restservice;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class JwtAuthenticationTokenFilter extends OncePerRequestFilter {

	@Value("${jwt.header}")
	private String tokenHeader;
	
	@Value("{jwt.socketHeader}")
	private String socketTokenHeader;
	
	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {
		String requestHeader = request.getHeader(this.tokenHeader);
		
		System.out.println("header: " + requestHeader);
		System.out.println("response code: " + response.getStatus());
		
		if(requestHeader != null && requestHeader.startsWith("Bearer ")) {
			String authToken = requestHeader.substring(7);
			JwtAuthentication authentication = new JwtAuthentication(authToken);
			SecurityContextHolder.getContext().setAuthentication(authentication);
		}
		filterChain.doFilter(request, response);
	}

}
