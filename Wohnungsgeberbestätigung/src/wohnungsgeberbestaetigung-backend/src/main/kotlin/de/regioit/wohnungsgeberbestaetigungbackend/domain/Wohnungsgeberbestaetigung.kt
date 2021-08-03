package de.regioit.wohnungsgeberbestaetigungbackend.domain

import java.time.LocalDate
import javax.persistence.Column
import javax.persistence.Entity

@Entity
class Wohnungsgeberbestaetigung(
        @Column val nameBeauftragt: String? = null,
        @Column val wohnortBeauftragt: String? = null,
        @Column val nameEigentuemer: String? = null,
        @Column val wohnortEigentuemer: String? = null,
        @Column val nameWohnungsgeber: String? = null,
        @Column val wohnortWohnungsgeber: String? = null,
        @Column val adresse: String? = null,
        @Column val einzugsbestaetigung: String? = null,
        @Column val tagDesEinzugs: LocalDate? = null,
        @Column val connectionId: String? = null,
        @Column var accepted: Boolean? = null
) : AbstractEntity<Long>()
