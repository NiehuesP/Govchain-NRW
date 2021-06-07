package de.regioit.musikdarbietungbackend.service

import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.client.j2se.MatrixToImageWriter
import com.google.zxing.qrcode.QRCodeWriter
import org.springframework.stereotype.Service
import java.io.ByteArrayOutputStream
import java.util.*

@Service
class QrService {
    fun generateQrCode(invitationUrl: String, size: Int): String {
        val hintMap = mapOf(EncodeHintType.MARGIN to 0)
        val matrix = QRCodeWriter().encode(invitationUrl, BarcodeFormat.QR_CODE, size, size, hintMap)
        val stream = ByteArrayOutputStream()
        MatrixToImageWriter.writeToStream(matrix, "png", stream)
        return Base64.getEncoder().encodeToString(stream.toByteArray())
    }
}
