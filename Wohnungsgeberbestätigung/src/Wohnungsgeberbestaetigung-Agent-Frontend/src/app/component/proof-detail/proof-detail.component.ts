import {Component, Inject, OnInit} from '@angular/core';
import {MAT_DIALOG_DATA, MatDialogRef} from '@angular/material/dialog';
import {ProofService} from '../../service/proof.service';

@Component({
  selector: 'app-proof-detail',
  templateUrl: './proof-detail.component.html',
  styleUrls: ['./proof-detail.component.css']
})
export class ProofDetailComponent implements OnInit {
  proof: any;

  constructor(@Inject(MAT_DIALOG_DATA) public data: any,
              private proofService: ProofService,
              private dialogRef: MatDialogRef<ProofDetailComponent>) { }

  ngOnInit(): void {
    this.proofService.getProofDetails(this.data.exchangeId).subscribe(result => {
      const key = Object.keys(result.attributeValue)[0];
      this.proof = result.attributeValue[key].sort(this.getSortOrder('name'));
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

  close(): void {
    this.dialogRef.close();
  }
}
