package de.regioit.musikdarbietungbackend.web.rest.dto

import java.time.LocalDate

data class MusikdarbietungDTO(
        var musiker: String,
        var bereich: String,
        var zeitraumVon: LocalDate,
        var zeitraumBis: LocalDate,
)
