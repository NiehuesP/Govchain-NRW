import {Component, Inject, OnInit} from '@angular/core';
import {HundehaltungDto} from '../../dto/hundehaltung-dto';
import {MAT_DIALOG_DATA, MatDialogRef} from '@angular/material/dialog';
import {CredentialService} from '../../service/credential.service';
import {Router} from '@angular/router';
import {MatSnackBar} from '@angular/material/snack-bar';
import {DatePipe} from '@angular/common';

@Component({
  selector: 'app-hundehaltung',
  templateUrl: './hundehaltung.component.html',
  styleUrls: ['./hundehaltung.component.css']
})
export class HundehaltungComponent implements OnInit {
  halter: string;
  befreiung: string;
  rasse: string;
  name: string;
  fellfarbe: string;
  geschlecht: string;
  geburtstag: Date;
  chipnr: string;
  haltungsErlaubnis: Date;
  hundehaltungDto: HundehaltungDto;

  constructor(private credentialService: CredentialService,
              public snackbar: MatSnackBar,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private dialogRef: MatDialogRef<HundehaltungComponent>,
              private router: Router) { }

  ngOnInit(): void {
    this.hundehaltungDto = new HundehaltungDto();
    this.halter = localStorage.getItem('name').split('(')[0];
  }

  submit(): void {
    const pipe = new DatePipe('de-DE');
    this.hundehaltungDto.halter = this.halter;
    this.hundehaltungDto.befreiung = this.befreiung;
    this.hundehaltungDto.rasse = this.rasse;
    this.hundehaltungDto.name = this.name;
    this.hundehaltungDto.fellfarbe = this.fellfarbe;
    this.hundehaltungDto.geschlecht = this.geschlecht;
    this.hundehaltungDto.geburtstag = pipe.transform(this.geburtstag, 'yyyy-MM-dd').toString();
    this.hundehaltungDto.chipnr = this.chipnr;
    this.hundehaltungDto.haltungsErlaubnis = pipe.transform(this.haltungsErlaubnis, 'yyyy-MM-dd').toString();
    this.credentialService.sendHundehaltererlaubnis(this.data.connectionId, this.hundehaltungDto).subscribe(result => {
      this.snackbar.open('Hundehaltererlaubnis erfolgreich gesendet', 'Schließen', {duration: 3000});
      this.router.navigate(['connection/detail', this.data.connectionId]);
    });
  }

  close(): void {
    this.dialogRef.close();
  }
}
