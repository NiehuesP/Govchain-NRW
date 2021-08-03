package de.regioit.hundehaltererlaubnisbackend

import de.regioit.hundehaltererlaubnisbackend.configuration.ApplicationProperties
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.boot.runApplication
import org.springframework.scheduling.annotation.EnableScheduling

@SpringBootApplication
@EnableConfigurationProperties(ApplicationProperties::class)
@EnableScheduling
class HundehaltererlaubnisBackendApplication

fun main(args: Array<String>) {
    runApplication<HundehaltererlaubnisBackendApplication>(*args)
}
