import {Component, ElementRef, OnDestroy, OnInit, ViewChild} from '@angular/core';
import { User } from '../../../models/user.model';
import {UsersService} from '../../../shared/services/users.service';
import {Subscription} from 'rxjs';
import {ConfirmationService, MessageService} from 'primeng/api';
import {ProfessionalUserService} from '../../../shared/services/professional-user.service';
import {ProfessionalUser} from '../../../models/professionalUser';
import {AutoLogout, logout, SERVER_PATH} from "../../../models/globals";
import {FileService} from "../../../shared/services/file.service";
import {PreferencesService} from "../../../shared/services/preferences.service";

@Component({
  selector: 'app-all-users',
  templateUrl: './all-users.component.html',
  styleUrls: ['./all-users.component.scss']
})
export class AllUsersComponent implements OnInit, OnDestroy {
  loader = true;
  allUsers: User[];
  subscriptions: Subscription[]  = [];
  userDialog = false;
  file;
  user: User = {
    UserID: '',
    FirstName: '',
    LastName: '',
    username: '',
    password: '',
    StreetAddress: '',
    City: '',
    Country: '',
    Zipcode: '',
    ContactNumber: '',
    Email: '',
    profilePictureLink: '',
    Preference1: '',
    Preference2: '',
    Preference3: ''
  };
  Preferences = [];
  @ViewChild('fileInput') fileInput: ElementRef;
  imgName = '';
  noData = false;
  constructor(public usersService: UsersService, private confirmationService: ConfirmationService,
              private messageService: MessageService, private fileService: FileService,
              private preferencesService: PreferencesService) { }

  ngOnInit(): void {
    this.subscriptions.push(
      this.preferencesService.getAllPreferences().subscribe((res: any) => {
        console.log(res);
        res.list.forEach(p => {
          const obj = {label: p.PreferenceName};
          this.Preferences.push(obj);

        })
      })
    );
      this.subscriptions.push(
        this.usersService.getAllUsers().subscribe((res: any) => {
            if(res?.statusCode === 401){
              logout();
              return;
            }
          this.loader = false;
          if(res.data.length === 0){
            this.noData = true;
            return;
          }
          this.allUsers = res.data;
        },
          error => {
            AutoLogout(error)
          }));
  }
  openNew(user){
    this.user = user;
    this.userDialog = true;
  }
  hideDialog(){
    this.userDialog = false;
  }
  editUser(){
    this.user.profilePictureLink = this.imgName!=''?SERVER_PATH + '/uploads/' + this.user.UserID + this.imgName.replace(/\s/g, ''):this.user.profilePictureLink;
    this.subscriptions.push(
        this.usersService.editUser(this.user).subscribe((data: any) => {
            if(data?.statusCode === 401){
              logout();
              return;
            }
          this.messageService.add({severity: 'success', summary: 'Successful', detail: 'User Edited', life: 3000});
          this.subscriptions.push(
            this.fileService.uploadUserImage(this.file, 'uploads', this.user.UserID).subscribe(res => {

            })
          );
        },
          error => {
            AutoLogout(error)
          })
      );
    this.userDialog =  false;
  }
  deleteUser(user): void{
    this.confirmationService.confirm({
      message: 'Are you sure you want to delete ' + user.FirstName + '?',
      header: 'Confirm',
      icon: 'pi pi-exclamation-triangle',
      accept: () => {
          this.subscriptions.push(
            this.usersService.deleteUser(user.Email).subscribe((data: any) => {
                if(data?.statusCode === 401){
                  logout();
                  return;
                }
              const index = this.allUsers.findIndex(val => val.UserID === user.UserID);
              this.allUsers.splice(index, 1);
              this.messageService.add({severity: 'success', summary: 'Successful', detail: 'User Deleted', life: 3000});
            },
              error => {
                AutoLogout(error)
              })
          );
      }
    });
  }
  onFileChanged(event){
    const imageBlob = this.fileInput.nativeElement.files[0];
    this.imgName = this.fileInput.nativeElement.files[0].name;
    this.file = new FormData();
    this.file.set('file', imageBlob);
  }
  ngOnDestroy() {
    this.subscriptions.forEach(sub => sub.unsubscribe());
  }
}
