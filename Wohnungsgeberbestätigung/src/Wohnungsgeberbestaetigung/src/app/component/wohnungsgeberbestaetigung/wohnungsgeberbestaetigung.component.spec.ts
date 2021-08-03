import { ComponentFixture, TestBed } from '@angular/core/testing';

import { WohnungsgeberbestaetigungComponent } from './wohnungsgeberbestaetigung.component';

describe('WohnungsgeberbestaetigungComponent', () => {
  let component: WohnungsgeberbestaetigungComponent;
  let fixture: ComponentFixture<WohnungsgeberbestaetigungComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ WohnungsgeberbestaetigungComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(WohnungsgeberbestaetigungComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
