package com.example.restservice.response;

public class LastEventResponse {
	private String message;
	private boolean isLastEvent;
	
	public LastEventResponse(String message, boolean isLastEvent) {
		this.message = message;
		this.isLastEvent = isLastEvent;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public boolean isLastEvent() {
		return isLastEvent;
	}

	public void setLastEvent(boolean isLastEvent) {
		this.isLastEvent = isLastEvent;
	}
	
	
}
