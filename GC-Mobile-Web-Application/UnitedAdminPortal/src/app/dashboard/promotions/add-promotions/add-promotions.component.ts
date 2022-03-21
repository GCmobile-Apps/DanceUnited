import {Component, ElementRef, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {EventServices} from '../../../shared/services/event-services.service';
import {Subscription} from 'rxjs';
import {UsersService} from '../../../shared/services/users.service';
import * as uuid from 'uuid';
import {NgForm} from "@angular/forms";
import {AutoLogout, logout, Preferences, SERVER_PATH} from "../../../models/globals";
import {Promotion} from "../../../models/promotion";
import {PromotionService} from "../../../shared/services/promotion.service";
import {FileService} from "../../../shared/services/file.service";
import {ProfessionalUserService} from "../../../shared/services/professional-user.service";
import {PreferencesService} from "../../../shared/services/preferences.service";
import {MessageService} from "primeng/api";

@Component({
  selector: 'app-add-promotions',
  templateUrl: './add-promotions.component.html',
  styleUrls: ['./add-promotions.component.scss']
})
export class AddPromotionsComponent implements OnInit, OnDestroy {

  promoID;
  promotion: Promotion;
  promotionCategories = [
    {label: 'Special Promo', value: 'newspromo'},
    {label: 'Full Screen Promo', value: 'fullscreenpromo'},
    {label: 'Main Screen Promo', value: 'mainscreenpromo'}
  ];
  events = [];
  users = [];
  subscriptions: Subscription[] = [];
  danceStyles = [];
  locations;
  promoFile;
  imgName = '';
  @ViewChild('fileInput') fileInput: ElementRef;
  @ViewChild('promoForm') promoForm: NgForm;
  constructor(private eventService: EventServices, private userService: ProfessionalUserService,
              private promoService: PromotionService, private fileService: FileService,
              private preferencesService: PreferencesService,
              private msgService: MessageService) { }

  ngOnInit(): void {
    this.locations = this.eventService.locations;
    // this.danceStyles = Preferences;
    this.promoID = uuid.v4();
    this.subscriptions.push(
      this.preferencesService.getAllPreferences().subscribe((res: any) => {
        console.log(res);
        res.list.forEach(p => {
          const obj = {label: p.PreferenceName};
          this.danceStyles.push(obj);

        })
      })
    );
    this.subscriptions.push(
      this.eventService.getAllEvents().subscribe((res: any) => {
          if(res?.statusCode === 401){
            logout();
            return;
          }
        this.events = res.data;
      },
        error => {
          AutoLogout(error)
        })
    );
    this.subscriptions.push(
      this.userService.getAllUsers().subscribe((res: any) => {
          if(res?.statusCode === 401){
            logout();
            return;
          }
        this.users = res.data;
      },
        error => {
          AutoLogout(error)
        })
    );
  }
  addPromotion(form): void{
    this.promotion = {
      destinationLink: form.value.destinationLink,
      eventID: form.value.eventID,
      mainStyle: form.value.mainStyle,
      offerTitle: form.value.offerTitle,
      promoCity: form.value.promoCity,
      promoID: this.promoID,
      promoImageUrl: this.imgName!=''?SERVER_PATH + '/promoImages/' + this.promoID + this.fileInput.nativeElement.files[0].name.replace(/\s/g, ''):'',
      promoType: form.value.promoType ? form.value.promoType : form.value.promoParentType,
      relatedStyle1: form.value.relatedStyle1,
      relatedStyle2: form.value.relatedStyle2,
      relatedStyle3: form.value.relatedStyle3,
      viewCounter: 0,
      userID: form.value.userID
    };
    this.subscriptions.push(
      this.promoService.addPromotion(this.promotion, form.value.promoParentType).subscribe((res: any) => {
        if(res?.statusCode === 401){
          logout();
          return;
        }

        this.subscriptions.push(this.fileService.uploadUserImage(this.promoFile, 'promoImages', this.promotion.promoID).subscribe(response => {
            this.msgService.add({severity:'success', summary:'Promotion Added', detail:'', life:4000})
            this.promoForm.reset();

          },

          error => {
            AutoLogout(error)
          }));
      })
    );
  }
  onFileChanged(event): void{
    const imageBlob = this.fileInput.nativeElement.files[0];
    this.imgName = this.fileInput.nativeElement.files[0].name;
    this.promoFile = new FormData();
    this.promoFile.set('file', imageBlob);
  }
  ngOnDestroy(): void {
    this.subscriptions.forEach(sub => sub.unsubscribe());
  }

}
