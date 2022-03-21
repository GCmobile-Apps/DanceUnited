import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import {MenuItem} from 'primeng/api';
import {SelectItem} from 'primeng/api';
import {SelectItemGroup} from 'primeng/api';
import { EventServices} from "src/app/shared/services/event-services.service";
interface City {
  name: string,
  code: string
}
@Component({
  selector: 'app-listevent',
  templateUrl: './listevent.component.html',
  styleUrls: ['./listevent.component.scss']
})
export class ListeventComponent implements OnInit {

  date = '' ;
  location = '';
  tag = '';
  showcreatedevent = false; 
  deleteevent = true;
  editmodal:false;
  displayBasic: boolean;
  displayModal: boolean;
  displayModal2:boolean;
  eventid:any;
  uploadedFiles: File | undefined
  event  = {
    eventfile: '',
    eventname: '',
    eventtype:'Classes',
    startdate:'',
    starttime:'',
    enddate:'',
    endtime:'',
    repeatingday:'Monday',
    description:'',
    mainstyle:'Kizomba',
    related1:'Kizomba',
    related2:'Kizomba',
    related3:'Kizomba',
    city:'Gothenburg',
    country:'Sweden',
  }

  formData = new FormData();
  dancetype: any[];
  cities: any[];
  repeat:any[];
  main:any[];
  relatedstyle1:any[];
  relatedstyle2:any[];
  relatedstyle3:any[];
  countries:any[];


    
  events = [

  ];
  
 
  selectedCity1: City;
  constructor( private router: Router, private eventService: EventServices , private auth:EventServices) {
  
    
    this.repeat = [
      {name:"None"},
      {name:"Monday"},
      {name:"Tuesday"},
      {name:"Wednesday"},
      {name:"Thursday"},
      {name:"Friday"},
      {name:"Saturday"},
      {name:"Sunday"},
    ]
    this.cities = [
      {name: 'Malmö'},
      {name: 'Gothenburg'},
      {name: 'Copenhagen'},
      {name: 'Stockholm'},
      {name: 'Västra Götalands län'},
      {name:'Oslo'},
      {name:'Paris'},
    ];
    this.dancetype = [
      {name:"Classes"},
      {name:"Festival"},
      {name:"Party"},
      {name:"Social"},
  
    ];
    this.main = [
      {name:"Zouk"},
      {name:"Salsa"},
      {name:"Bachata"},
      {name:"West Coast Swing"},
      {name:"UrbanKiz"},
      {name:"Cuban Salsa"},
      {name:"Kizomba"},
      {name:"Domenican Bachata"},
      {name:"Tango"},
      {name:"Bachata Sensual"}
    ];
    this.relatedstyle1 = [
      {name:"Zouk"},
      {name:"Salsa"},
      {name:"Bachata"},
      {name:"West Coast Swing"},
      {name:"UrbanKiz"},
      {name:"Cuban Salsa"},
      {name:"Kizomba"},
      {name:"Domenican Bachata"},
      {name:"Tango"},
      {name:"Bachata Sensual"}
    ]
    this.relatedstyle2 = [
      {name:"Zouk"},
      {name:"Salsa"},
      {name:"Bachata"},
      {name:"West Coast Swing"},
      {name:"UrbanKiz"},
      {name:"Cuban Salsa"},
      {name:"Kizomba"},
      {name:"Domenican Bachata"},
      {name:"Tango"},
      {name:"Bachata Sensual"}
    ]
    this.relatedstyle3 = [
      {name:"Zouk"},
      {name:"Salsa"},
      {name:"Bachata"},
      {name:"West Coast Swing"},
      {name:"UrbanKiz"},
      {name:"Cuban Salsa"},
      {name:"Kizomba"},
      {name:"Domenican Bachata"},
      {name:"Tango"},
      {name:"Bachata Sensual"}
    ]
    this.countries = [
      {name:"Sweden"},
      {name:"Denmark"},
      {name:"Istanbul"},
      {name:"Norway"},
    ]


    
  }
  ngOnInit(): void {
    this.event.country = this.countries[0]
    this.event.city = this.cities[0]
    this.event.mainstyle = this.main[0]
    this.event.eventtype = this.dancetype[0]
    this.event.repeatingday = this.repeat[0]
    this.event.related1 =  this.relatedstyle1[0]
    this.event.related2 = this.relatedstyle2[0]
    this.event.related3 = this.relatedstyle3[0]
    this.getevents();
  }
// tslint:disable-next-line:typedef
getevent(eventid:any) {
  this.displayModal2 = true;
  this.eventid = eventid;
  console.log("??????",this.eventid);
  this.eventService.getevent(eventid).subscribe((res: any) => {
    console.log(res.event);
    this.event.eventname = res.event.Title;
    this.event.eventtype =  (res.event.Type == 'Classes')?this.dancetype[0]:(res.event.Type == 'Festival')?this.dancetype[1]:(res.event.Type == 'Party')?this.dancetype[2]:this.dancetype[3];
    this.event.startdate = new Date(Date.parse(res.event.StartDate)).toISOString().slice(0, 10);
    this.event.enddate = new Date(Date.parse(res.event.EndDate)).toISOString().slice(0, 10);
    this.event.starttime = res.event.startTime;
    this.event.endtime =  res.event.endTime;
    this.event.repeatingday = (res.event.notRepeat == 'None')?this.repeat[0]:(res.event.notRepeat == 'Monday')?this.repeat[1]:(res.event.notRepeat == 'Tuesday')?this.repeat[2]:(res.event.notRepeat == 'Wednesday')?this.repeat[3]:
    (res.event.notRepeat == 'Thursday')?this.repeat[4]:(res.event.notRepeat == 'Friday')?this.repeat[5]:(res.event.notRepeat == 'Saturday')?this.repeat[6]:this.repeat[7];
    this.event.eventfile = res.event.ImageUrl;
    this.event.description =  res.event.Description;
    this.event.mainstyle =  (res.event.Tags == 'Zouk')?this.main[0]:(res.event.Tags == 'Salsa')?this.main[1]:(res.event.Tags == 'Bachata')?this.main[2]:
    (res.event.Tags == 'West Coast Swing')?this.main[3]:(res.event.Tags == 'UrbanKiz')?this.main[4]:(res.event.Tags == 'Cuban Salsa')?this.main[5]:(res.event.Tags == 'Kizomba')?this.main[6]:(res.event.Tags == 'Domenican Bachata')?this.main[7]:(res.event.Tags == 'Tango')?this.main[8]:this.main[9];
   
    this.event.related1 =  (res.event.relatedStyle1 == 'Zouk')?this.relatedstyle1[0]:(res.event.relatedStyle1 == 'Salsa')?this.relatedstyle1[1]:(res.event.relatedStyle1 == 'Bachata')?this.relatedstyle1[2]:
    (res.event.relatedStyle1 == 'West Coast Swing')?this.relatedstyle1[3]:(res.event.relatedStyle1 == 'UrbanKiz')?this.relatedstyle1[4]:(res.event.relatedStyle1 == 'Cuban Salsa')?this.relatedstyle1[5]:(res.event.relatedStyle1 == 'Kizomba')?this.relatedstyle1[6]:(res.event.relatedStyle1 == 'Domenican Bachata')?this.relatedstyle1[7]:(res.event.relatedStyle1 == 'Tango')?this.relatedstyle1[8]:this.relatedstyle1[9];
     
    this.event.related2 =  (res.event.relatedStyle2 == 'Zouk')?this.relatedstyle2[0]:(res.event.relatedStyle2 == 'Salsa')?this.relatedstyle2[1]:(res.event.relatedStyle2 == 'Bachata')?this.relatedstyle2[2]:
    (res.event.relatedStyle2 == 'West Coast Swing')?this.relatedstyle2[3]:(res.event.relatedStyle2 == 'UrbanKiz')?this.relatedstyle2[4]:(res.event.relatedStyle2 == 'Cuban Salsa')?this.relatedstyle2[5]:(res.event.relatedStyle2 == 'Kizomba')?this.relatedstyle2[6]:(res.event.relatedStyle2== 'Domenican Bachata')?this.relatedstyle2[7]:(res.event.relatedStyle2 == 'Tango')?this.relatedstyle2[8]:this.relatedstyle2[9];
    this.event.related3 =  (res.event.relatedStyle3 == 'Zouk')?this.relatedstyle3[0]:(res.event.relatedStyle3 == 'Salsa')?this.relatedstyle3[1]:(res.event.relatedStyle3 == 'Bachata')?this.relatedstyle3[2]:
    (res.event.relatedStyle3 == 'West Coast Swing')?this.relatedstyle3[3]:(res.event.relatedStyle3 == 'UrbanKiz')?this.relatedstyle3[4]:(res.event.relatedStyle3 == 'Cuban Salsa')?this.relatedstyle3[5]:(res.event.relatedStyle3 == 'Kizomba')?this.relatedstyle3[6]:(res.event.relatedStyle3 == 'Domenican Bachata')?this.relatedstyle3[7]:(res.event.relatedStyle3 == 'Tango')?this.relatedstyle3[8]:this.relatedstyle3[9];
    this.event.city = (res.event.Location == 'Malmö')?this.cities[0]:(res.event.Location == 'Gothenburg')?this.cities[1]:(res.event.Location == 'Copenhagen')?this.cities[2]:(res.event.Location == 'Stockholm')?this.cities[3]:(res.event.Location == 'Västra Götalands län')?this.cities[4]:
    (res.event.Location == 'Oslo')?this.cities[5]:this.cities[6];
    this.event.country = (res.event.country == 'Sweden')?this.countries[0]:(res.event.country == 'Denmark')?this.countries[1]:(res.event.country == 'Istanbul')?this.countries[2]:this.countries[3];
  })

}



fileChange(element: any) {
  this.uploadedFiles = element.target.files;
  console.log(this.uploadedFiles);
}

  
Createevent(){

  console.log(this.event.city["name"])
  this.formData = new FormData();
  // @ts-ignore
  this.formData.append('eventImage', this.uploadedFiles[0]); 
  this.formData.append('userId', localStorage.getItem("userId"));
  this.formData.append('title', this.event.eventname);
  this.formData.append('description', this.event.description);
  this.formData.append('location', this.event.city["name"]);
  this.formData.append('startDate', this.event.startdate);
  this.formData.append('endDate', this.event.enddate);
  this.formData.append('startTime', this.event.starttime);
  this.formData.append('endTime', this.event.endtime);
  this.formData.append('dancetype', this.event.eventtype["name"]);
  this.formData.append('style', this.event.mainstyle["name"]);
  this.formData.append('relatedStyle1',this.event.related1["name"]);
  this.formData.append('relatedStyle2', this.event.related2["name"]);
  this.formData.append('relatedStyle3',this.event.related3["name"]);
  this.formData.append('notRepeat', this.event.repeatingday["name"]);
  this.formData.append('country', this.event.country["name"]);

this.auth.createevent(this.formData).subscribe((res: any) => {
console.log(res);
this.showcreatedevent = true;
this.displayModal = false;
this.event  = {
  eventfile: '',
  eventname: '',
  eventtype:'',
  startdate:'',
  starttime:'',
  enddate:'',
  endtime:'',
  repeatingday:'',
  description:'',
  mainstyle:'',
  related1:'',
  related2:'',
  related3:'',
  city:'',
  country:'',
}
this.event.country = this.countries[0]
this.event.city = this.cities[0]
this.event.mainstyle = this.main[0]
this.event.eventtype = this.dancetype[0]
this.event.repeatingday = this.repeat[0]
this.event.related1 =  this.relatedstyle1[0]
this.event.related2 = this.relatedstyle2[0]
this.event.related3 = this.relatedstyle3[0]
this.getevents();

})


}

showBasicDialog() {
this.displayModal = true;
this.event  = {
  eventfile: '',
  eventname: '',
  eventtype:'',
  startdate:'',
  starttime:'',
  enddate:'',
  endtime:'',
  repeatingday:'',
  description:'',
  mainstyle:'',
  related1:'',
  related2:'',
  related3:'',
  city:'',
  country:'',
}
this.event.country = this.countries[0]
this.event.city = this.cities[0]
this.event.mainstyle = this.main[0]
this.event.eventtype = this.dancetype[0]
this.event.repeatingday = this.repeat[0]
this.event.related1 =  this.relatedstyle1[0]
this.event.related2 = this.relatedstyle2[0]
this.event.related3 = this.relatedstyle3[0]
this.displayModal = true;

}
//  getUserevents(){
//   this.eventService.getuserevents().subscribe((res: any) => {
//   console.log("users events",res);
//  // this.event.startdate = new Date(Date.parse(res.event.StartDate)).toLocaleDateString();
//   //this.event.enddate = new Date(Date.parse(res.event.EndDate)).toLocaleDateString();
//   this.events =  res.event;
//   for(let i = 0; i<this.events.length; i++){
//     this.events[i].StartDate = new Date (Date.parse(this.events[i].StartDate)).toLocaleDateString();
//     this.events[i].EndDate = new Date (Date.parse(this.events[i].EndDate)).toLocaleDateString();
//   }



//  });

// }

geteventtoedit(eventid:any){
this.eventService.getevent(eventid).subscribe((res: any) => {

  this.displayModal2 = true
});
}

editevent(){
this.formData = new FormData();
console.log(this.event.eventfile)
if (this.uploadedFiles == undefined){
  this.formData.append('eventUrl', this.event.eventfile); 

}
else {
  this.formData.append('eventUrl', null); 
  this.formData.append('eventImage', this.uploadedFiles[0]);
}
  // @ts-ignore
  this.formData.append('ID', this.eventid);
  this.formData.append('title', this.event.eventname);
  this.formData.append('description', this.event.description);
  this.formData.append('location', this.event.city["name"]);
  this.formData.append('startDate', this.event.startdate);
  this.formData.append('endDate', this.event.enddate);
  this.formData.append('startTime', this.event.starttime);
  this.formData.append('endTime', this.event.endtime);
  this.formData.append('dancetype', this.event.eventtype["name"]);
  this.formData.append('style', this.event.mainstyle["name"]);
  this.formData.append('relatedStyle1',this.event.related1["name"]);
  this.formData.append('relatedStyle2', this.event.related2["name"]);
  this.formData.append('relatedStyle3',this.event.related3["name"]);
  this.formData.append('notRepeat', this.event.repeatingday["name"]);
  this.formData.append('country', this.event.country["name"]);

this.auth.editevent(this.formData).subscribe((res: any) => {
console.log(res);
this.showcreatedevent = true;
 this.displayModal2 = false;
this.event  = {
  eventfile: '',
  eventname: '',
  eventtype:'',
  startdate:'',
  starttime:'',
  enddate:'',
  endtime:'',
  repeatingday:'',
  description:'',
  mainstyle:'',
  related1:'',
  related2:'',
  related3:'',
  city:'',
  country:'',
}
this.event.country = this.countries[0]
this.event.city = this.cities[0]
this.event.mainstyle = this.main[0]
this.event.eventtype = this.dancetype[0]
this.event.repeatingday = this.repeat[0]
this.event.related1 =  this.relatedstyle1[0]
this.event.related2 = this.relatedstyle2[0]
this.event.related3 = this.relatedstyle3[0]
this.getevents();
// window.location.reload()
})
}

deletevent(eventid:any){
this.auth.deleteEvent(eventid).subscribe((res: any) => {
  console.log("delete event" , res)
  this.getevents();   
})
}
getevents(){
this.eventService.eventExplore(this.date, this.location, this.tag).subscribe((res: any) => {
  console.log('$$$$$$$$$$$$$$$$$ ', res);
  this.events = res.events;
  console.log('These are my events');
  console.log(this.events);
  // this.progressvalue = false;
  // this.footer = true;
  // this.datadiv = false;
});
}

}
