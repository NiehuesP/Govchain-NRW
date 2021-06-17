package com.example.restservice.response;

import com.example.restservice.entities.FileUpload;

public class FileUploadResponse {
	FileUpload fileUpload;
	
	public FileUploadResponse(FileUpload fileUpload) {
		this.fileUpload = fileUpload;
	}

	public FileUpload getFileUpload() {
		return fileUpload;
	}

	public void setFileUpload(FileUpload fileUpload) {
		this.fileUpload = fileUpload;
	}
	
}
