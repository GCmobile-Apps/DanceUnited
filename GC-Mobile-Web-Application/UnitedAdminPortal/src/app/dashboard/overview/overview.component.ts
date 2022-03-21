import {Component, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {Subscription} from "rxjs";
import {EventServices} from "../../shared/services/event-services.service";
import {UsersService} from "../../shared/services/users.service";
import {ProfessionalUserService} from "../../shared/services/professional-user.service";
import {AutoLogout, eventTypes, logout} from "../../models/globals";

@Component({
  selector: 'app-overview',
  templateUrl: './overview.component.html',
  styleUrls: ['./overview.component.scss']
})
export class OverviewComponent implements OnInit, OnDestroy {
  loader = true;
  subscriptions: Subscription[] = [];
  users = [];
  proUsers = [];
  events = [];
  statsCategories = [];
  cats = [];
  constructor(private eventService: EventServices, private userService: UsersService,
              private proUserService: ProfessionalUserService) { }
  ngOnInit(): void {
    for (let i=0;i<eventTypes.length;i++){
      this.statsCategories.push({eventType: eventTypes[i], totalCount: 0,activeCount:0});
    }
    this.subscriptions.push(
      this.userService.getAllUsers().subscribe((users:any) => {
        if(users?.statusCode === 401){
          logout();
          return;
        }
        this.users = users.data;
      },
        error => {
          AutoLogout(error)
        }
      )
    );
    this.subscriptions.push(
      this.proUserService.getAllUsers().subscribe((proUsers: any) => {
        if(proUsers?.statusCode === 401){
          logout();
          return;
        }
        this.proUsers = proUsers.data;
      },
        error => {
          AutoLogout(error)
        }
      )
    );
    this.subscriptions.push(
      this.eventService.getAllEvents().subscribe((events: any) => {
        if(events?.statusCode === 401){
          logout();
          return;
        }
        this.loader = false;
        this.events = events.data;
        let index = this.statsCategories.findIndex(i => i.eventType==='Events');
        this.statsCategories[index].totalCount = this.events.length;
        index = this.statsCategories.findIndex(i => i.eventType === 'Professionals');
        this.statsCategories[index].totalCount = this.proUsers.length;
        index = this.statsCategories.findIndex(i => i.eventType === 'Dancers');
        this.statsCategories[index].totalCount = this.users.length;
        for (let  i=0;i<this.statsCategories.length;i++){
          for(let j=0; j<this.events.length;j++){
            if(this.events[j].Type === this.statsCategories[i].eventType){
              this.statsCategories[i].totalCount++;
            }
          }
        }
      },
        error => {
          AutoLogout(error)
        }
     )
    );
  }
  ngOnDestroy() {
    this.subscriptions.forEach(sub => sub.unsubscribe());
  }

}
