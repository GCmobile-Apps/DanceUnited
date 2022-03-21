import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EventexploreComponent } from './eventexplore.component';

describe('EventexploreComponent', () => {
  let component: EventexploreComponent;
  let fixture: ComponentFixture<EventexploreComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EventexploreComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EventexploreComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
