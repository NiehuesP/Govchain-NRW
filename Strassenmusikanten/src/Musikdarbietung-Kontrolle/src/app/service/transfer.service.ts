import {Injectable} from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class TransferService {
  private data;

  constructor() { }

  setData(data): void {
    this.data = data;
  }

  getData(): any {
    const temp = this.data;
    this.clearData();
    return temp;
  }

  private clearData(): void {
    this.data = undefined;
  }
}
