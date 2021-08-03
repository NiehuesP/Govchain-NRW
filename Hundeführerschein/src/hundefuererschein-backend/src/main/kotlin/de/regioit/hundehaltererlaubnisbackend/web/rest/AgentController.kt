package de.regioit.hundehaltererlaubnisbackend.web.rest

import de.regioit.hundehaltererlaubnisbackend.service.RestService
import de.regioit.hundehaltererlaubnisbackend.web.rest.dto.ConnectionSendDTO
import de.regioit.hundehaltererlaubnisbackend.web.rest.dto.HundehalterErlaubnisDTO
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import javax.validation.Valid

@RestController
class AgentController(
    private val restService: RestService
) {
    @PostMapping("/api/createConnection")
    fun createConnection(@Valid @RequestBody request: ConnectionSendDTO): ResponseEntity<Any> {
        this.restService.createConnection(request)
        return ResponseEntity({}, HttpStatus.OK)
    }

    @GetMapping("/api/getPendingConnections")
    fun getPendingConnections(): ResponseEntity<Any> {
        return ResponseEntity(this.restService.getConnections(true), HttpStatus.OK)
    }

    @GetMapping("/api/getActiveConnections")
    fun getAcceptedConnections(): ResponseEntity<Any> {
        return ResponseEntity(this.restService.getConnections(false), HttpStatus.OK)
    }

    @GetMapping("/api/getPendingCredentials")
    fun getPendingCredentials(@RequestParam(name = "connectionId") connectionId: String): ResponseEntity<Any> {
        return ResponseEntity(this.restService.getCredentials(true, connectionId), HttpStatus.OK)
    }

    @GetMapping("/api/getAcceptedCredentials")
    fun getAcceptedCredentials(@RequestParam(name = "connectionId") connectionId: String): ResponseEntity<Any> {
        return ResponseEntity(this.restService.getCredentials(false, connectionId), HttpStatus.OK)
    }

    @PostMapping("/api/sendHundehalterErlaubnis")
    fun sendHundehalterErlaubnis(@RequestParam(name = "connectionId") connectionId: String, @Valid @RequestBody request: HundehalterErlaubnisDTO): ResponseEntity<Any> {
        return ResponseEntity(this.restService.sendHundehalterErlaubnis(connectionId, request), HttpStatus.OK)
    }

    @PostMapping("/api/deleteCredential")
    fun deleteCredential(@RequestParam(name = "id") id: String): ResponseEntity<Any> {
        this.restService.revokeCredential(id)
        return ResponseEntity(this.restService.deleteCredential(id), HttpStatus.OK)
    }

    @PostMapping("/api/deleteConnection")
    fun deleteConnection(@RequestParam(name = "connectionId") connectionId: String): ResponseEntity<Any> {
        return ResponseEntity(this.restService.deleteConnection(connectionId), HttpStatus.OK)
    }

    @PostMapping("/api/getConnectionlessProof")
    fun getConnectionlessProof(): ResponseEntity<Any> {
        return ResponseEntity(this.restService.getConnectionlessProof(), HttpStatus.OK)
    }
}
