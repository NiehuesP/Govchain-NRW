package de.regioit.musikdarbietungbackend.security.jwt

import org.springframework.security.config.annotation.SecurityConfigurerAdapter
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.web.DefaultSecurityFilterChain
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter

class JWTConfigurer(private var tokenProvider: TokenProvider) : SecurityConfigurerAdapter<DefaultSecurityFilterChain?, HttpSecurity>() {

    @Throws(Exception::class)
    override fun configure(http: HttpSecurity) {
        val customFilter = JWTFilter(tokenProvider)
        http.addFilterBefore(customFilter, UsernamePasswordAuthenticationFilter::class.java)
    }

}
