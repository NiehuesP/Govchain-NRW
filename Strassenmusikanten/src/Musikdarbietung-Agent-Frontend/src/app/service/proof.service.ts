import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ProofService {

  constructor(private http: HttpClient) { }

  sendProof(connectionId: string): Observable<any> {
    return this.http.post<any>('/api/sendProof?connectionId=' + connectionId, {});
  }
}
