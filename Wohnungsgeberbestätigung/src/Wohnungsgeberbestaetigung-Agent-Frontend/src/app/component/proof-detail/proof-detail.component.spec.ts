import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ProofDetailComponent } from './proof-detail.component';

describe('ProofDetailComponent', () => {
  let component: ProofDetailComponent;
  let fixture: ComponentFixture<ProofDetailComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ProofDetailComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ProofDetailComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
