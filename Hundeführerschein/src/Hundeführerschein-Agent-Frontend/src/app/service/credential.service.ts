import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs';
import {HundehaltungDto} from '../dto/hundehaltung-dto';

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

  sendHundehaltererlaubnis(connectionId: string, hundehaltungDto: HundehaltungDto): Observable<any> {
    return this.http.post('/api/sendHundehalterErlaubnis?connectionId=' + connectionId, hundehaltungDto, {headers: {'Content-Type':  'application/json'}});
  }

  deleteCredential(id: string): Observable<any> {
    return this.http.post('/api/deleteCredential?id=' + id, {}, {headers: {'Content-Type':  'application/json'}});
  }
}
