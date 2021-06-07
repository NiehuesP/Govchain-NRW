package de.regioit.musikdarbietungbackend

import de.regioit.musikdarbietungbackend.configuration.ApplicationProperties
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.boot.runApplication
import org.springframework.scheduling.annotation.EnableScheduling

@SpringBootApplication
@EnableConfigurationProperties(ApplicationProperties::class)
@EnableScheduling
class MusikdarbietungBackendApplication

fun main(args: Array<String>) {
    runApplication<MusikdarbietungBackendApplication>(*args)
}
