import {Component, Inject, OnInit} from '@angular/core';
import {CredentialService} from '../../service/credential.service';
import {MatSnackBar} from '@angular/material/snack-bar';
import {MeldebestaetigungDto} from '../../dto/meldebestaetigung-dto';
import {DatePipe} from '@angular/common';
import {MAT_DIALOG_DATA, MatDialogRef} from '@angular/material/dialog';
import {Router} from '@angular/router';

@Component({
  selector: 'app-meldebestaetigung',
  templateUrl: './meldebestaetigung.component.html',
  styleUrls: ['./meldebestaetigung.component.css']
})
export class MeldebestaetigungComponent implements OnInit {
  vorname: string;
  familienname: string;
  rufname: string;
  geborenAm: Date;
  geburtsort: string;
  staatsangeh: string;
  famStand: string;
  religion: string;
  einzigeWohnung: string;
  einzugAm: Date;
  gemeldetSeit: Date;
  gemeindeKennziffer: string;
  meldebestaetigungDto: MeldebestaetigungDto;

  constructor(private credentialService: CredentialService,
              public snackbar: MatSnackBar,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private dialogRef: MatDialogRef<MeldebestaetigungComponent>,
              private router: Router) { }

  ngOnInit(): void {
    this.meldebestaetigungDto = new MeldebestaetigungDto();
  }

  submit(): void {
    const pipe = new DatePipe('de-DE');
    this.meldebestaetigungDto.vorname = this.vorname;
    this.meldebestaetigungDto.familienname = this.familienname;
    this.meldebestaetigungDto.rufname = this.rufname;
    this.meldebestaetigungDto.geborenAm = pipe.transform(this.geborenAm, 'yyyy-MM-dd').toString();
    this.meldebestaetigungDto.geburtsort = this.geburtsort;
    this.meldebestaetigungDto.staatsangeh = this.staatsangeh;
    this.meldebestaetigungDto.famStand = this.famStand;
    this.meldebestaetigungDto.religion = this.religion;
    this.meldebestaetigungDto.einzigeWohnung = this.einzigeWohnung;
    this.meldebestaetigungDto.einzugAm = pipe.transform(this.einzugAm, 'yyyy-MM-dd').toString();
    this.meldebestaetigungDto.gemeldetSeit = pipe.transform(this.gemeldetSeit, 'yyyy-MM-dd').toString();
    this.meldebestaetigungDto.gemeindeKennziffer = this. gemeindeKennziffer;
    this.credentialService.sendMeldebestaetigung(this.data.connectionId, this.meldebestaetigungDto).subscribe(result => {
      this.snackbar.open('Meldebestätigung erfolgreich gesendet', 'Schließen', {duration: 3000});
      this.router.navigate(['connection/detail', this.data.connectionId]);
    });
  }

  closeDialog(): void {
    this.dialogRef.close();
  }
}
