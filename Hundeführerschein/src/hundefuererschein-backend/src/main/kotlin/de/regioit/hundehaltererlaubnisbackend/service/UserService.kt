package de.regioit.hundehaltererlaubnisbackend.service

import de.regioit.hundehaltererlaubnisbackend.domain.User
import de.regioit.hundehaltererlaubnisbackend.repository.UserRepository
import org.slf4j.LoggerFactory
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.userdetails.UserDetails
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import javax.persistence.EntityManager
import javax.persistence.PersistenceContext

@Service
@Transactional
class UserService(private val userRepository: UserRepository, private val passwordEncoder: PasswordEncoder) {
    @PersistenceContext
    private val em: EntityManager? = null
    fun setPassword(userId: Long?, newPassword: String?) {
        val user = em!!.find(User::class.java, userId)
        if (user != null) {
            val encryptedPassword = passwordEncoder.encode(newPassword)
            user.setPassword(encryptedPassword)
            em.merge<Any>(user)
        }
    }

    @Transactional(readOnly = true)
    fun getUserWithAuthorities(): User {
        val principal = SecurityContextHolder.getContext().authentication.principal as UserDetails

        return userRepository.findByUsername(principal.username)
    }

    @Transactional(readOnly = true)
    fun checkUser(username: String?): User? {
        return try {
            em!!.createQuery("select u from User u where u.username = :username", User::class.java)
                .setParameter("username", username)
                .singleResult
        } catch (e: Exception) {
            null
        }
    }

    companion object {
        private val log = LoggerFactory.getLogger(UserService::class.java)
    }
}
