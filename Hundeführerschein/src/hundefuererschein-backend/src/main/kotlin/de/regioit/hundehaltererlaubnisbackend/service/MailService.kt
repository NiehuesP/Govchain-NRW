package de.regioit.hundehaltererlaubnisbackend.service

import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.MimeMessageHelper
import org.springframework.stereotype.Service
import org.thymeleaf.context.Context
import org.thymeleaf.spring5.SpringTemplateEngine
import java.nio.charset.StandardCharsets

@Service
class MailService(
    val javaMailSender: JavaMailSender,
    val templateEngine: SpringTemplateEngine,
    private val qrService: QrService
) {
    private fun sendEmail(to: String, subject: String, content: String, isMultipart: Boolean, isHtml: Boolean) {
        this.javaMailSender.send { mimeMessage ->
            val message = MimeMessageHelper(mimeMessage, isMultipart, StandardCharsets.UTF_8.name())
            message.setTo(to)
            message.setFrom("service@hundehaltung.de")
            message.setSubject(subject)
            message.setText(content, isHtml)
        }
    }

    fun sendInvitation(invitationUrl: String, email: String) {
        val context = Context();
        val content: String
        val subject: String
        context.setVariable("qrcode", qrService.generateQrCode(invitationUrl, 400))
        context.setVariable("link", invitationUrl)
        content = this.templateEngine.process("invitation", context)
        subject = "Hundehaltererlaubnis"

        sendEmail(email, subject, content, isMultipart = false, isHtml = true)
    }
}
