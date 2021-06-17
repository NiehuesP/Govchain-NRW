package com.example.restservice.entities;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonValue;

@Entity
@Table(name="uploadedFiles")
public class FileUpload implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long fileId;
	
	private int eventId;
	private int studentId;
	private String fileName;
	private String uploadTime;
	private String fileType;
	private long size;
	
	public FileUpload() {}
	
	public long getFileId() {
		return fileId;
	}
	public void setFileId(long fileId) {
		this.fileId = fileId;
	}
	public int getEventId() {
		return eventId;
	}
	public void setEventId(int eventId) {
		this.eventId = eventId;
	}
	public int getStudentId() {
		return studentId;
	}
	public void setStudentId(int studentId) {
		this.studentId = studentId;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getUploadTime() {
		return uploadTime;
	}
	public void setUploadTime(String uploadTime) {
		this.uploadTime = uploadTime;
	}
	
	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public long getSize() {
		return size;
	}

	public void setSize(long size) {
		this.size = size;
	}

	public FileUpload(ResultSet rs) {
		try {
			if(!rs.isAfterLast()) {
			this.fileId = rs.getLong("fileId");
			this.eventId = rs.getInt("eventId");
			this.studentId = rs.getInt("studentId");
			this.fileName = rs.getString("fileName");
			this.uploadTime = rs.getString("uploadTime");
			this.fileType = rs.getString("fileType");
			this.size = rs.getLong("size");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@JsonValue
	public String info() {
		return "{" + 
	"\"fileId\": " + this.fileId +
	", \"eventId\": " + this.eventId +
	", \"studentId\": " + this.studentId + 
	", \"fileName\": \"" + this.fileName +
	"\", \"uploadTime\": \"" + this.uploadTime +
	"\", \"fileType\": \"" + this.fileType +
	"\", \"size\": " + this.size +
	"}";
	
	}

}
