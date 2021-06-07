import {Component, Inject, OnInit} from '@angular/core';
import {MusikdarbietungDto} from '../../dto/musikdarbietung-dto';
import {CredentialService} from '../../service/credential.service';
import {MatSnackBar} from '@angular/material/snack-bar';
import {MAT_DIALOG_DATA, MatDialogRef} from '@angular/material/dialog';
import {Router} from '@angular/router';
import {DatePipe} from '@angular/common';

@Component({
  selector: 'app-musikdarbietung',
  templateUrl: './musikdarbietung.component.html',
  styleUrls: ['./musikdarbietung.component.css']
})
export class MusikdarbietungComponent implements OnInit {
  musiker: string;
  bereich: string;
  zeitraumVon: Date;
  zeitraumBis: Date;
  musikdarbietungDto: MusikdarbietungDto;

  constructor(private credentialService: CredentialService,
              public snackbar: MatSnackBar,
              @Inject(MAT_DIALOG_DATA) public data: any,
              private dialogRef: MatDialogRef<MusikdarbietungComponent>,
              private router: Router) { }

  ngOnInit(): void {
    this.musikdarbietungDto = new MusikdarbietungDto();
    this.musiker = localStorage.getItem('name').split('(')[0];
  }

  submit(): void {
    const pipe = new DatePipe('de-DE');
    this.musikdarbietungDto.musiker = this.musiker;
    this.musikdarbietungDto.bereich = this.bereich;
    this.musikdarbietungDto.zeitraumVon = pipe.transform(this.zeitraumVon, 'yyyy-MM-dd').toString();
    this.musikdarbietungDto.zeitraumBis = pipe.transform(this.zeitraumBis, 'yyyy-MM-dd').toString();
    this.credentialService.sendMusikdarbietung(this.data.connectionId, this.musikdarbietungDto).subscribe(result => {
      this.snackbar.open('Musikdarbieung erfolgreich gesendet', 'Schließen', {duration: 3000});
      this.router.navigate(['connection/detail', this.data.connectionId]);
    });
  }

  close(): void {
    this.dialogRef.close();
  }
}
