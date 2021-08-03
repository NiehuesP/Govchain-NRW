package de.regioit.wohnungsgeberbestaetigungbackend.web.rest.dto

import java.time.LocalDate

data class MbstDTO(
        var connectionId: String?,
        var vorname: String?,
        var familienname: String?,
        var rufname: String?,
        var geborenAm: LocalDate?,
        var geburtsort: String?,
        var staatsangeh: String?,
        var famStand: String?,
        var religion: String?,
        var einzigeWohnung: String?,
        var einzugAm: LocalDate?,
        var gemeldetSeit: LocalDate?,
        val gemeindeKennziffer: String?
)
