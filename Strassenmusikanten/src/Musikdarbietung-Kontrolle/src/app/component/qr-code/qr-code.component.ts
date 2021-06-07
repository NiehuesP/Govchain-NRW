import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import {MatSnackBar} from '@angular/material/snack-bar';
import {MatDialogConfig} from '@angular/material/dialog';
import {ProofService} from '../../service/proof.service';
import * as Stomp from 'stompjs';
import * as SockJS from 'sockjs-client';
import {ProofState} from '../../enum/proof-state';

@Component({
  selector: 'app-qr-code',
  templateUrl: './qr-code.component.html',
  styleUrls: ['./qr-code.component.css']
})
export class QrCodeComponent implements OnInit {
  qr: string;
  exchangeId: string;
  serverUrl = '/api/socket';
  generator = '/proof/status/';
  stompClient;
  serverStatus: boolean;

  @Output() messageEvent = new EventEmitter<any>();

  constructor(public snackbar: MatSnackBar,
              private proofService: ProofService) { }

  ngOnInit(): void {
    this.qr = '';
    this.proofService.getConnectionlessProof().subscribe( result => {
      this.qr = result.proofUrl;
      this.exchangeId = result.exchangeId;
      this.establishWebsocket(this.serverUrl, this.generator);
    });
  }

  establishWebsocket(serverUrl, generator): void {
    const ws = new SockJS(serverUrl);
    this.stompClient = Stomp.over(ws);
    this.stompClient.heartbeat.outgoing = 20000;
    const that = this;
    // tslint:disable-next-line:only-arrow-functions
    this.stompClient.connect({}, function(frame): void {
      that.serverStatus = true;
      that.stompClient.reconnect_delay = 5000;
      that.stompClient.subscribe(generator + that.exchangeId, (message) => {
        const body = JSON.parse(message.body);
        console.log(body);
        if (body.proof.state.toString() === ProofState.Verified) {
          that.stompClient.disconnect();
          const dialogConfig = new MatDialogConfig();
          dialogConfig.autoFocus = true;
          that.sendProofState(body);
        }
      });
      // tslint:disable-next-line:only-arrow-functions
    }, function(error): void {
      that.serverStatus = false;
    });
  }

  sendProofState(body: any): void {
    this.messageEvent.emit(body);
  }

}
