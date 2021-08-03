import {Component, OnInit} from '@angular/core';
import {ProofService} from '../../service/proof.service';
import {CredentialService} from '../../service/credential.service';
import {ActivatedRoute, Router} from '@angular/router';
import {MatDialog, MatDialogConfig} from '@angular/material/dialog';
import {ProofDetailComponent} from '../proof-detail/proof-detail.component';
import {MatSnackBar} from '@angular/material/snack-bar';
import {MeldebestaetigungComponent} from '../meldebestaetigung/meldebestaetigung.component';
import {ConnectionService} from '../../service/connection.service';

@Component({
  selector: 'app-connection-detail',
  templateUrl: './connection-detail.component.html',
  styleUrls: ['./connection-detail.component.css']
})
export class ConnectionDetailComponent implements OnInit {
  name: string;
  connectionId: string;
  state: string;
  acceptedProofs: any;
  acceptedCredentials: any;

  constructor(private proofService: ProofService,
              private credentialService: CredentialService,
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

    this.proofService.getAcceptedProofs(this.connectionId).subscribe(result => {
      this.acceptedProofs = result;
      if (this.acceptedProofs != null) {
        this.acceptedProofs.forEach((connection) => {
          connection.alias = decodeURIComponent(connection.alias);
        });
      }
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

  showAttributes(exchangeId: string): void {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;
    this.dialog.open(ProofDetailComponent, {
      data: {
        exchangeId
      }
    });
  }

  sendProof(): void {
    this.proofService.sendProof(this.connectionId).subscribe(result => {
      if (result !== null) {
        this.snackbar.open('Wohnungsgeberbestätigung erfolgreich angefragt', 'Schließen', {duration: 3000});
        this.redirectTo('connection/detail/' + this.connectionId);
      } else {
        this.snackbar.open('Die Wohnungsgeberbestätigung konnte leider nicht angefragt werden', 'Schließen', {duration: 3000});
      }
    });
  }

  sendMeldebestaetigung(): void {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;
    this.dialog.open(MeldebestaetigungComponent, {
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

  deleteProof(exchangeId: string): void {
    if (confirm('Wollen Sie diese Wohnungsgeberbestätigung wirklich löschen?')) {
      this.proofService.deleteProof(exchangeId).subscribe(result => {
        this.snackbar.open('Wohnungsgeberbestätigung erfolgreich gelöscht', 'Schließen', {duration: 3000});
        this.redirectTo('connection/detail/' + this.connectionId);
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
