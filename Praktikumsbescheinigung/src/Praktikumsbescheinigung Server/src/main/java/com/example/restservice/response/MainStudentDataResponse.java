package com.example.restservice.response;

import java.util.Map;

import com.example.restservice.entities.Course;
import com.example.restservice.entities.Event;

public class MainStudentDataResponse {
	private Map<Course, Map<Event, String>> eventStatusMap;
	private Map<Event, String> nextEventsMap;
	
	public MainStudentDataResponse(Map<Course, Map<Event, String>> eventStatusMap, Map<Event, String> nextEventsMap) {
		this.eventStatusMap = eventStatusMap;
		this.nextEventsMap = nextEventsMap;
	}

	public Map<Course, Map<Event, String>> getEventStatusMap() {
		return eventStatusMap;
	}

	public void setEventStatusMap(Map<Course, Map<Event, String>> eventStatusMap) {
		this.eventStatusMap = eventStatusMap;
	}

	public Map<Event, String> getNextEventsMap() {
		return nextEventsMap;
	}

	public void setNextEventsMap(Map<Event, String> nextEventsMap) {
		this.nextEventsMap = nextEventsMap;
	}
	
	
}
