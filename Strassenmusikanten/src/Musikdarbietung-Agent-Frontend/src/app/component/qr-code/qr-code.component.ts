import {Component, OnInit} from '@angular/core';
import {ConnectionService} from '../../service/connection.service';
import {ConnectionSendDto} from '../../dto/connection-send-dto';
import {MatDialogRef} from '@angular/material/dialog';
import {MatSnackBar} from '@angular/material/snack-bar';

@Component({
  selector: 'app-qr-code',
  templateUrl: './qr-code.component.html',
  styleUrls: ['./qr-code.component.css']
})
export class QrCodeComponent implements OnInit {
  name: string;
  email: string;
  telefonnummer: string;
  connectionSendDto: ConnectionSendDto;

  constructor(
    private connectionService: ConnectionService,
    public snackbar: MatSnackBar,
    private dialogRef: MatDialogRef<QrCodeComponent>
  ) { }

  ngOnInit(): void {
    this.name = '';
    this.email = null;
    this.telefonnummer = null;
    this.connectionSendDto = new ConnectionSendDto();
  }

  sendConnection(): void {
    this.connectionSendDto.name = this.name;
    this.connectionSendDto.email = this.email;
    this.connectionSendDto.telefonnummer = this.telefonnummer;
    this.connectionService.sendConnection(this.connectionSendDto).subscribe( result => {
      this.snackbar.open('Verbindungsanfrage erfolgreich gesendet', 'Schließen', {duration: 3000});
      this.dialogRef.close();
    });
  }

  close(): void {
    this.dialogRef.close();
  }
}
