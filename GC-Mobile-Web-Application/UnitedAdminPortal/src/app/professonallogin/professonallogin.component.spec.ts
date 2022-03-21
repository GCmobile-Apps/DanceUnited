import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ProfessonalloginComponent } from './professonallogin.component';

describe('ProfessonalloginComponent', () => {
  let component: ProfessonalloginComponent;
  let fixture: ComponentFixture<ProfessonalloginComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ProfessonalloginComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ProfessonalloginComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
