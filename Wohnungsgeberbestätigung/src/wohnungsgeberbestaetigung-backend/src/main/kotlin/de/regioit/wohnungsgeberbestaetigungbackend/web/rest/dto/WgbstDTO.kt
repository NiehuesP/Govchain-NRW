package de.regioit.wohnungsgeberbestaetigungbackend.web.rest.dto

import java.time.LocalDate

data class WgbstDTO(
        var nameBeauftragt: String?,
        var wohnortBeauftragt: String?,
        var nameEigentuemer: String?,
        var wohnortEigentuemer: String?,
        var nameWohnungsgeber: String?,
        var wohnortWohnungsgeber: String?,
        var adresse: String,
        var einzugsbestaetigung: String,
        var tagDesEinzugs: LocalDate?,
        val email: String
)
