import {Component, EventEmitter, OnInit, Output} from '@angular/core';
import {TransferService} from '../../service/transfer.service';

@Component({
  selector: 'app-proof-detail',
  templateUrl: './proof-detail.component.html',
  styleUrls: ['./proof-detail.component.css']
})
export class ProofDetailComponent implements OnInit {
  proof: any;
  data: any;

  @Output() messageEvent = new EventEmitter<boolean>();

  constructor(private transferService: TransferService) { }

  ngOnInit(): void {
    this.data = this.transferService.getData();
    const key = Object.keys(this.data.attributeValue)[0];
    this.proof = this.data.attributeValue[key].sort(this.getSortOrder('name'));
    this.proof.forEach(attribute => {
      attribute.value = attribute.value.replace(/\n/g, '<br/>');
    });
  }

  getSortOrder(prop): any {
    return (a, b) => {
      if (a[prop] > b[prop]) {
        return 1;
      } else if (a[prop] < b[prop]) {
        return -1;
      }
      return 0;
    };
  }

  closeProofDetailView(): void {
    this.sendProofState(false);
  }

  sendProofState(state: boolean): void {
    this.messageEvent.emit(state);
  }
}
