package de.regioit.wohnungsgeberbestaetigungbackend.web.rest

import de.regioit.wohnungsgeberbestaetigungbackend.service.RestService
import de.regioit.wohnungsgeberbestaetigungbackend.web.rest.dto.MbstDTO
import de.regioit.wohnungsgeberbestaetigungbackend.web.rest.dto.WgbstDTO
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.*
import javax.validation.Valid

@PreAuthorize("hasRole('ROLE_ADMIN')")
@RestController
class AgentController(
        val restService: RestService
) {
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

    @GetMapping("/api/getPendingProofs")
    fun getPendingProofs(@RequestParam(name = "connectionId") connectionId: String): ResponseEntity<Any> {
        return ResponseEntity(this.restService.getProofs(true, connectionId), HttpStatus.OK)
    }

    @GetMapping("/api/getAcceptedProofs")
    fun getAcceptedProofs(@RequestParam(name = "connectionId") connectionId: String): ResponseEntity<Any> {
        return ResponseEntity(this.restService.getProofs(false, connectionId), HttpStatus.OK)
    }

    @GetMapping("/api/getProofDetails")
    fun getProofDetails(@RequestParam(name = "exchangeId") exchangeId: String): ResponseEntity<Any> {
        return ResponseEntity(this.restService.getProofDetails(exchangeId), HttpStatus.OK)
    }

    @PostMapping("/api/sendProof")
    fun sendProof(@RequestParam(name = "connectionId") connectionId: String): ResponseEntity<Any> {
        return ResponseEntity(this.restService.sendProof(connectionId), HttpStatus.OK)
    }

    @PostMapping("/api/sendMeldebestaetigung")
    fun sendMeldebestaetigung(@RequestParam(name = "connectionId") connectionId: String, @Valid @RequestBody request: MbstDTO): ResponseEntity<Any> {
        return ResponseEntity(this.restService.sendMeldebestaetigung(connectionId, request), HttpStatus.OK)
    }

    @PostMapping("/api/deleteConnection")
    fun deleteConnection(@RequestParam(name = "connectionId") connectionId: String): ResponseEntity<Any> {
        return ResponseEntity(this.restService.deleteConnection(connectionId), HttpStatus.OK)
    }

    @PostMapping("/api/deleteProof")
    fun deleteProof(@RequestParam(name = "exchangeId") exchangeId: String): ResponseEntity<Any> {
        return ResponseEntity(this.restService.deleteProof(exchangeId), HttpStatus.OK)
    }

    @PostMapping("/api/deleteCredential")
    fun deleteCredential(@RequestParam(name = "id") id: String): ResponseEntity<Any> {
        this.restService.revokeCredential(id)
        return ResponseEntity(this.restService.deleteCredential(id), HttpStatus.OK)
    }
}
