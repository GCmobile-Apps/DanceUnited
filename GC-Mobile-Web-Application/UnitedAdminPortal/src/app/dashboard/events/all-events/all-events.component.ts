import {Component, ElementRef, OnDestroy, OnInit, ViewChild} from '@angular/core';
import { Event } from '../../../models/event.model';
import { EventServices } from '../../../shared/services/event-services.service';
import {Subscription} from 'rxjs';
import {ConfirmationService, MessageService} from 'primeng/api';
import {AutoLogout, logout, Preferences, SERVER_PATH} from "../../../models/globals";
import {FileService} from "../../../shared/services/file.service";
import {PreferencesService} from "../../../shared/services/preferences.service";
import {ProfessionalUser} from "../../../models/professionalUser";
import {ProfessionalUserService} from "../../../shared/services/professional-user.service";

@Component({
  selector: 'app-all-events',
  templateUrl: './all-events.component.html',
  styleUrls: ['./all-events.component.scss']
})
export class AllEventsComponent implements OnInit, OnDestroy {
  loader = true;
  allEvents: Event[];
  subscriptions: Subscription[] = [];

  event: Event = {
    EventID: '',
    Title: '',
    Description: '',
    StartDate: '',
    EndDate: '',
    Location: '',
    Prize: '',
    Type: '',
    ImageUrl: '',
    Tags: '',
    notRepeat: '',
    startTime: '',
    endTime: '',
    relatedStyle1: '',
    relatedStyle2: '',
    relatedStyle3: '',
    viewCounter: 0,
    country: '',
    EventProUser: '',
    SeriesEndDate: ''
  };
  professionalUser;
  profUsers = [];
  preferences = [];
  hostTypes = [];
  weekDays = [];
  locations = [];
  prizeOptions = [];
  eventDialog = false;
  imgName = '';
  file;
  noData = false;
  @ViewChild('fileInput') fileInput: ElementRef;
  constructor(private eventService: EventServices, private confirmationService: ConfirmationService,
              private messageService: MessageService, private fileService: FileService,
              private proUserService: ProfessionalUserService,
              private preferencesService: PreferencesService) { }
  ngOnInit(): void {

    // this.preferences = Preferences;
    this.hostTypes = this.eventService.hostTypes;
    this.weekDays = this.eventService.weekDays;
    this.prizeOptions = this.eventService.prizeOptions;
    this.locations = this.eventService.locations;
    this.subscriptions.push(
      this.preferencesService.getAllPreferences().subscribe((res: any) => {
        console.log(res);
        res.list.forEach(p => {
          const obj = {label: p.PreferenceName};
          this.preferences.push(obj);

        })
      })
    );
    this.subscriptions.push(

    this.eventService.getAllEvents().subscribe((res: any) => {
      this.loader = false;
        if(res?.statusCode === 401){
          logout();
          return;
        }
        if(res.status){
          if(res.data.length === 0){
            this.noData = true;
            return;
          }
          console.log(res.data.length);



          for (let i=0; i<res.data.length; i++){

            this.eventService.getProUsersOfEvent(res.data[i].EventID).subscribe((proUserres: any) => {
              if(proUserres?.statusCode === 401){
                console.log("error");
                return;
              }
              if(proUserres.status){


                this.eventService.getProfessionalObject(proUserres['data'][0].userID).subscribe((proobjectres:any)=>{
                    if(proobjectres?.statusCode === 401){
                      console.log("error");
                      return;
                    }
                    if(proobjectres.status){

                      res.data[i] = {...res.data[i] ,EventProUser:proobjectres['data'][0].title};

                    }
                  }
                );

              }
            });

            //res.data[i] = {...res.data[i] ,EventProUser: prouser};
            // console.log("This is professiona user " + this.allEvents[i].EventProUser);
          }

          console.log("This is res data");
          console.log(res);
          this.allEvents = res.data;

          this.allEvents.forEach(i => {
            let s = new Date(i.StartDate);
            let sm = s.getMonth()+1;
            let e = new Date(i.EndDate);
            let em = e.getMonth()+1;
            let se = new Date(i.SeriesEndDate);
            let sem = se.getMonth()+1;
            i.StartDate = s.getFullYear() + '-' + sm+ '-' + s.getDate();
            i.EndDate = e.getFullYear() + '-' + em + '-' + e.getDate();
            i.SeriesEndDate = se.getFullYear() + '-' + sem + '-' + se.getDate();
          })

          console.log("These are events");
          console.log(this.allEvents);

          this.loader = false;
      }

    },
      error => {
        AutoLogout(error)
      }
    ));

  }

