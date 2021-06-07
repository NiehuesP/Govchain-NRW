import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs';
import {ConnectionSendDto} from '../dto/connection-send-dto';

@Injectable({
  providedIn: 'root'
})
export class ConnectionService {

  constructor(private http: HttpClient) { }

  sendConnection(connectionSendDto: ConnectionSendDto): Observable<any> {
    return this.http.post<any>('/api/createConnection', connectionSendDto);
  }

  getPendingConnections(): Observable<any> {
    return this.http.get<any>('/api/getPendingConnections');
  }

  getActiveConnections(): Observable<any> {
    return this.http.get<any>('/api/getActiveConnections');
  }

  deleteConnection(connectionId: string): Observable<any> {
    return this.http.post('/api/deleteConnection?connectionId=' + connectionId, {});
  }
}
