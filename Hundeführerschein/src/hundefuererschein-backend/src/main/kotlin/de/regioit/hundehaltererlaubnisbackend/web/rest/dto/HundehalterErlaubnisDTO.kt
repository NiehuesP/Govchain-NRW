package de.regioit.hundehaltererlaubnisbackend.web.rest.dto

import java.time.LocalDate

data class HundehalterErlaubnisDTO(
    var halter: String,
    var befreiung: String?,
    var rasse: String?,
    var name: String?,
    var fellfarbe: String?,
    var geschlecht: String?,
    var geburtstag: LocalDate,
    var chipnr: String?,
    var haltungsErlaubnis: LocalDate
)
