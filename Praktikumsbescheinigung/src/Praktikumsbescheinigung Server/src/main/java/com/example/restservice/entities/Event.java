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
@Table(name = "events")
public class Event implements Serializable {
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int eventId;
	
	private String date;
	private String name;
	private String room;
	private String time;
	private int courseId;
	
	public Event() {}
	
	public int getEventId() {
		return eventId;
	}
	public void setEventId(int eventId) {
		this.eventId = eventId;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getRoom() {
		return room;
	}
	public void setRoom(String room) {
		this.room = room;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public int getCourseId() {
		return courseId;
	}
	public void setCourseId(int courseId) {
		this.courseId = courseId;
	}
	
	public Event(ResultSet rs) {
		try {
			if(!rs.isAfterLast()) {
			this.eventId = rs.getInt("eventId");
			this.date = rs.getString("date");
			this.name = rs.getString("name");
			this.room = rs.getString("room");
			this.time = rs.getString("time");
			this.courseId = rs.getInt("courseId");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	@JsonValue
	public String info() {
		return "{" +
	" \"eventId\": " + this.eventId + 
	", \"date\": \"" + this.date + 
	"\", \"name\": \"" + this.name + 
	"\", \"room\": \"" + this.room + 
	"\", \"time\": \"" + this.time + 
	"\", \"courseId\": " + this.courseId +
	"}";
	}
}
