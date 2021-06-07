package de.regioit.musikdarbietungbackend.service

import mu.KotlinLogging
import org.springframework.stereotype.Service

@Service
class PushService(
        val mailService: MailService
) {
    val logger = KotlinLogging.logger {}

    fun sendInvitation(invitationUrl: String, email: String?, telefonnummer: String?) {
        try {
            if (email == null && telefonnummer == null) {
                return
            }
            if (email !== null) {
                this.mailService.sendInvitation(invitationUrl, email)
            }
            if (telefonnummer !== null) {
                // TODO: SmsService
            }
        } catch (ex: Exception) {
            logger.error(ex) { }
        }
    }
}
