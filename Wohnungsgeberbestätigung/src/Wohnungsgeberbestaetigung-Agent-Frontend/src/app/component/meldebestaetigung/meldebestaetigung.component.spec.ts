import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MeldebestaetigungComponent } from './meldebestaetigung.component';

describe('MeldebestaetigungComponent', () => {
  let component: MeldebestaetigungComponent;
  let fixture: ComponentFixture<MeldebestaetigungComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MeldebestaetigungComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MeldebestaetigungComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
