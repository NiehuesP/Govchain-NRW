import { Injectable } from '@angular/core';
import {Observable} from 'rxjs';
import {HttpClient} from '@angular/common/http';
import {MeldebestaetigungDto} from '../dto/meldebestaetigung-dto';

@Injectable({
  providedIn: 'root'
})
export class CredentialService {

  constructor(private http: HttpClient) { }

  getPendingCredentials(connectionId: string): Observable<any> {
    return this.http.get<any>('/api/getPendingCredentials?connectionId=' + connectionId);
  }

  getAcceptedCredentials(connectionId: string): Observable<any> {
    return this.http.get<any>('/api/getAcceptedCredentials?connectionId=' + connectionId);
  }

  sendMeldebestaetigung(connectionId: string, meldebestaetigungDto: MeldebestaetigungDto): Observable<any> {
    return this.http.post('/api/sendMeldebestaetigung?connectionId=' + connectionId, meldebestaetigungDto, {headers: {'Content-Type':  'application/json'}});
  }

  deleteCredential(id: string): Observable<any> {
    return this.http.post('/api/deleteCredential?id=' + id, {}, {headers: {'Content-Type':  'application/json'}});
  }
}
