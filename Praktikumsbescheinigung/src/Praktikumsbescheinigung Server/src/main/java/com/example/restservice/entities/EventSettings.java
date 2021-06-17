package com.example.restservice.entities;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonValue;

@Entity
@Table(name="eventSettings")
public class EventSettings implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	private int eventId;
	
	@Id
	private Integer professorId;
	
	private boolean needUpload;
	private boolean autoComplete;
	private boolean notifications;
	
	public EventSettings() {}
	
	public int getEventId() {
		return eventId;
	}
	public void setEventId(int eventId) {
		this.eventId = eventId;
	}
	public Integer getProfessorId() {
		return professorId;
	}
	public void setProfessorId(Integer professorId) {
		this.professorId = professorId;
	}
	public boolean isNeedUpload() {
		return needUpload;
	}
	public void setNeedUpload(boolean needUpload) {
		this.needUpload = needUpload;
	}
	public boolean isAutoComplete() {
		return autoComplete;
	}
	public void setAutoComplete(boolean autoComplete) {
		this.autoComplete = autoComplete;
	}
	public boolean isNotifications() {
		return notifications;
	}
	public void setNotifications(boolean notifications) {
		this.notifications = notifications;
	}
	
	public EventSettings(ResultSet rs) {
		try {
			if(!rs.isAfterLast()) {
			this.eventId = rs.getInt("eventId");
			this.professorId = rs.getInt("professorId");
			this.needUpload = rs.getString("needUpload").equals("true");
			this.autoComplete = rs.getString("autoComplete").equals("true");
			this.notifications = rs.getString("notifications").equals("true");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@JsonValue
	public String info() {
		return "{" + 
	"\"eventId\": " + this.eventId +
	", \"professorId\": " + this.professorId +
	", \"needUpload\": \"" + this.needUpload +
	"\", \"autoComplete\": \"" + this.autoComplete + 
	"\", \"notifications\": \"" + this.notifications +
	"\"}";
	
	}

}
