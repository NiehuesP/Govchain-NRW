package de.regioit.musikdarbietungbackend.configuration

import org.springframework.security.config.annotation.web.messaging.MessageSecurityMetadataSourceRegistry
import org.springframework.security.config.annotation.web.socket.AbstractSecurityWebSocketMessageBrokerConfigurer

class WebSocketSecurityConfig: AbstractSecurityWebSocketMessageBrokerConfigurer() {
    override fun configureInbound(messages: MessageSecurityMetadataSourceRegistry) {
        messages.anyMessage()
    }

    override fun sameOriginDisabled(): Boolean {
        return true
    }
}
