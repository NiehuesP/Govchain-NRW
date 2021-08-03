package de.regioit.wohnungsgeberbestaetigungbackend.configuration

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties(prefix = "application")
class ApplicationProperties {
    val security = Security()
    var credDefIdWgbst: String? = null
    var proofTemplateIdWgbst: String? = null
    var credDefIdMbst: String? = null
    var proofTemplateIdMbst: String? = null

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

