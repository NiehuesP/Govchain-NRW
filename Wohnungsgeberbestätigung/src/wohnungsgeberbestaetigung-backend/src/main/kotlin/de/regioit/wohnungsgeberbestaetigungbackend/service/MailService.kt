package de.regioit.wohnungsgeberbestaetigungbackend.service

import com.google.zxing.BarcodeFormat
import com.google.zxing.client.j2se.MatrixToImageWriter
import com.google.zxing.qrcode.QRCodeWriter
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.MimeMessageHelper
import org.springframework.stereotype.Service
import org.thymeleaf.context.Context
import org.thymeleaf.spring5.SpringTemplateEngine
import java.io.ByteArrayOutputStream
import java.nio.charset.StandardCharsets
import java.util.*

@Service
class MailService(
        val javaMailSender: JavaMailSender,
        val templateEngine: SpringTemplateEngine
) {
    private fun sendEmail(to: String, subject: String, content: String, isMultipart: Boolean, isHtml: Boolean) {
        this.javaMailSender.send { mimeMessage ->
            val message = MimeMessageHelper(mimeMessage, isMultipart, StandardCharsets.UTF_8.name())
            message.setTo(to)
            message.setFrom("service@wgbst.de")
            message.setSubject(subject)
            message.setText(content, isHtml)
        }
    }

    fun sendInvitation(invitationUrl: String, email: String) {
        val context = Context();
        val content: String
        val subject: String
        context.setVariable("qrcode", generateQrCode(invitationUrl))
        context.setVariable("link", invitationUrl)
        content = this.templateEngine.process("invitation", context)
        subject = "Wohnungsgeberbestätigung"

        sendEmail(email, subject, content, isMultipart = false, isHtml = true)
    }

    private fun generateQrCode(invitationUrl: String): String {
        val matrix = QRCodeWriter().encode(invitationUrl, BarcodeFormat.QR_CODE, 400, 400)
        val stream = ByteArrayOutputStream()
        MatrixToImageWriter.writeToStream(matrix, "png", stream)
        return Base64.getEncoder().encodeToString(stream.toByteArray())
    }
}
