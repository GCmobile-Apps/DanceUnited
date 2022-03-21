import { Injectable } from '@angular/core';
import {BASE_URL, createAuthHeader} from '../../models/globals';
import {HttpClient, HttpHeaders} from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class PromotionService {

  baseUrl = BASE_URL;
  constructor(private httpClient: HttpClient) { }

  addPromotion(promotion, parent){
    if (parent === 'mainscreenpromo'){
      return this.httpClient.post(this.baseUrl + '/createNewMainScreenPromo', {mainscreenpromo: promotion}, {
        headers: createAuthHeader(new HttpHeaders())
      });
    }
    else if (parent === 'fullscreenpromo'){
      return this.httpClient.post(this.baseUrl + '/createNewFullScreenPromo', {fullscreenpromo: promotion}, {
        headers: createAuthHeader(new HttpHeaders())
      });
    }
    else{
      return this.httpClient.post(this.baseUrl + '/createNewNewsPromo', {newspromo: promotion}, {
        headers: createAuthHeader(new HttpHeaders())
      });
    }

  }
  getAllPromotions(type){
    if (type === 'mainscreenpromo'){
      return this.httpClient.get(this.baseUrl + '/getMainScreenPromo',
        {headers: createAuthHeader(new HttpHeaders())
        });
    }
    else if (type === 'fullscreenpromo'){
      return this.httpClient.get(this.baseUrl + '/getFullScreenPromo',
        {headers: createAuthHeader(new HttpHeaders())
        });
    }
    else{
      return this.httpClient.get(this.baseUrl + '/getSpecialScreenPromo', {
        headers: createAuthHeader(new HttpHeaders())
      });
    }
  }
  editPromotion(promotion, parent){
    return this.httpClient.post(this.baseUrl + '/editPromotion', {promotion, parent}, {
      headers: createAuthHeader(new HttpHeaders())
    });
  }
  deletePromotion(promotionId, tableName){
    return this.httpClient.post(this.baseUrl + '/deletePromotion', {promotionId, tableName}, {
      headers: createAuthHeader(new HttpHeaders())
    });
  }
  editPromoPrices(promoName, price){
    return this.httpClient.post(this.baseUrl + '/updatePromoPrice', {promoName, price}, {
      headers: createAuthHeader(new HttpHeaders())
    });
  }



}
