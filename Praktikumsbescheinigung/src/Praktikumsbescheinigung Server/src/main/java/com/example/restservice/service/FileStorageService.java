package com.example.restservice.service;

import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import com.example.restservice.entities.FileStorageProperties;
import com.example.restservice.exception.FileStorageException;
import com.example.restservice.exception.MyFileNotFoundException;

@Service
public class FileStorageService {

	private final Path fileStorageLocation;
	private final Path certificateStorageLocation;
	
	@Autowired
	public FileStorageService(FileStorageProperties fileStorageProperties) {
		this.fileStorageLocation = Paths.get(fileStorageProperties.getUploadDir())
				.toAbsolutePath().normalize();
		
		this.certificateStorageLocation = Paths.get(fileStorageProperties.getCertificateDir())
				.toAbsolutePath().normalize();
		
		try {
			Files.createDirectories(this.fileStorageLocation);
		} catch (Exception e) {
			e.printStackTrace();
			throw new FileStorageException("Could not create the directory where the uploaded files will be stored.", e);
		}
		
		try {
			Files.createDirectories(this.certificateStorageLocation);
		} catch (Exception e) {
			e.printStackTrace();
			throw new FileStorageException("Could not create the directory where the certificate files will be stored.", e);
		}
	}
	
	public String storeFile(MultipartFile file, int eventId, int studentId) {
		String fileName = StringUtils.cleanPath(file.getOriginalFilename());
		System.out.println(file.getOriginalFilename());
		System.out.println(fileName);
		
		try {
			if(fileName.contains("..")) {
				throw new FileStorageException("Filename contains invalid path sequence " + fileName);
			}
			Path filePath = this.fileStorageLocation.resolve(eventId + "/" + studentId);
			Files.createDirectories(filePath);
			
			Path targetLocation = this.fileStorageLocation.resolve(eventId + "/" + studentId + "/" + fileName);
			Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
			
			return fileName;
		} catch (IOException e) {
			throw new FileStorageException("Could not store file " + fileName + ". Please try again!", e);
		}
	}
	
	public String storeCertificate(MultipartFile file, int courseId, int studentId) {
		String fileName = StringUtils.cleanPath(file.getOriginalFilename());
		
		try {
			if(fileName.contains("..")) {
				throw new FileStorageException("Filename contains invalid path sequence " + fileName);
			}
			
			Path filePath = this.certificateStorageLocation.resolve(courseId + "/" + studentId);
			Files.createDirectories(filePath);
			
			Path targetLocation = this.certificateStorageLocation.resolve(courseId + "/" + studentId + "/" + fileName);
			Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
			
			return fileName;
		} catch(IOException e) {
			throw new FileStorageException("Could not store certificate " + fileName + ". Please try again!", e);
		}
	}
	
	public Resource loadFileAsResource(String fileName) {
		try {
			Path filePath = this.fileStorageLocation.resolve(fileName).normalize();
			Resource resource = new UrlResource(filePath.toUri());
			if(resource.exists()) {
				return resource;
			} else {
				throw new MyFileNotFoundException("File not found " + fileName);
			}
		} catch (MalformedURLException e) {
			throw new MyFileNotFoundException("File not found " + fileName, e);
		}
	}
	
	public Resource loadCertificateAsResource(String fileName) {
		try {
			Path filePath = this.certificateStorageLocation.resolve(fileName).normalize();
			Resource resource = new UrlResource(filePath.toUri());
			if(resource.exists()) {
				return resource;
			} else {
				throw new MyFileNotFoundException("Certificate not found " + fileName);
			}
		} catch (MalformedURLException e) {
			throw new MyFileNotFoundException("Certificate not found " + fileName, e);
		}
	}
	
}
