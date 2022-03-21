import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Event } from 'src/app/models/event.model';
import {BASE_URL, createAuthHeader} from '../../models/globals';

@Injectable({
  providedIn: 'root'
})
export class EventServices {
  readonly baseURL = BASE_URL;

  hostTypes = [
    {label: 'Social', value: 'Social'},
    {label: 'Festival', value: 'Festival'},
    {label: 'Bootcamp', value: 'Bootcamp'},
    {label: 'Party', value: 'Party'}
  ];
  weekDays = [
    {label: 'Monday', value: 'Monday'},
    {label: 'Tuesday', value: 'Tuesday'},
    {label: 'Wednesday', value: 'Wednesday'},
    {label: 'Thursday', value: 'Thursday'},
    {label: 'Friday', value: 'Friday'},
    {label: 'Saturday', value: 'Saturday'},
    {label: 'Sunday', value: 'Sunday'},
    {label: 'Does not Repeat', value: null},
  ];
  locations = [
    {label: 'Europe', value: 'Europe'},
    {label: 'Sweden', value: 'Sweden'},
    {label: 'Gothenburg', value: 'Gothenburg'},
  ];
  prizeOptions = [
    {label: 'Yes', value: 'Yes'},
    {label: 'No', value: 'No'},
  ];
  header = new HttpHeaders();
  constructor(public http: HttpClient) {}

  getProUsersOfEvent(EventID){
    this.header = createAuthHeader(this.header);
    return this.http.post(this.baseURL + '/GetProIDofEvent', {EventID}, {headers: this.header});
  }
  getProfessionalObject(UserID){
    this.header = createAuthHeader(this.header);
    return this.http.post(this.baseURL + '/GetProfessionalObject', {UserID}, {headers: this.header});
  }

  postEvent(event: Event, userID){
    this.header = createAuthHeader(this.header);
    return this.http.post(this.baseURL + '/createNewEventFromPortal', {event,userID}, {headers: this.header});
  }
  getAllEvents(){
    this.header = createAuthHeader(this.header);
    return this.http.get(this.baseURL + '/getAllEvents', {headers: this.header});
  }

  editEvent(event){
    this.header = createAuthHeader(this.header);
    return this.http.post(this.baseURL + '/updateEvent?eventId=' + event.EventID, event,
      {headers: this.header});
  }

  eventExplore(date:any, location:any, tag:any){
    this.header = createAuthHeader(this.header);
    return this.http.post(this.baseURL + '/getEventsByFilters', {"filters": {"date": date, "location": location, "tag": tag}},
     );
  }
  createevent(event:any){
    console.log(event)
    return this.http.post(this.baseURL + '/addEvent', event)

  }
  getevent(eventid:any){
    return this.http.post(this.baseURL + '/getEvent', {eventId: eventid})

  }
  editevent(event:any){
    console.log(event)
    return this.http.post(this.baseURL + '/editEvent', event)

  }
  getuserevents(){
    return this.http.post(this.baseURL + '/getUserEvents', {userId:localStorage.getItem('userId')} )
  }
  getcalender(){
    return this.http.post(this.baseURL + '/getCalendarLink', {userId:localStorage.getItem('userId')} )

  }
  deleteEvent(eventid:any){
    return this.http.post(this.baseURL + '/deleteEvent', {eventId: eventid} )

  }


}
