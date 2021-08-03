package de.regioit.wohnungsgeberbestaetigungbackend.service

import de.regioit.wohnungsgeberbestaetigungbackend.repository.WohnungsgeberbestaetigungRepository
import org.springframework.stereotype.Service

@Service
class CredentialService(
        val wohnungsgeberbestaetigungRepository: WohnungsgeberbestaetigungRepository,
        val restService: RestService
) {
    fun issueCredential(connectionId: String) {
        val wgbst = this.wohnungsgeberbestaetigungRepository.findByConnectionId(connectionId)
        if (wgbst != null) {
            this.restService.issueCredential(wgbst)
        }
    }
}
