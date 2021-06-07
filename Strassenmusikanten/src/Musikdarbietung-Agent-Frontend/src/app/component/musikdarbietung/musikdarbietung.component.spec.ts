import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MusikdarbietungComponent } from './musikdarbietung.component';

describe('MusikdarbietungComponent', () => {
  let component: MusikdarbietungComponent;
  let fixture: ComponentFixture<MusikdarbietungComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MusikdarbietungComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MusikdarbietungComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
