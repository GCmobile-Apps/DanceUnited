import {Component, ElementRef, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {PromotionService} from '../../shared/services/promotion.service';
import {Subscription} from 'rxjs';
import {Promotion} from '../../models/promotion';
import {ConfirmationService, MessageService} from 'primeng/api';
import {AutoLogout, locations, logout, Preferences, SERVER_PATH} from '../../models/globals';
import {UsersService} from "../../shared/services/users.service";
import {EventServices} from "../../shared/services/event-services.service";
import {FileService} from "../../shared/services/file.service";
import {PreferencesService} from "../../shared/services/preferences.service";
import {ProfessionalUserService} from "../../shared/services/professional-user.service";
import {LinksService} from "../../shared/services/links.service";

@Component({
  selector: 'app-promotions',
  templateUrl: './promotions.component.html',
  styleUrls: ['./promotions.component.scss']
})
export class PromotionsComponent implements OnInit, OnDestroy {

  checked2: boolean = true;
  loader = true;
  promotions = [];
  parentCategory = 'newspromo';
  editPromoDialog = false;
  pro_users = [];
  subscriptions: Subscription[] = [];
  promotion: Promotion = {
    destinationLink: "",
    eventID: "",
    mainStyle: "",
    offerTitle: "",
    promoCity: "",
    promoID: "",
    promoImageUrl: "",
    promoType: "",
    relatedStyle1: "",
    relatedStyle2: "",
    relatedStyle3: "",
    userID: "",
    viewCounter: 0
  };
  locations;
  danceStyles;
  users;
  events;
  imgName = '';
  promoFile;
  noData = false;
  @ViewChild('fileInput') fileInput: ElementRef;
  promotionCategories = [
    {label: 'Special Promotions', value: 'newspromo'},
    {label: 'Full Screen Promotions', value: 'fullscreenpromo'},
    {label: 'Main Screen Promotions', value: 'mainscreenpromo'}
  ];
  constructor(private promoService: PromotionService, private messageService: MessageService,
              private confirmationService: ConfirmationService, private userService: ProfessionalUserService,
              private eventService: EventServices, private fileService: FileService,
              private preferencesService: PreferencesService,
              private MarketingToggleService: LinksService) { }

  ngOnInit(): void {
    this.locations = locations;
    this.danceStyles = Preferences;
    this.getPromotions();
    this.getUsers();
    this.getEvents();
    this.subscriptions.push(
      this.preferencesService.getAllPreferences().subscribe((res: any) => {
        console.log(res);
        res.list.forEach(p => {
          const obj = {label: p.PreferenceName};
          this.danceStyles.push(obj);

        })
      })
    );


  }
  getUsers(): void{
    this.subscriptions.push(
      this.userService.getAllUsers().subscribe((res: any) => {
        if(res?.statusCode === 401){
          logout();
          return;
        }
        // if(res.data.length === 0){
        //   this.noData = true;
        //   return;
        // }
        this.noData = false;
        this.users = res.data;
      },
        error => {
          AutoLogout(error)
        })
    );
  }
  getEvents(): void{
    this.subscriptions.push(
      this.eventService.getAllEvents().subscribe((res: any) => {
        if(res?.statusCode === 401){
          logout();
          return;
        }
        this.loader = false;
        // if(res.data.length === 0){
        //   this.noData = true;
        //   return;
        // }
        this.noData = false;
        this.events = res.data;
      },
        error => {
          AutoLogout(error)
        })
    );
  }
  getPromotions(): void{
    this.subscriptions.push(
      this.promoService.getAllPromotions(this.parentCategory).subscribe((res: any) => {
          if(res?.statusCode === 401){
            logout();
            return;
          }
        // if(res.data.length === 0){
        //   this.noData = true;
        //   return;
        // }
        this.promotions = res.data;
      },
        error => {
          AutoLogout(error)
        })
    );
  }
  openNew(promotion): void{
    this.editPromoDialog = true;
    this.promotion = promotion;

  }
  editPromotion(): void{
    console.log(this.promotion.promoImageUrl)
    console.log("This is user id " + this.promotion.userID);

    this.subscriptions.push(
      this.promoService.editPromotion(this.promotion, this.parentCategory).subscribe((data: any) => {
          if(data?.statusCode === 401){
            logout();
            return;
          }
        this.messageService.add({severity: 'success', summary: 'Successful', detail: 'Promotion Edited', life: 3000});
        this.subscriptions.push(this.fileService.uploadUserImage(this.promoFile, 'promoImages', this.promotion.promoID).subscribe(response => {
        }));
      },
        error => {
          AutoLogout(error)
        })
    );
    this.editPromoDialog =  false;
  }
  deletePromotion(promotion): void{
    this.confirmationService.confirm({
      message: 'Are you sure you want to delete ' + promotion.offerTitle + '?',
      header: 'Confirm',
      icon: 'pi pi-exclamation-triangle',
      accept: () => {
        this.subscriptions.push(
          this.promoService.deletePromotion(promotion.promoID, this.parentCategory).subscribe((data: any) => {
              if(data?.statusCode === 401){
                logout();
                return;
              }
            const temp = this.promotions.findIndex(item => item.promoID === promotion.promoID);
            this.promotions.splice(temp, 1);
            this.messageService.add({severity: 'success', summary: 'Successful', detail: 'Promotion Deleted', life: 3000});
          },
            error => {
              AutoLogout(error)
            })
        );
      }
    });
  }
  onFileChanged(event): void{
    const imageBlob = this.fileInput.nativeElement.files[0];
    this.imgName = this.fileInput.nativeElement.files[0].name;
    this.promoFile = new FormData();
    this.promoFile.set('file', imageBlob);
    this.promotion.promoImageUrl = this.imgName!=''?SERVER_PATH + '/promoImages/' + this.promotion.promoID + this.imgName.replace(/\s/g, ''):this.promotion.promoImageUrl;
    console.log(this.promotion.promoImageUrl);

  }
  hideDialog(): void{
    this.editPromoDialog = false;
  }

  ngOnDestroy(): void {
    this.subscriptions.forEach(sub => sub.unsubscribe());
  }

  onToggleChange(e){
       var isChecked = e.checked;
       console.log("is Checked");

       this.MarketingToggleService.UpdateMarketingToggle(isChecked);
  }

}
