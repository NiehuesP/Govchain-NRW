package de.regioit.hundehaltererlaubnisbackend.web.rest.vm

import javax.validation.constraints.NotNull
import javax.validation.constraints.Size

class LoginVM {
    var username: @NotNull @Size(min = 1, max = 50) String? = null
    var password: @NotNull @Size(min = 4, max = 100) String? = null

    override fun toString(): String {
        return "LoginVM{" +
                "username='" + username + '\'' +
                '}'
    }
}
