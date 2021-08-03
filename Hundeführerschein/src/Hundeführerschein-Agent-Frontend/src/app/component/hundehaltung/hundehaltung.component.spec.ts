import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HundehaltungComponent } from './hundehaltung.component';

describe('HundehaltungComponent', () => {
  let component: HundehaltungComponent;
  let fixture: ComponentFixture<HundehaltungComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ HundehaltungComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(HundehaltungComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
