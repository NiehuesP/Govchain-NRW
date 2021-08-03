package de.regioit.hundehaltererlaubnisbackend.web.rest

import de.regioit.hundehaltererlaubnisbackend.domain.User
import de.regioit.hundehaltererlaubnisbackend.service.UserService
import org.slf4j.LoggerFactory
import org.springframework.util.StringUtils
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import javax.servlet.http.HttpServletRequest

/**
 * REST controller for managing the current user's account.
 */
@RestController
class AccountResource(private val userService: UserService) {
    private val log = LoggerFactory.getLogger(AccountResource::class.java)

    /**
     * GET  /authenticate : check if the user is authenticated, and return its login.
     *
     * @param request the HTTP request
     * @return the login if the user is authenticated
     */
    @GetMapping("/api/authenticate")
    fun isAuthenticated(request: HttpServletRequest): String {
        log.debug("REST request to check if the current user is authenticated")
        return request.remoteUser
    }

    /**
     * GET  /account : get the current user.
     *
     * @return the current user
     * @throws RuntimeException 500 (Internal Server Error) if the user couldn't be returned
     */
    @GetMapping("/api/account")
    fun getAccount(): User {
        return userService.getUserWithAuthorities()
    }

    companion object {
        private fun checkPasswordLength(password: String): Boolean {
            return !StringUtils.isEmpty(password) && password.length >= 4 && password.length <= 100
        }
    }

}
