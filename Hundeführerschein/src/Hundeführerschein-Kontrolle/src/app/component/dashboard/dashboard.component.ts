import { Component, OnInit } from '@angular/core';
import {TransferService} from '../../service/transfer.service';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {
  isQrGenerationActive: boolean;
  isProofActive: boolean;

  constructor(private transferService: TransferService) { }

  ngOnInit(): void {
    this.isQrGenerationActive = false;
    this.isProofActive = false;
  }

  createProof(): void {
    this.isQrGenerationActive = true;
  }

  receiveProofStateQr($event): void {
    if ($event != null) {
      this.transferService.setData($event);
      this.isProofActive = true;
    }
    this.isQrGenerationActive = false;
  }

  receiveProofState($event): void {
    this.isProofActive = $event;
  }
}
