package com.example.restservice.entities;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "file")
public class FileStorageProperties {

	private String uploadDir;
	private String certificateDir;
	
	public String getUploadDir() {
		return uploadDir;
	}
	
	public void setUploadDir(String uploadDir) {
		this.uploadDir = uploadDir;
	}
	
	public String getCertificateDir() {
		return certificateDir;
	}
	
	public void setCertificateDir(String certificateDir) {
		this.certificateDir = certificateDir;
	}
	
}
