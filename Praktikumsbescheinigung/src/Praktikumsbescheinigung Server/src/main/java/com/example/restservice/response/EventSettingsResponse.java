package com.example.restservice.response;

import com.example.restservice.entities.EventSettings;

public class EventSettingsResponse {
	EventSettings eventSettings;
	
	public EventSettingsResponse(EventSettings eventSettings) {
		this.eventSettings = eventSettings;
	}

	public EventSettings getEventSettings() {
		return eventSettings;
	}

	public void setEventSettings(EventSettings eventSettings) {
		this.eventSettings = eventSettings;
	}
	
}
