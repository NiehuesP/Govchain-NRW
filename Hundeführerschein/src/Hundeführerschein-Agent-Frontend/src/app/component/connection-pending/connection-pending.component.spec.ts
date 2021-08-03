import {ComponentFixture, TestBed} from '@angular/core/testing';

import {ConnectionPendingComponent} from './connection-pending.component';

describe('ConnectionPendingComponent', () => {
  let component: ConnectionPendingComponent;
  let fixture: ComponentFixture<ConnectionPendingComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ConnectionPendingComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ConnectionPendingComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
