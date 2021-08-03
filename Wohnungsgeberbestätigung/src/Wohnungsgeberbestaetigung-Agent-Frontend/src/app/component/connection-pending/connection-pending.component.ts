import {Component, OnInit} from '@angular/core';
import {ConnectionService} from '../../service/connection.service';
import {debounceTime, startWith, switchMap} from 'rxjs/operators';
import {FormControl} from '@angular/forms';
import {of} from 'rxjs';
import {Router} from '@angular/router';
import {MatSnackBar} from '@angular/material/snack-bar';

@Component({
  selector: 'app-connection-pending',
  templateUrl: './connection-pending.component.html',
  styleUrls: ['./connection-pending.component.css']
})
export class ConnectionPendingComponent implements OnInit {
  pendingConnections: any;
  searchPending = new FormControl();
  $searchPending: any;

  constructor(private connectionService: ConnectionService,
              private snackbar: MatSnackBar,
              private router: Router) { }

  ngOnInit(): void {
    localStorage.setItem('redirect_url', this.router.url);
    this.connectionService.getPendingConnections().subscribe(result => {
      this.pendingConnections = result;
      this.$searchPending = this.searchPending.valueChanges.pipe(
        startWith(null),
        debounceTime(200),
        switchMap((res: string) => {
          if (!res) {
            return of(result);
          }
          res = res.toLowerCase();
          return of(
            this.pendingConnections.filter(x => x.alias.toLowerCase().indexOf(res) >= 0)
          );
        })
      );
      this.pendingConnections.forEach((connection) => {
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
