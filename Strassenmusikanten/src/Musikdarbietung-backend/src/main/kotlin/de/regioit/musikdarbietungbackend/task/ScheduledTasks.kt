package de.regioit.musikdarbietungbackend.task

import de.regioit.musikdarbietungbackend.service.RestService
import de.regioit.musikdarbietungbackend.service.WebSocketService
import de.regioit.musikdarbietungbackend.utils.ProofState
import mu.KotlinLogging
import org.json.JSONArray
import org.json.JSONObject
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component

@Component
class ScheduledTasks(
        private val webSocketService: WebSocketService,
        private val restService: RestService
) {
    val logger = KotlinLogging.logger {}

    @Scheduled(cron = "\${application.proof.status.cronExpression}")
    fun checkProofStatus() {
        val proofs: String? = restService.getProofs()
        val proofsJson = JSONArray(proofs)
        for (i in 0 until proofsJson.length()) {
            val proof = proofsJson.getJSONObject(i)
            val proofState = ProofState.valueOf(proof["state"].toString())
            if (proofState === ProofState.VERIFIED) {
                val proofDetails = restService.getProofDetails(proof["exchangeId"].toString())
                webSocketService.proofStatusChange(JSONObject(proofDetails))
            }
        }
    }
}
