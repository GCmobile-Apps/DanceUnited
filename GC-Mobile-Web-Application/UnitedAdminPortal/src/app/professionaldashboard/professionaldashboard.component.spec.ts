import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ProfessionaldashboardComponent } from './professionaldashboard.component';

describe('ProfessionaldashboardComponent', () => {
  let component: ProfessionaldashboardComponent;
  let fixture: ComponentFixture<ProfessionaldashboardComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ProfessionaldashboardComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ProfessionaldashboardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
