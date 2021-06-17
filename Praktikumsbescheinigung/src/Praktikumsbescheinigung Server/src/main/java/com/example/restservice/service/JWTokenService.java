package com.example.restservice.service;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Function;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

@Component
public class JWTokenService {
	
	private Key secret;
	
	private Long expiration;
	
	
	public JWTokenService(@Value("${jwt.secret}") String secret,
						  @Value("${jwt.expiration}") Long expiration) {
		this.secret = Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
		this.expiration = expiration;
	}
	
	public String getUsernameFromToken(String token) {
		return getClaimFromToken(token, Claims::getSubject);
	}
	
	public Date getExpirationDateFromToken(String token) {
		return getClaimFromToken(token, Claims::getExpiration);
	}
	
	public <T> T getClaimFromToken(String token, Function<Claims, T> claimsResolver) {
		final Claims claims = getAllClaimsFromToken(token);
		return claimsResolver.apply(claims);
	}
	
	private Claims getAllClaimsFromToken(String token) {
		return Jwts.parserBuilder()
				.setSigningKey(secret)
				.build()
				.parseClaimsJws(token)
				.getBody();
	}
	
	private boolean isTokenNotExpired(String token) {
		final Date expiration = getExpirationDateFromToken(token);
		return expiration.after(new Date());
	}
	
	public Optional<Boolean> validateToken(String token) {
		return isTokenNotExpired(token) ? Optional.of(Boolean.TRUE) : Optional.empty();
	}

	public String generateToken(String username) {
		final Date createdDate = new Date();
		final Date expirationDate = calculateExpirationDate(createdDate);
		
		System.out.println("JWTokenService secret: " + secret);
		
		return Jwts.builder()
				.setClaims(new HashMap<>())
				.setSubject(username)
				.setIssuedAt(createdDate)
				.setExpiration(expirationDate)
				.signWith(secret)
				.compact();
	}
	
	private Date calculateExpirationDate(Date createdDate) {
		return new Date(createdDate.getTime() + expiration * 10000);
	}
}
