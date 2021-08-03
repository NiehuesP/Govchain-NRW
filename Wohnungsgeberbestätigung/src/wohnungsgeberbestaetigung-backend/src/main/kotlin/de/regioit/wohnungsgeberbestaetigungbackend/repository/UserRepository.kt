package de.regioit.wohnungsgeberbestaetigungbackend.repository

import de.regioit.wohnungsgeberbestaetigungbackend.domain.User
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.PagingAndSortingRepository
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.stereotype.Repository

@PreAuthorize("hasRole('ADMIN')")
@Repository
interface UserRepository : PagingAndSortingRepository<User, Long> {
    fun findByUsername(username: String) : User
}
