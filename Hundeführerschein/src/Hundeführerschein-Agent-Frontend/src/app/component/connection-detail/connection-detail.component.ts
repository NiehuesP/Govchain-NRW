import {Component, OnInit} from '@angular/core';
import {CredentialService} from '../../service/credential.service';
import {ActivatedRoute, Router} from '@angular/router';
import {MatDialog, MatDialogConfig} from '@angular/material/dialog';
import {MatSnackBar} from '@angular/material/snack-bar';
import {ConnectionService} from '../../service/connection.service';
import {HundehaltungComponent} from '../hundehaltung/hundehaltung.component';

@Component({
  selector: 'app-connection-detail',
  templateUrl: './connection-detail.component.html',
  styleUrls: ['./connection-detail.component.css']
})
export class ConnectionDetailComponent implements OnInit {
  name: string;
  connectionId: string;
  state: string;
  pendingCredentials: any;
  acceptedCredentials: any;

  constructor(private credentialService: CredentialService,
              private route: ActivatedRoute,
              private dialog: MatDialog,
              private snackbar: MatSnackBar,
              private router: Router,
              private connectionService: ConnectionService) { }

  ngOnInit(): void {
    localStorage.setItem('redirect_url', this.router.url);
    this.name = localStorage.getItem('name');
    this.connectionId = this.route.snapshot.url[2].path;
    this.state = localStorage.getItem('state');
    this.credentialService.getPendingCredentials(this.connectionId).subscribe(result => {
      this.pendingCredentials = result;
      this.pendingCredentials.forEach((connection) => {
        connection.connectionAlias = decodeURIComponent(connection.connectionAlias);
      });
    });

    this.credentialService.getAcceptedCredentials(this.connectionId).subscribe(result => {
      this.acceptedCredentials = result;
      if (this.acceptedCredentials != null) {
        this.acceptedCredentials.forEach((connection) => {
          connection.connectionAlias = decodeURIComponent(connection.connectionAlias);
        });
      }
    });
  }

  redirectTo(uri: string): void{
    this.router.navigateByUrl('/', {skipLocationChange: true}).then(() =>
      this.router.navigate([uri]));
  }

  openHundehaltererlaubnis(): void {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;
    this.dialog.open(HundehaltungComponent, {
      data: {
        connectionId: this.connectionId
      }
    });
  }

  deleteConnection(): void {
    if (confirm('Wollen Sie diese Verbindung wirklich löschen?')) {
      this.connectionService.deleteConnection(this.connectionId).subscribe(result => {
        this.snackbar.open('Verbindung erfolgreich gelöscht', 'Schließen', {duration: 3000});
        this.router.navigate(['connection']);
      });
    }
  }

  deleteCredential(id: string): void {
    if (confirm('Wollen Sie diese Bestätigung wirklich löschen?')) {
      this.credentialService.deleteCredential(id).subscribe(result => {
        this.snackbar.open('Bestätigung erfolgreich gelöscht', 'Schließen', {duration: 3000});
        this.redirectTo('connection/detail/' + this.connectionId);
      });
    }
  }

}
