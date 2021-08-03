package de.regioit.hundehaltererlaubnisbackend.web.rest.errors

import org.springframework.dao.DataIntegrityViolationException
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.context.request.WebRequest
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler

@ControllerAdvice
class ExceptionTranslator : ResponseEntityExceptionHandler() {

    @ExceptionHandler
    fun handleDataIntegrityViolationException(ex: DataIntegrityViolationException, request: WebRequest): ResponseEntity<Any> {
        return this.handleExceptionInternal(ex, null, HttpHeaders.EMPTY, HttpStatus.CONFLICT, request)
    }
}
