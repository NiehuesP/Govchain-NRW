package de.regioit.hundehaltererlaubnisbackend.web.rest

import com.fasterxml.jackson.annotation.JsonProperty
import de.regioit.hundehaltererlaubnisbackend.domain.User
import de.regioit.hundehaltererlaubnisbackend.security.jwt.JWTFilter
import de.regioit.hundehaltererlaubnisbackend.security.jwt.TokenProvider
import de.regioit.hundehaltererlaubnisbackend.service.UserService
import de.regioit.hundehaltererlaubnisbackend.web.rest.vm.LoginVM
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.security.authentication.DisabledException
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.Authentication
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import javax.validation.Valid

@RestController
class UserJWTController(private val tokenProvider: TokenProvider,
                        private val authenticationManager: AuthenticationManager,
                        private val userService: UserService
) {
    private val log: org.slf4j.Logger = org.slf4j.LoggerFactory.getLogger(UserJWTController::class.java)
    @PostMapping("/api/authenticate")
    fun authorize(@RequestBody @Valid loginVM: LoginVM?): ResponseEntity<*> {
        val authenticationToken = UsernamePasswordAuthenticationToken(loginVM?.username, loginVM?.password)
        val user: User? = userService.checkUser(loginVM?.username)
        return try {
            val authentication: Authentication = authenticationManager.authenticate(authenticationToken)
            SecurityContextHolder.getContext().setAuthentication(authentication)
            val jwt: String = tokenProvider.createToken(authentication, false)
            val httpHeaders: org.springframework.http.HttpHeaders = org.springframework.http.HttpHeaders()
            httpHeaders.add(JWTFilter.AUTHORIZATION_HEADER, "Bearer $jwt")
            ResponseEntity<Any?>(JWTToken(jwt), httpHeaders, HttpStatus.OK)
        } catch (e: BadCredentialsException) {
            val error_msg = "Bad credentials"
            ResponseEntity<Any?>(error_msg, HttpHeaders(), HttpStatus.BAD_REQUEST)
        } catch (e: DisabledException) {
            val error_msg = "User disabled"
            ResponseEntity<Any?>(error_msg, HttpHeaders(), HttpStatus.BAD_REQUEST)
        }
    }

    /**
     * Object to return as body in JWT Authentication.
     */
    internal class JWTToken(@get:JsonProperty("id_token") var idToken: String)

}
