import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ProofService {

  constructor(private http: HttpClient) { }

  getPendingProofs(connectionId: string): Observable<any> {
    return this.http.get<any>('/api/getPendingProofs?connectionId=' + connectionId);
  }

  getAcceptedProofs(connectionId: string): Observable<any> {
    return this.http.get<any>('/api/getAcceptedProofs?connectionId=' + connectionId);
  }

  getProofDetails(exchangeId: string): Observable<any> {
    return this.http.get<any>('/api/getProofDetails?exchangeId=' + exchangeId);
  }

  sendProof(connectionId: string): Observable<any> {
    return this.http.post('/api/sendProof?connectionId=' + connectionId, {}, {headers: {'Content-Type':  'application/json'}});
  }

  deleteProof(exchangeId: string): Observable<any> {
    return this.http.post('/api/deleteProof?exchangeId=' + exchangeId, {}, {headers: {'Content-Type':  'application/json'}});
  }
}
