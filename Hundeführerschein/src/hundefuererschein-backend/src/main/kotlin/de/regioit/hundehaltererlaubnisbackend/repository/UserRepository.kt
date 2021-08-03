package de.regioit.hundehaltererlaubnisbackend.repository

import de.regioit.hundehaltererlaubnisbackend.domain.User
import org.springframework.data.repository.PagingAndSortingRepository
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.stereotype.Repository

@PreAuthorize("hasRole('ADMIN')")
@Repository
interface UserRepository : PagingAndSortingRepository<User, Long> {
    fun findByUsername(username: String) : User
}
