import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CreateventscreenComponent } from './createventscreen.component';

describe('CreateventscreenComponent', () => {
  let component: CreateventscreenComponent;
  let fixture: ComponentFixture<CreateventscreenComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CreateventscreenComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CreateventscreenComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
