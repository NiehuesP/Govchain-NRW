import { Injectable } from '@angular/core';
import {Observable} from 'rxjs';
import {HttpClient} from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class ProofService {

  constructor(private http: HttpClient) { }

  getConnectionlessProof(): Observable<any> {
      return this.http.post<any>('/api/getConnectionlessProof', {});
  }
}
