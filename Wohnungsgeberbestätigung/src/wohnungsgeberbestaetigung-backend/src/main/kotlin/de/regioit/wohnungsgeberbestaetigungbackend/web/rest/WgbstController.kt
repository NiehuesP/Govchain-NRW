package de.regioit.wohnungsgeberbestaetigungbackend.web.rest

import de.regioit.wohnungsgeberbestaetigungbackend.domain.Wohnungsgeberbestaetigung
import de.regioit.wohnungsgeberbestaetigungbackend.repository.WohnungsgeberbestaetigungRepository
import de.regioit.wohnungsgeberbestaetigungbackend.schedulingtasks.ScheduledTasks
import de.regioit.wohnungsgeberbestaetigungbackend.service.PushService
import de.regioit.wohnungsgeberbestaetigungbackend.service.RestService
import de.regioit.wohnungsgeberbestaetigungbackend.web.rest.dto.WgbstDTO
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import javax.validation.Valid

@RestController
class WgbstController(
        val wohnungsgeberbestaetigungRepository: WohnungsgeberbestaetigungRepository,
        val scheduledTasks: ScheduledTasks,
        val restService: RestService,
        val pushService: PushService
) {
    @PostMapping("/api/send")
    fun addWgbst(@Valid @RequestBody request: WgbstDTO): ResponseEntity<Void> {
        if (request.nameBeauftragt == null || request.nameBeauftragt == "") request.nameBeauftragt = "-"
        if (request.wohnortBeauftragt == null || request.wohnortBeauftragt == "") request.wohnortBeauftragt = "-"
        if (request.nameEigentuemer == null || request.nameEigentuemer == "") request.nameEigentuemer = "-"
        if (request.wohnortEigentuemer == null || request.wohnortEigentuemer == "") request.wohnortEigentuemer = "-"
        if (request.nameWohnungsgeber == null || request.nameWohnungsgeber == "") request.nameWohnungsgeber = "-"
        if (request.wohnortWohnungsgeber == null || request.wohnortWohnungsgeber == "") request.wohnortWohnungsgeber = "-"

        val connectionMap = this.restService.createConnection("${request.einzugsbestaetigung} (${request.email})")

        this.wohnungsgeberbestaetigungRepository.save(Wohnungsgeberbestaetigung(
                request.nameBeauftragt,
                request.wohnortBeauftragt,
                request.nameEigentuemer,
                request.wohnortEigentuemer,
                request.nameWohnungsgeber,
                request.wohnortWohnungsgeber,
                request.adresse,
                request.einzugsbestaetigung,
                request.tagDesEinzugs,
                connectionMap["connectionId"],
                false
        ))

        pushService.sendInvitation(connectionMap["invitationUrl"].toString(), request.email)

        return ResponseEntity.status(HttpStatus.NO_CONTENT).build()
    }
}
