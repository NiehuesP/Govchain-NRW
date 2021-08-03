package de.regioit.hundehaltererlaubnisbackend.domain

import com.fasterxml.jackson.annotation.JsonIgnore
import lombok.Data
import lombok.EqualsAndHashCode
import org.hibernate.validator.constraints.SafeHtml
import java.util.*
import javax.persistence.*
import javax.validation.constraints.NotBlank
import javax.validation.constraints.NotNull

@Data
@EqualsAndHashCode(of = ["id"])
@Entity
@Table(name = "app_user")
class User {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private val id: Long? = null
    var username: @NotBlank @SafeHtml(whitelistType = SafeHtml.WhiteListType.NONE) String? = null

    @JsonIgnore //@NotBlank
    private var password: String? = null
    val roleName: @NotNull String? = null
    @PrePersist
    private fun beforeCreate() {
        if (username != null) username = username!!.toLowerCase(Locale.ENGLISH)
    }

    @PreUpdate
    private fun beforeSave() {
        if (username != null) username = username!!.toLowerCase(Locale.ENGLISH)
    }

    fun setPassword(encryptedPassword: String?) {
        this.password = encryptedPassword
    }
}
