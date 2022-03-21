import {Component, ElementRef, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {ProfessionalUser} from '../../../models/professionalUser';
import {Subscription} from 'rxjs';
import {ProfessionalUserService} from '../../../shared/services/professional-user.service';
import {ConfirmationService, MessageService} from 'primeng/api';
import {AutoLogout, logout, SERVER_PATH} from '../../../models/globals';
import {FileService} from '../../../shared/services/file.service';

@Component({
  selector: 'app-professional-users',
  templateUrl: './professional-users.component.html',
  styleUrls: ['./professional-users.component.scss']
})
export class ProfessionalUsersComponent implements OnInit, OnDestroy {
  loader = true;
  subscriptions: Subscription[] = [];
  users;
  userDialog = false;
  proUser: ProfessionalUser = {
    userID: '',
    firstName: '',
    lastName: '',
    username: '',
    password: '',
    title: '',
    backStageCode: '',
    streetAddress: '',
    country: '',
    zipcode: '',
    contactNumber: '',
    email: '',
    profilePictureLink: '',
    secondaryProfilePictureLink: '',
    calenderViewLink: '',
    description: ''
  };
  imgName = '';
  secondImageName = '';
  calenderImageName = '';
  file;
  secondaryPictureFile;
  calendarPictureFile;
  noData = false;

  @ViewChild('fileInput') inputFile: ElementRef;
  @ViewChild('secondaryPic') secondaryProfilePicFile: ElementRef;
  @ViewChild('calendarPic') calendarViewFile: ElementRef;
  constructor(private professionalUsersService: ProfessionalUserService,
              private confirmationService: ConfirmationService,
              private messageService: MessageService,
              private fileService: FileService) { }

  ngOnInit(): void {
    this.subscriptions.push(
      this.professionalUsersService.getAllUsers().subscribe(
        (res: any) => {
          if(res?.statusCode === 401){
            logout();
            return;
          }
          this.loader = false;
          if(res.data.length === 0){
            this.noData = true;
            return;
          }
          this.users = res.data;
        },
        error => {
          AutoLogout(error)
        }
      )
    );
  }
  openNew(user){
    this.userDialog = true;
    this.proUser = user;
  }
  editUser(){
    console.log("this is email " + this.proUser.email);
    this.proUser.profilePictureLink = this.imgName!='' ? (SERVER_PATH + '/uploads/' + this.proUser.userID + this.imgName.replace(/\s/g, '')) : this.proUser.profilePictureLink;
    this.proUser.secondaryProfilePictureLink = this.secondImageName!='' ? SERVER_PATH + '/uploads/' + this.proUser.userID + this.secondImageName.replace(/\s/g, '') : this.proUser.secondaryProfilePictureLink;
    this.proUser.calenderViewLink = this.calenderImageName!='' ? (SERVER_PATH + '/professionalCalendarView/' + this.proUser.userID + this.calenderImageName.replace(/\s/g, '')) : this.proUser.calenderViewLink;
    this.subscriptions.push(
      this.professionalUsersService.editUser(this.proUser).subscribe((res: any) => {
          if(res?.statusCode === 401){
            logout();
            return;
          }
        this.messageService.add({severity: 'success', summary: 'Successful', detail: 'User Edited', life: 3000});
        this.subscriptions.push(this.fileService.uploadUserImage(this.file, 'uploads', this.proUser.userID).subscribe(response => {
          this.subscriptions.push(this.fileService.uploadUserImage(this.secondaryPictureFile, 'uploads', this.proUser.userID).subscribe(result => {
            this.subscriptions.push(this.fileService.uploadUserImage(this.calendarPictureFile, 'professionalCalendarView', this.proUser.userID).subscribe(res => {
              console.log(res);
            }));
          }));
        }));
      },
        error => {
          AutoLogout(error)
        })
    );
    this.userDialog = false;
  }
  deleteUser(user){
    this.confirmationService.confirm({
      message: 'Are you sure you want to delete ' + user.firstName + '?',
      header: 'Confirm',
      icon: 'pi pi-exclamation-triangle',
      accept: () => {
        this.subscriptions.push(
          this.professionalUsersService.deleteUser(user.email).subscribe((res: any) => {
              if(res?.statusCode === 401){
                logout();
                return;
              }
            const index = this.users.findIndex(val => val.userID === user.userID);
            this.users.splice(index, 1);
            this.messageService.add({severity: 'success', summary: 'Successful', detail: 'User Deleted', life: 3000});
          },
            error => {
              AutoLogout(error)
            })
        );
      }
    });
  }
  hideDialog(){
    this.userDialog = false;
  }
  onFileChanged(event){
    const imageBlob = this.inputFile.nativeElement.files[0];
    this.imgName = this.inputFile.nativeElement.files[0].name;
    this.file = new FormData();
    this.file.set('file', imageBlob);
  }
  onSecondFileChanged(event){
    const imageBlob = this.secondaryProfilePicFile.nativeElement.files[0];
    this.secondImageName =  this.secondaryProfilePicFile.nativeElement.files[0].name;
    this.secondaryPictureFile = new FormData();
    this.secondaryPictureFile.set('file', imageBlob);
  }
  onCalendarFileChanged(event){
    const imageBlob = this.calendarViewFile.nativeElement.files[0];
    this.calenderImageName = this.calendarViewFile.nativeElement.files[0].name;
    this.calendarPictureFile = new FormData();
    this.calendarPictureFile.set('file', imageBlob);
  }
  ngOnDestroy() {
    this.subscriptions.forEach(sub => sub.unsubscribe());
  }

}
