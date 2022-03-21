import {Component, ElementRef, OnDestroy, OnInit, ViewChild} from '@angular/core';
import { NgForm } from '@angular/forms';
import { EventServices } from 'src/app/shared/services/event-services.service';
import * as uuid from 'uuid';
import {Subscription} from 'rxjs';
import {FileService} from '../../shared/services/file.service';
import {Event} from '../../models/event.model';
import {AutoLogout, logout, Preferences, SERVER_PATH, v4options} from '../../models/globals';
import {ProfessionalUserService} from "../../shared/services/professional-user.service";
import {PreferencesService} from "../../shared/services/preferences.service";
import {MessageService} from "primeng/api";

@Component({
  selector: 'app-events',
  templateUrl: './events.component.html',
  styleUrls: ['./events.component.scss']
})
export class EventsComponent implements OnInit, OnDestroy {
  EventID;
  event: Event;
  preferences = [];
  hostTypes = [];
  weekDays = [];
  locations = [];
  prizeOptions = [];
  eventDialog = false;
  eventFile;
  imgName = '';
  subscriptions: Subscription[] = [];
  proUsers = [];

  @ViewChild('userForm') userForm: NgForm;
  @ViewChild('fileInput') fileInput: ElementRef;
  constructor(public eventService: EventServices, private fileService: FileService,
              private proUserService: ProfessionalUserService,
              private preferencesService: PreferencesService,
              private msgService: MessageService) { }

  ngOnInit(): void {
    // this.preferences = Preferences;
    this.EventID = uuid.v4();
    this.hostTypes = this.eventService.hostTypes;
    this.weekDays = this.eventService.weekDays;
    this.prizeOptions = this.eventService.prizeOptions;
    this.locations = this.eventService.locations;

    this.subscriptions.push(
      this.preferencesService.getAllPreferences().subscribe((res: any) => {
        res.list.forEach(p => {
          const obj = {label: p.PreferenceName};
          this.preferences.push(obj);
        })
      })
    );
    this.subscriptions.push(
      this.proUserService.getAllUsers().subscribe((res: any) => {
        if(res?.statusCode === 401){
          logout();
          return;
        }
        if(res.status){
          this.proUsers = res.data;
        }
      },
        error => {
          AutoLogout(error)
        }
      )
    );
  }
   formatAMPM(date) {
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var ampm = hours >= 12 ? 'pm' : 'am';
    hours = hours % 12;
    hours = hours ? hours : 12; // the hour '0' should be '12'
    minutes = minutes < 10 ? '0'+minutes : minutes;
    var strTime = hours + ':' + minutes + ' ' + ampm;
    return strTime;
  }
  onSubmit(form: NgForm) {

    this.event = {
      Description: form.value.Description,
      EndDate: form.value.endDate,
      EventID: form.value.EventID,
      ImageUrl: this.imgName!=''?SERVER_PATH + '/eventImages/' + form.value.EventID + this.imgName.replace(/\s/g, ''):'',
      Location: form.value.Location,
      Prize: form.value.Prize,
      StartDate: form.value.StartDate,
      Tags: form.value.Tags,
      Title: form.value.Title,
      Type: form.value.hostType,
      endTime: this.formatAMPM(form.value.endTime),
      notRepeat: form.value.notRepeat,
      relatedStyle1: form.value.relatedStyle1 ,
      relatedStyle2: form.value.relatedStyle2,
      relatedStyle3: form.value.relatedStyle3,
      startTime: this.formatAMPM(form.value.startTime),
//      viewCounter: form.value.viewCounter,
      viewCounter: 0,
      country: form.value.country,
      EventProUser: '',
      SeriesEndDate: form.value.SeriesEndDate
    };

    let proUserID = form.value.proUser;
    this.event.viewCounter = +this.event.viewCounter;

    console.log("this is i am sending to backend");
    console.log(this.event);
    this.subscriptions.push(this.eventService.postEvent(this.event, proUserID ).subscribe((res: any) => {
      if(res?.statusCode === 401){
        logout();
        return;
      }
      this.subscriptions.push(this.fileService.uploadUserImage(this.eventFile, 'eventImages', this.event.EventID).subscribe(response => {
        this.msgService.add({severity:'success', summary:'Event Added', detail:'', life:4000})
        this.userForm.reset();

      }));
    },
      error => {
        AutoLogout(error)
      }
    ));
  }
  onFileChanged(event){
    const imageBlob = this.fileInput.nativeElement.files[0];
    this.eventFile = new FormData();
    this.imgName = this.fileInput.nativeElement.files[0].name;
    this.eventFile.set('file', imageBlob);
    console.log(this.eventFile);

  }
  print(time){
    console.log(time);
  }
  ngOnDestroy() {
    this.subscriptions.forEach(sub => sub.unsubscribe());
  }


}
