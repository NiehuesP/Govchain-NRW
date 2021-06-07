import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs';
import {MusikdarbietungDto} from '../dto/musikdarbietung-dto';

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

  sendMusikdarbietung(connectionId: string, musikdarbietungDto: MusikdarbietungDto): Observable<any> {
    return this.http.post('/api/sendMusikdarbietung?connectionId=' + connectionId, musikdarbietungDto, {headers: {'Content-Type':  'application/json'}});
  }

  deleteCredential(id: string): Observable<any> {
    return this.http.post('/api/deleteCredential?id=' + id, {}, {headers: {'Content-Type':  'application/json'}});
  }
}
