package de.regioit.musikdarbietungbackend.service

import de.regioit.musikdarbietungbackend.configuration.ApplicationProperties
import de.regioit.musikdarbietungbackend.web.rest.dto.ConnectionSendDTO
import de.regioit.musikdarbietungbackend.web.rest.dto.MusikdarbietungDTO
import mu.KotlinLogging
import okhttp3.FormBody
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONArray
import org.json.JSONObject
import org.springframework.stereotype.Service
import java.io.IOException
import java.time.format.DateTimeFormatter

@Service
class RestService(
        private val qrService: QrService,
        private val pushService: PushService,
        private val applicationProperties: ApplicationProperties
) {
    private val logger = KotlinLogging.logger {}
    private val credDefId = applicationProperties.credDefId
    private val proofTemplateId = applicationProperties.proofTemplateId

    fun authorize(): String {
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/auth/realms/lissi-cloud/protocol/openid-connect/token"

        val body = FormBody.Builder()
                .add("grant_type", "password")
                .add("username", "lissi")
                .add("password", "lissi")
                .add("client_id", "postman")
                .build()

        val request = Request.Builder()
                .url(url)
                .addHeader("Content-Type", "application/x-www-form-urlencoded")
                .post(body)
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        val json = JSONObject(response.body!!.string())

        return json.getString("access_token")
    }

    fun createConnection(connectionSendDTO: ConnectionSendDTO) {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/connections/create-invitation?alias=${connectionSendDTO.name} (${connectionSendDTO.email})"

        val body = FormBody.Builder().build()

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "application/json")
                .post(body)
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        val json = JSONObject(response.body!!.string())

        val invitationUrl = "https://ssi-node-01.govchain.regioit.de/deeplink/?c_i=" + json.getString("invitationUrl").substring(42)

        pushService.sendInvitation(invitationUrl, connectionSendDTO.email, connectionSendDTO.telefonnummer)
    }

    fun getConnections(pending: Boolean): String? {
        val token = authorize()
        val client = OkHttpClient()
        val url: String = if (pending)
            "https://ssi-node-01.govchain.regioit.de/api/connections/pending-connections"
        else
            "https://ssi-node-01.govchain.regioit.de/api/connections/active-connections"

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "application/json")
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        return response.body!!.string()
    }

    fun getCredentials(pending: Boolean, connectionId: String): String? {
        val token = authorize()
        val client = OkHttpClient()
        val url: String = if (pending)
            "https://ssi-node-01.govchain.regioit.de/api/credentials?connectionId=$connectionId&credDefId=${credDefId}&issued=false"
        else
            "https://ssi-node-01.govchain.regioit.de/api/credentials?connectionId=$connectionId&credDefId=${credDefId}&issued=true"

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "application/json")
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        return response.body!!.string()
    }

    fun sendMusikdarbietung(connectionId: String, musikdarbietungDTO: MusikdarbietungDTO): String? {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/credentials/issue"

        val body = "{" +
                "\"connectionId\":\"${connectionId}\"," +
                "\"credentialDefinitionId\":\"${credDefId}\"," +
                "\"attributes\":[" +
                "{\"name\":\"Musiker\"," +
                "\"value\":\"${musikdarbietungDTO.musiker}\"}," +
                "{\"name\":\"Zeitraum\"," +
                "\"value\":\"${musikdarbietungDTO.zeitraumVon.format(DateTimeFormatter.ofPattern("dd.MM.yyyy")).toString()} bis ${musikdarbietungDTO.zeitraumBis.format(DateTimeFormatter.ofPattern("dd.MM.yyyy")).toString()}\"}," +
                "{\"name\":\"Bereich\"," +
                "\"value\":\"${musikdarbietungDTO.bereich}\"}" +
                "]" +
                "}"

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "*/*")
                .post(body.toRequestBody("application/json".toMediaTypeOrNull()))
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        return response.body!!.string()
    }

    fun deleteConnection(connectionId: String): String? {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/connections/$connectionId/remove?removeCreds=true&removeProofs=true"

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "*/*")
                .post("{}".toRequestBody("application/json".toMediaTypeOrNull()))
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        return response.body!!.string()
    }

    fun revokeCredential(id: String): String? {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/credentials/revoke?id=$id"

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "*/*")
                .post("{}".toRequestBody("application/json".toMediaTypeOrNull()))
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        return response.body!!.string()
    }

    fun deleteCredential(id: String): String? {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/credentials/delete?id=$id"

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "*/*")
                .post("{}".toRequestBody("application/json".toMediaTypeOrNull()))
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        return response.body!!.string()
    }

    fun getConnectionlessProof(): Map<String, String> {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/presentation-proof/connectionless?proofTemplateId=$proofTemplateId"

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "application/json")
                .post("{}".toRequestBody("application/json".toMediaTypeOrNull()))
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")
        val json = JSONObject(response.body!!.string())

        val exchangeId = getLatestProofExchangeId()

        return mapOf(
                "exchangeId" to exchangeId,
                "proofUrl" to qrService.generateQrCode(json.getString("url"), 280)
        )
    }

    fun getLatestProofExchangeId(): String {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/presentation-proof/log?proofTemplateId=$proofTemplateId"

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "application/json")
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        val responseJson = JSONArray(response.body!!.string())
        val latestProof = responseJson.getJSONObject(0)

        return latestProof["referenceId"].toString()
    }

    fun getProofs(): String? {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/presentation-proof?proofTemplateId=$proofTemplateId"

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "application/json")
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        return response.body!!.string()
    }

    fun sendProof(connectionId: String): String? {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/presentation-proof/send?proofTemplateId=$proofTemplateId&connectionId=$connectionId"

        val request = Request.Builder()
            .url(url)
            .addHeader("authorization", "Bearer $token")
            .addHeader("accept", "*/*")
            .post("{}".toRequestBody("application/json".toMediaTypeOrNull()))
            .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        return response.body!!.string()
    }

    fun getProofDetails(exchangeId: String): String? {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/presentation-proof/$exchangeId"

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "application/json")
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        return response.body!!.string()
    }

}
