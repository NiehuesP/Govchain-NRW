package de.regioit.wohnungsgeberbestaetigungbackend.schedulingtasks

import de.regioit.wohnungsgeberbestaetigungbackend.domain.Wohnungsgeberbestaetigung
import de.regioit.wohnungsgeberbestaetigungbackend.repository.WohnungsgeberbestaetigungRepository
import de.regioit.wohnungsgeberbestaetigungbackend.service.CredentialService
import de.regioit.wohnungsgeberbestaetigungbackend.service.RestService
import org.slf4j.LoggerFactory
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component

@Component
class ScheduledTasks(
        val restService: RestService,
        val wohnungsgeberbestaetigungRepository: WohnungsgeberbestaetigungRepository,
        val credentialService: CredentialService
) {
    private val logger = LoggerFactory.getLogger(ScheduledTasks::class.java)

    @Scheduled(fixedRate = 10000)
    fun checkConnectionStatus(){
        val wgbsts = this.wohnungsgeberbestaetigungRepository.findAllByAcceptedFalse()

        for (wgbst in wgbsts) {
            if (wgbst != null) {
                logger.info("Prüfe Verbindungsstatus fuer:${wgbst.connectionId}")
                val state = this.restService.checkConnectionStatus(wgbst.connectionId.toString())
                if (state == "RESPONDED" || state == "COMPLETE") {
                    // Credential ausstellen
                    this.credentialService.issueCredential(wgbst.connectionId.toString())
                    wgbst.accepted = true
                    this.wohnungsgeberbestaetigungRepository.save(wgbst)
                    logger.info("Wohnungsgeberbestaetigung fuer \"${wgbst.connectionId}\" wird ausgestellt!")
                } else {
                    logger.info("Verbindung noch nicht aufgebaut!")
                }
            }
        }
    }
}
