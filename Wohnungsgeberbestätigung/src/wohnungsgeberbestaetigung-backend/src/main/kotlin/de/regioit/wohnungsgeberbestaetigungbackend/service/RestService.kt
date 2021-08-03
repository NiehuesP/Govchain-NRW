package de.regioit.wohnungsgeberbestaetigungbackend.service

import de.regioit.wohnungsgeberbestaetigungbackend.configuration.ApplicationProperties
import de.regioit.wohnungsgeberbestaetigungbackend.domain.Wohnungsgeberbestaetigung
import de.regioit.wohnungsgeberbestaetigungbackend.schedulingtasks.ScheduledTasks
import de.regioit.wohnungsgeberbestaetigungbackend.web.rest.dto.MbstDTO
import okhttp3.FormBody
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import java.io.IOException
import java.time.format.DateTimeFormatter

@Service
class RestService(
    private val applicationProperties: ApplicationProperties
) {
    private val logger = LoggerFactory.getLogger(ScheduledTasks::class.java)
    private val credDefIdWgbst = applicationProperties.credDefIdWgbst
    private val proofTemplateIdWgbst = applicationProperties.proofTemplateIdWgbst
    private val credDefIdMbst = applicationProperties.credDefIdMbst
    private val proofTemplateIdMbst = applicationProperties.proofTemplateIdMbst

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

    fun createConnection(alias: String): Map<String, String> {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/connections/create-invitation?alias=$alias"

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

        return mapOf(
                "connectionId" to json.getString("connectionId"),
                "invitationUrl" to json.getString("invitationUrl")
        )
    }

    fun checkConnectionStatus(connectionId: String): String {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/connections/$connectionId"

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "application/json")
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        val json = JSONObject(response.body!!.string())

        return json.getString("state")
    }

    fun issueCredential(wgbst: Wohnungsgeberbestaetigung) {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/credentials/issue"

        val body = "{" +
                "\"connectionId\":\"${wgbst.connectionId}\"," +
                "\"credentialDefinitionId\":\"${credDefIdWgbst}\"," +
                "\"attributes\":[" +
                "{\"name\":\"Name_der_beauftragten_Person\"," +
                "\"value\":\"${wgbst.nameBeauftragt}\"}," +
                "{\"name\":\"Wohnort_der_beauftragten_Person\"," +
                "\"value\":\"${wgbst.wohnortBeauftragt}\"}," +
                "{\"name\":\"Name_des_Eigentuemers\"," +
                "\"value\":\"${wgbst.nameEigentuemer}\"}," +
                "{\"name\":\"Wohnort_des_Eigentuemers\"," +
                "\"value\":\"${wgbst.wohnortEigentuemer}\"}," +
                "{\"name\":\"Name_des_Wohnungsgebers\"," +
                "\"value\":\"${wgbst.nameWohnungsgeber}\"}," +
                "{\"name\":\"Wohnort_des_Wohnungsgebers\"," +
                "\"value\":\"${wgbst.wohnortWohnungsgeber}\"}," +
                "{\"name\":\"Adresse_der_Wohnung\"," +
                "\"value\":\"${wgbst.adresse}\"}," +
                "{\"name\":\"Einzugsbestaetigung_fuer\"," +
                "\"value\":\"${wgbst.einzugsbestaetigung}\"}," +
                "{\"name\":\"Tag_des_Einzugs\"," +
                "\"value\":\"${wgbst.tagDesEinzugs?.format(DateTimeFormatter.ofPattern("dd.MM.yyyy")).toString()}\"}" +
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
            "https://ssi-node-01.govchain.regioit.de/api/credentials?connectionId=$connectionId&issued=false"
        else
            "https://ssi-node-01.govchain.regioit.de/api/credentials?connectionId=$connectionId&issued=true"

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "application/json")
                .build()

        val response = client.newCall(request).execute()
        if (!response.isSuccessful) throw IOException("Unexpected code $response")

        return response.body!!.string()
    }

    fun getProofs(pending: Boolean, connectionId: String): String? {
        val token = authorize()
        val client = OkHttpClient()
        val url: String = if (pending)
            "https://ssi-node-01.govchain.regioit.de/api/presentation-proof?connectionId=$connectionId&verified=false"
        else
            "https://ssi-node-01.govchain.regioit.de/api/presentation-proof?connectionId=$connectionId&verified=true"

        val request = Request.Builder()
                .url(url)
                .addHeader("authorization", "Bearer $token")
                .addHeader("accept", "application/json")
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

    fun sendProof(connectionId: String): String? {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/presentation-proof/send?proofTemplateId=$proofTemplateIdWgbst&connectionId=$connectionId"

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

    fun sendMeldebestaetigung(connectionId: String, mbst: MbstDTO): String? {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/credentials/issue"

        val body = "{" +
                "\"connectionId\":\"${connectionId}\"," +
                "\"credentialDefinitionId\":\"${credDefIdMbst}\"," +
                "\"attributes\":[" +
                "{\"name\":\"Vorname\"," +
                "\"value\":\"${mbst.vorname}\"}," +
                "{\"name\":\"Familienname\"," +
                "\"value\":\"${mbst.familienname}\"}," +
                "{\"name\":\"Rufname\"," +
                "\"value\":\"${mbst.rufname}\"}," +
                "{\"name\":\"geboren_am\"," +
                "\"value\":\"${mbst.geborenAm?.format(DateTimeFormatter.ofPattern("dd.MM.yyyy")).toString()}\"}," +
                "{\"name\":\"Geburtsort\"," +
                "\"value\":\"${mbst.geburtsort}\"}," +
                "{\"name\":\"Staatsangeh\"," +
                "\"value\":\"${mbst.staatsangeh}\"}," +
                "{\"name\":\"FamStand\"," +
                "\"value\":\"${mbst.famStand}\"}," +
                "{\"name\":\"Religion\"," +
                "\"value\":\"${mbst.religion}\"}," +
                "{\"name\":\"einzige_Wohnung\"," +
                "\"value\":\"${mbst.einzigeWohnung}\"}," +
                "{\"name\":\"Einzug_am\"," +
                "\"value\":\"${mbst.einzugAm?.format(DateTimeFormatter.ofPattern("dd.MM.yyyy")).toString()}\"}," +
                "{\"name\":\"gemeldet_seit\"," +
                "\"value\":\"${mbst.gemeldetSeit?.format(DateTimeFormatter.ofPattern("dd.MM.yyyy")).toString()}\"}," +
                "{\"name\":\"Gemeindekennziffer\"," +
                "\"value\":\"${mbst.gemeindeKennziffer}\"}" +
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

    fun deleteProof(exchangeId: String): String? {
        val token = authorize()
        val client = OkHttpClient()
        val url = "https://ssi-node-01.govchain.regioit.de/api/presentation-proof/delete?exchangeId=$exchangeId"

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
}
