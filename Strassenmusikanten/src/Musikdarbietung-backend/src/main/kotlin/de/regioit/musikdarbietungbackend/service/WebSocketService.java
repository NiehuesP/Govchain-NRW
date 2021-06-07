package de.regioit.musikdarbietungbackend.service;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;


@Service
public class WebSocketService {
    private final Logger logger = LoggerFactory.getLogger(WebSocketService.class);

    private final SimpMessagingTemplate template;

    public WebSocketService(SimpMessagingTemplate template) {
        this.template = template;
    }

    public void proofStatusChange(JSONObject proofDetails) {
        this.template.convertAndSend("/proof/status/" + proofDetails.getJSONObject("proof").getString("exchangeId"), proofDetails.toString());
    }
}
