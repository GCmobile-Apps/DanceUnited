import {Component, OnDestroy, OnInit} from '@angular/core';
import {PromotionService} from "../../../shared/services/promotion.service";
import {Subscription} from "rxjs";
import {MessageService} from "primeng/api";
import {AutoLogout, logout} from "../../../models/globals";

@Component({
  selector: 'app-edit-promo-prices',
  templateUrl: './edit-promo-prices.component.html',
  styleUrls: ['./edit-promo-prices.component.scss']
})
export class EditPromoPricesComponent implements OnInit, OnDestroy {

  subscription: Subscription[] = [];
  constructor(private promoService: PromotionService,
              private messageService: MessageService) { }

  ngOnInit(): void {
  }
  editPromoPrices(name, price): void{
    this.subscription.push(this.promoService.editPromoPrices(name,price.value).subscribe((res: any) => {
      if(res?.statusCode === 401){
        logout();
        return;
      }
      if(res.status){
        price.value = '';
        this.messageService.add({severity:'success', summary:'Price Updated'});
      }
      else {
        this.messageService.add({severity:'error', summary:'No promotions exists. Update failed'});
      }

    },
      error => {
        AutoLogout(error)
      }));
  }

  ngOnDestroy() {
    this.subscription.forEach(sub => sub.unsubscribe());
  }

}
