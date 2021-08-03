import {Component, OnInit} from '@angular/core';
import {ConnectionService} from '../../service/connection.service';
import {FormControl} from '@angular/forms';
import {debounceTime, startWith, switchMap} from 'rxjs/operators';
import {of} from 'rxjs';
import {MatSnackBar} from '@angular/material/snack-bar';
import {Router} from '@angular/router';

@Component({
  selector: 'app-connection',
  templateUrl: './connection.component.html',
  styleUrls: ['./connection.component.css']
})
export class ConnectionComponent implements OnInit {
  activeConnections: any;
  searchActive = new FormControl();
  $searchActive: any;

  constructor(private connectionService: ConnectionService,
              private snackbar: MatSnackBar,
              private router: Router) { }

  ngOnInit(): void {
    localStorage.setItem('redirect_url', this.router.url);
    this.connectionService.getActiveConnections().subscribe(result => {
      this.activeConnections = result;
      this.$searchActive = this.searchActive.valueChanges.pipe(
        startWith(null),
        debounceTime(200),
        switchMap((res: string) => {
          if (!res) { return of(result); }
          res = res.toLowerCase();
          return of(
            this.activeConnections.filter(x => x.alias.toLowerCase().indexOf(res) >= 0)
          );
        })
      );
      this.activeConnections.forEach((connection) => {
        connection.alias = decodeURIComponent(connection.alias);
      });
    });
  }

  storeState(state: string): void {
    localStorage.setItem('state', state);
  }

  storeName(name: string): void {
    localStorage.setItem('name', name);
  }

  deleteConnection(connectionId: string): void {
    if (confirm('Wollen Sie diese Verbindung wirklich löschen?')) {
      this.connectionService.deleteConnection(connectionId).subscribe(result => {
        this.snackbar.open('Verbindung erfolgreich gelöscht', 'Schließen', {duration: 3000});
        window.location.reload();
      });
    }
  }
}
