package de.regioit.wohnungsgeberbestaetigungbackend.repository

import de.regioit.wohnungsgeberbestaetigungbackend.domain.Wohnungsgeberbestaetigung
import org.springframework.data.jpa.repository.JpaRepository

interface WohnungsgeberbestaetigungRepository : JpaRepository<Wohnungsgeberbestaetigung, Long> {
    fun findAllByAcceptedFalse(): List<Wohnungsgeberbestaetigung?>
    fun findByConnectionId(connectionId: String): Wohnungsgeberbestaetigung?
}
