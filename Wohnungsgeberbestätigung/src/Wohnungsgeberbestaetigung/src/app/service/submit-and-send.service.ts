import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders, HttpParams} from '@angular/common/http';
import {Observable} from 'rxjs';
import {WohnungsgeberbestaetigungDto} from '../dto/wohnungsgeberbestaetigung-dto';

@Injectable({
  providedIn: 'root'
})
export class SubmitAndSendService {

  constructor(private http: HttpClient) { }

  send(dto: WohnungsgeberbestaetigungDto): Observable<any> {
    return this.http.post('/api/send', dto, {headers: {'Content-Type':  'application/json'}});
  }
}
