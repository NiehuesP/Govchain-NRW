package de.regioit.wohnungsgeberbestaetigungbackend.service

import mu.KotlinLogging
import org.springframework.stereotype.Service

@Service
class PushService(
        val mailService: MailService
) {
    val logger = KotlinLogging.logger {}

    fun sendInvitation(invitationUrl: String, email: String) {
        try {
            this.mailService.sendInvitation(invitationUrl, email)
        } catch (ex: Exception) {
        logger.error(ex) { }
        }
    }
}
