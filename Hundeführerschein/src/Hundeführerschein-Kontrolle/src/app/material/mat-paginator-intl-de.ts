import {MatPaginatorIntl} from '@angular/material/paginator';

export class MatPaginatorIntlDe extends MatPaginatorIntl {
  itemsPerPageLabel = 'Einträge pro Seite';
  nextPageLabel = 'Nächste';
  previousPageLabel = 'Vorherige';

  getRangeLabel = (page, pageSize, length) => {
    if (length === 0 || pageSize === 0) {
      return '0 von ' + length;
    }
    length = Math.max(length, 0);
    const startIndex = page * pageSize;
    const endIndex = startIndex < length ?
      Math.min(startIndex + pageSize, length) :
      startIndex + pageSize;
    return startIndex + 1 + ' - ' + endIndex + ' von ' + length;
  }
}