  deleteEvent(event): void{
    this.confirmationService.confirm({
      message: 'Are you sure you want to delete ' + event.Title + '?',
      header: 'Confirm',
      icon: 'pi pi-exclamation-triangle',
      accept: () => {
        this.subscriptions.push(
          this.eventService.deleteEvent(event).subscribe((data: any) => {
            if(data?.statusCode === 401){
              logout();
              return;
            }
            const index = this.allEvents.findIndex(val => val.EventID === event.EventID);
            console.log(index);
            this.allEvents.splice(index, 1);
            this.messageService.add({severity: 'success', summary: 'Successful', detail: 'Event Removed', life: 3000});
          },
            error => {
              AutoLogout(error)
            })
        );
      }
    });
  }
  hideDialog(): void{
    this.eventDialog = false;
  }
  openNew(event): void{
    this.event = event;
    this.event.ImageUrl = this.imgName!=''?SERVER_PATH + '/eventImages/' + this.event.EventID + this.imgName.replace(/\s/g, ''): this.event.ImageUrl;
    this.event.startTime = (this.event.startTime);
    this.event.endTime = (this.event.endTime);
    this.eventDialog = true;
    console.log("This is my event");
    console.log(this.event);
  }
  editEvent(){
    this.event.ImageUrl = this.imgName!=''?SERVER_PATH + '/eventImages/' + this.event.EventID + this.imgName.replace(/\s/g, ''): this.event.ImageUrl;

    let s = new Date(this.event.StartDate);
    let sm = s.getMonth()+1;
    let e = new Date(this.event.EndDate);
    let em = e.getMonth()+1;
    let se = new Date(this.event.SeriesEndDate);
    let sem = se.getMonth()+1;
    this.event.StartDate = s.getFullYear() + '-' + sm+ '-' + s.getDate();
    this.event.EndDate = e.getFullYear() + '-' + em + '-' + e.getDate();
    this.event.SeriesEndDate = se.getFullYear() + '-' + sem + '-' + se.getDate();


    console.log("this is the data i am sending");
    console.log(this.event);
    this.subscriptions.push(
      this.eventService.editEvent(this.event).subscribe((data: any) => {
          if(data?.statusCode === 401){
            logout();
            return;
          }
        this.messageService.add({severity: 'success', summary: 'Successful', detail: 'Event Edited', life: 3000});
        this.subscriptions.push(
          this.fileService.uploadUserImage(this.file, 'eventImages', this.event.EventID).subscribe(res => {
            console.log(data);
          })
        );
      },
        error => {
          AutoLogout(error)
        })
    );
    this.eventDialog =  false;
  }
  onFileChanged(event){
    const imageBlob = this.fileInput.nativeElement.files[0];
    this.imgName = this.fileInput.nativeElement.files[0].name;
    this.file = new FormData();
    this.file.set('file', imageBlob);
  }

  GetProIDOfEvent(EventID){

      this.eventService.getProUsersOfEvent(EventID).subscribe((res: any) => {
      if(res?.statusCode === 401){
        console.log("error");
        return;
      }
      if(res.status){


        this.eventService.getProfessionalObject(res['data'][0].userID).subscribe((res:any)=>{
              if(res?.statusCode === 401){
                console.log("error");
                return;
              }
              if(res.status){

                return res['data'][0].title;
                }
          }
        );

      }
    });

  }
  ngOnDestroy(): void {
    this.subscriptions.forEach(sub => sub.unsubscribe());
  }
}
