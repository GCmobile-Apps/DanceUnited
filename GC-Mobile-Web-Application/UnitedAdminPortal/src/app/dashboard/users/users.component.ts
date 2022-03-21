import {Component, ElementRef, OnDestroy, OnInit, ViewChild} from '@angular/core';
import { NgForm } from '@angular/forms';
import * as uuid from 'uuid';
import {UsersService} from '../../shared/services/users.service';
import {Subscription} from 'rxjs';
import {ProfessionalUserService} from '../../shared/services/professional-user.service';
import {ProfessionalUser} from '../../models/professionalUser';
import {User} from '../../models/user.model';
import {FileService} from '../../shared/services/file.service';
import {AutoLogout, logout, SERVER_PATH, v4options} from '../../models/globals';
import {MessageService} from "primeng/api";
import {PreferencesService} from "../../shared/services/preferences.service";

@Component({
  selector: 'app-users',
  templateUrl: './users.component.html',
  styleUrls: ['./users.component.scss']
})
export class UsersComponent implements OnInit, OnDestroy {
  UserID;
  value = 0;
  user: User = {
    City: '',
    ContactNumber: '',
    Country: '',
    Email: '',
    FirstName: '',
    LastName: '',
    Preference1: '',
    Preference2: '',
    Preference3: '',
    StreetAddress: '',
    UserID: '',
    Zipcode: '',
    password: '',
    profilePictureLink: '',
    username: ''
  };
  imgName = '';
  secondImageName = '';
  calenderImageName = '';
  professionalUser: ProfessionalUser;
  userType = 'Professional';
  subscriptions: Subscription[] = [];
  isProfessional = true;
  userTypes  = [
    {label: 'Regular', value: 'Regular'},
    {label: 'Professional', value: 'Professional'},
  ];
  file;
  secondaryPictureFile;
  calendarPictureFile;
  displayProgressBar = false;
  preferences = [];
  @ViewChild('inputFile') inputFile: ElementRef;
  @ViewChild('userForm') userForm: NgForm;
  @ViewChild('secondFile') secondaryProfilePicFile: ElementRef;
  @ViewChild('calendarViewFile') calendarViewFile: ElementRef;
  constructor(public usersService: UsersService, private professionalUserService: ProfessionalUserService,
              private fileService: FileService, private messageService: MessageService,
              private preferencesService: PreferencesService) { }

  ngOnInit(): void {
    this.UserID = uuid.v4();
    this.subscriptions.push(
      this.preferencesService.getAllPreferences().subscribe((res: any) => {
        console.log(res);
        res.list.forEach(p => {
          const obj = {label: p.PreferenceName};
          this.preferences.push(obj);

        })
      })
    );

  }

  onSubmit(form: NgForm): void {
    if (this.isProfessional) {
      this.professionalUser = {
        userID: form.value.UserID,
        firstName: form.value.FirstName,
        lastName: form.value.LastName,
        username: form.value.username,
        password: form.value.password,
        title: form.value.title,
        backStageCode: (uuid.v4()).slice(0, 5),
        streetAddress: form.value.StreetAddress,
        country: form.value.Country,
        zipcode: form.value.ZipCode,
        contactNumber: form.value.ContactNumber,
        email: form.value.Email,
        profilePictureLink: this.imgName!=''?SERVER_PATH + '/uploads/' + form.value.UserID + this.imgName.replace(/\s/g, ''):'',
        secondaryProfilePictureLink: this.secondImageName!=''?SERVER_PATH + '/uploads/' + form.value.UserID + this.secondImageName.replace(/\s/g, ''):'',
        calenderViewLink: this.calenderImageName!=''?SERVER_PATH + '/professionalCalendarView/'  + form.value.UserID + this.calenderImageName.replace(/\s/g, ''):'',
        description: form.value.description
    };
      this.subscriptions.push(
        this.professionalUserService.postUser(this.professionalUser).subscribe((res: any) => {
            if(res?.statusCode === 401){
              logout();
              return;
            }
          this.subscriptions.push(this.fileService.uploadUserImage(this.file, 'uploads', this.professionalUser.userID).subscribe(response => {
            this.subscriptions.push(this.fileService.uploadUserImage(this.secondaryPictureFile, 'uploads', this.professionalUser.userID).subscribe(result => {
              this.subscriptions.push(this.fileService.uploadUserImage(this.calendarPictureFile, 'professionalCalendarView', this.professionalUser.userID).subscribe(data => {
                this.userForm.reset();
                this.imgName = '';
                this.secondImageName = '';
                this.calenderImageName = '';

              }));
            }));
          }));
          this.isProfessional = false;
          },
          error => {
            AutoLogout(error)
          }
        )
      );
    }
    else {
      this.user = {
        City: form.value.City,
        ContactNumber: form.value.ContactNumber,
        Country: form.value.Country,
        Email: form.value.Email,
        FirstName: form.value.FirstName,
        LastName: form.value.LastName,
        Preference1: form.value.Preference1,
        Preference2: form.value.Preference2,
        Preference3: form.value.Preference3,
        StreetAddress: form.value.StreetAddress,
        UserID: form.value.UserID,
        Zipcode: form.value.ZipCode ,
        password: form.value.password,
        profilePictureLink: SERVER_PATH + '/uploads/' + form.value.UserID + (this.imgName!='' ? this.imgName.replace(/\s/g, '') : ''),
        username: form.value.username
      };
      this.subscriptions.push(
        this.usersService.postUser(this.user).subscribe((res: any) => {
            if(res?.statusCode === 401){
              logout();
              return;
            }
          this.subscriptions.push(this.fileService.uploadUserImage(this.file, 'uploads', this.user.UserID).subscribe(response => {
            console.log(response);
          }));
          this.userForm.reset();
        },
          error => {
            AutoLogout(error)
          })
      );
    }

    this.displayProgressBar = true;
    const interval = setInterval(() => {
      this.value = this.value + Math.floor(Math.random() * 40) + 1;
      if (this.value >= 100) {
        this.value = 100;
        clearInterval(interval);
      }
      if(this.value === 100){
        this.messageService.add({severity: 'success', summary: 'Success', detail: 'User Saved'});
        this.displayProgressBar = false;
      }
    }, 2000);

  }
  switchForm(): void{
    this.isProfessional = this.userType === 'Professional';
  }
  onFileChanged(event){
    const imageBlob = this.inputFile.nativeElement.files[0];
    this.file = new FormData();
    this.imgName = this.inputFile.nativeElement.files[0].name;
    this.file.set('file', imageBlob);
  }
  onSecondFileChanged(event){
    this.secondImageName = this.secondaryProfilePicFile.nativeElement.files[0].name;
    const imageBlob = this.secondaryProfilePicFile.nativeElement.files[0];
    this.secondaryPictureFile = new FormData();
    this.secondaryPictureFile.set('file', imageBlob);
  }
  onCalendarFileChanged(event){
    this.calenderImageName = this.calendarViewFile.nativeElement.files[0].name;
    const imageBlob = this.calendarViewFile.nativeElement.files[0];
    this.calendarPictureFile = new FormData();
    this.calendarPictureFile.set('file', imageBlob);
  }
  ngOnDestroy(): void{
    this.subscriptions.forEach(sub => sub.unsubscribe());
  }


}
