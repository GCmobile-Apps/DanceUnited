import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { EventServices } from '../shared/services/event-services.service';
import { PrimeNGConfig } from 'primeng/api';
import { Pipe } from '@angular/core';
import { PipeTransform } from '@angular/core';
import {ReplaceUnderscorePipe} from '../Pipes/ReplaceString';


interface City {
  name: string,
  code: string
}
@Component({
  selector: 'app-eventexplore',
  templateUrl: './eventexplore.component.html',
  styleUrls: ['./eventexplore.component.scss']
})

export class EventexploreComponent implements OnInit {
  editmodal:false;
  displayBasic: boolean;
  displayModal: boolean;
  displayModal2:boolean;
  eventid:any;
  uploadedFiles: File | undefined
  event  = {
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

  formData = new FormData();
  dancetype: any[];
  cities: any[];
  repeat:any[];
  main:any[];
  relatedstyle1:any[];
  relatedstyle2:any[];
  relatedstyle3:any[];
  countries:any[];





  events = [];
  date = '' ;
  location = '';
  tag = '';
  cardDetil: any;
  container = true;
  progressvalue = false;

  dropdowns: any;
  cards: any;
  dropdowntag: any;
  dropdownlocation: any;
  dropdownday: any;
  footer = false;
  datadiv = false;
  selectedCity1: City;



  constructor(private router: Router, private eventService: EventServices , private auth:EventServices) {


      this.repeat = [
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
        {name:"zouk"},
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
        {name:"zouk"},
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
        {name:"zouk"},
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
        {name:"zouk"},
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
    this.dropdowntag = 'Dance Style';
    this.dropdownlocation = 'Location';
    this.dropdownday = 'Time';
    this.progressvalue = true;
    this.footer = false;
    this.datadiv = true;
    this.eventService.eventExplore(this.date, this.location, this.tag).subscribe((res: any) => {
      console.log('$$$$$$$$$$$$$$$$$ ', res);
      this.events = res.events;
      console.log('These are my events');
      console.log(this.events);
      this.progressvalue = false;
      this.footer = true;
      this.datadiv = false;
    });
    this.dropdowns = [1 , 2 , 3];
    this.cards = [ 1 , 2 , 3 ];
  }
  // tslint:disable-next-line:typedef
  editevent(eventid:any) {
    this.displayModal2 = true;
    this.eventid = eventid;
    this.eventService.getevent(eventid).subscribe((res: any) => {
      console.log(res.event);
      this.event.eventname = res.event.Title;
      this.event.eventtype =  (res.event.Type == 'Classes')?this.dancetype[0]:(res.event.Type == 'Festival')?this.dancetype[1]:(res.event.Type == 'Party')?this.dancetype[2]:this.dancetype[3];
      this.event.startdate = new Date(Date.parse(res.event.StartDate)).toISOString().slice(0, 10);
      this.event.enddate = new Date(Date.parse(res.event.EndDate)).toISOString().slice(0, 10);
      this.event.starttime = res.event.startTime;
      this.event.endtime =  res.event.endTime;
      this.event.repeatingday = (res.event.notRepeat == 'Monday')?this.repeat[0]:(res.event.notRepeat == 'Tuesday')?this.repeat[1]:(res.event.notRepeat == 'Wednesday')?this.repeat[2]:
      (res.event.notRepeat == 'Thursday')?this.repeat[3]:(res.event.notRepeat == 'Friday')?this.repeat[4]:(res.event.notRepeat == 'Saturday')?this.repeat[5]:this.repeat[6];
      this.event.eventfile = res.event.ImageUrl;
      this.event.description =  res.event.Description;
      this.event.mainstyle =  (res.event.Tags == 'Zouk')?this.main[0]:(res.event.Tags == 'Salsa')?this.main[1]:(res.event.Tags == 'Bachata')?this.main[2]:
      (res.event.Tags == 'Cuban Salsa')?this.main[3]:(res.event.Tags == 'Tango')?this.main[4]:(res.event.Tags == 'UrbanKiz')?this.main[5]:(res.event.Tags == 'Domenican Bachata')?this.main[5]:this.main[6];

      this.event.related1 =  (res.event.relatedStyle1 == 'Zouk')?this.relatedstyle1[0]:(res.event.relatedStyle1 == 'Salsa')?this.relatedstyle1[1]:(res.event.relatedStyle1 == 'Bachata')?this.relatedstyle1[2]:
      (res.event.relatedStyle1 == 'Cuban Salsa')?this.relatedstyle1[3]:(res.event.relatedStyle1 == 'Tango')?this.relatedstyle1[4]:(res.event.relatedStyle1 == 'UrbanKiz')?this.relatedstyle1[5]:(res.event.relatedStyle1 == 'Domenican Bachata')?this.relatedstyle1[5]:this.relatedstyle1[6];

      this.event.related2 =  (res.event.relatedStyle2 == 'Zouk')?this.relatedstyle2[0]:(res.event.relatedStyle2 == 'Salsa')?this.relatedstyle2[1]:(res.event.relatedStyle2 == 'Bachata')?this.relatedstyle2[2]:
      (res.event.relatedStyle2 == 'Cuban Salsa')?this.relatedstyle2[3]:(res.event.relatedStyle2 == 'Tango')?this.relatedstyle2[4]:(res.event.relatedStyle2 == 'UrbanKiz')?this.relatedstyle2[5]:(res.event.relatedStyle2 == 'Domenican Bachata')?this.relatedstyle2[5]:this.relatedstyle2[6];
      this.event.related3 =  (res.event.relatedStyle3 == 'Zouk')?this.relatedstyle3[0]:(res.event.relatedStyle3 == 'Salsa')?this.relatedstyle3[1]:(res.event.relatedStyle3 == 'Bachata')?this.relatedstyle3[2]:
      (res.event.relatedStyle3 == 'Cuban Salsa')?this.relatedstyle3[3]:(res.event.relatedStyle3 == 'Tango')?this.relatedstyle3[4]:(res.event.relatedStyle3 == 'UrbanKiz')?this.relatedstyle3[5]:(res.event.relatedStyle3 == 'Domenican Bachata')?this.relatedstyle3[5]:this.relatedstyle3[6];
      this.event.city = (res.event.Location == 'Malmö')?this.cities[0]:(res.event.Location == 'Gothenburg')?this.cities[1]:(res.event.Location == 'Copenhagen')?this.cities[2]:(res.event.Location == 'Stockholm')?this.cities[3]:(res.event.Location == 'Västra Götalands län')?this.cities[4]:
      (res.event.Location == 'Oslo')?this.cities[5]:this.cities[6];
      this.event.country = (res.event.country == 'Sweden')?this.countries[0]:(res.event.country == 'Denmark')?this.countries[1]:(res.event.country == 'Istanbul')?this.countries[2]:(res.event.country == 'S')?this.cities[3]:(res.event.Location == 'Västra Götalands län')?this.cities[4]:this.cities[5];
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
    this.formData.append('ID', this.eventid);
    this.formData.append('title', this.event.eventname);
    this.formData.append('description', this.event.description);
    this.formData.append('location', this.event.city["name"]);
    this.formData.append('startDate', this.event.startdate);
    this.formData.append('endDate', this.event.enddate);
    this.formData.append('startTime', this.event.starttime);
    this.formData.append('endTime', this.event.endtime);
    this.formData.append('type', this.event.eventtype["name"]);
    this.formData.append('style', this.event.mainstyle["name"]);
    this.formData.append('relatedStyle1',this.event.related1["name"]);
    this.formData.append('relatedStyle2', this.event.related2["name"]);
    this.formData.append('relatedStyle3',this.event.related3["name"]);
    this.formData.append('notRepeat', this.event.repeatingday["name"]);
    this.formData.append('country', this.event.country["name"]);

    this.auth.editevent(this.formData).subscribe((res: any) => {
  console.log(res);

  })

}

 filterevents(){
  this.eventService.eventExplore(this.date, this.location, this.tag).subscribe((res: any) => {
    console.log(res);
    this.events = res.events;
    console.log(this.events);
  });
 }

  type(tag: any){
    this.tag = tag;
    this.dropdowntag = tag;
    this.filterevents();  
  }
  locate(location: any){
    this.location = location;
    this.dropdownlocation = location;
    this.filterevents();  

  
  
  }
  day(date: any){
    this.date = date;
    this.dropdownday = date;
    this.filterevents();  

   
  
  }
  showBasicDialog(cardDetail: any) {
    this.cardDetil = cardDetail;
    console.log(this.cardDetil);
    this.displayBasic = true;
  }

  loginRedirect(){
    console.log("Called");
    this.router.navigate(['/userlogin']);
  }



}


