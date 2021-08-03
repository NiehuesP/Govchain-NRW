package de.regioit.hundehaltererlaubnisbackend.configuration

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties(prefix = "application")
class ApplicationProperties {
    val security = Security()
    var credDefId: String? = null
    var proofTemplateId: String? = null

    class Security {
        var authentication = Authentication()

        class Authentication {
            var jwt = Jwt()

            class Jwt {
                var secret: String? = null
                var base64Secret: String? = null
                var tokenValidityInSeconds: Long = 1800 // 0.5 hour
                var tokenValidityInSecondsForRememberMe: Long = 2592000 // 30 hours;
            }
        }
    }
}
