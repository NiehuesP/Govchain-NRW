package de.regioit.wohnungsgeberbestaetigungbackend

import de.regioit.wohnungsgeberbestaetigungbackend.configuration.ApplicationProperties
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.boot.runApplication
import org.springframework.scheduling.annotation.EnableScheduling

@SpringBootApplication
@EnableConfigurationProperties(ApplicationProperties::class)
@EnableScheduling
class WohnungsgeberbestaetigungBackendApplication

fun main(args: Array<String>) {
    runApplication<WohnungsgeberbestaetigungBackendApplication>(*args)
}
