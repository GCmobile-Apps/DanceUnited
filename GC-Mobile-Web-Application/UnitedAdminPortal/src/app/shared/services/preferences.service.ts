import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {BASE_URL, createAuthHeader} from '../../models/globals';

@Injectable({
  providedIn: 'root'
})
export class PreferencesService {

  baseUrl = BASE_URL;
  constructor(private httpClient: HttpClient) { }

  getAllPreferences(){
    return this.httpClient.get(this.baseUrl + '/preferences', {
      headers: createAuthHeader(new HttpHeaders())
    });
  }
  addNewPreference(preference){
    return this.httpClient.post(this.baseUrl + '/addNewPreference', {preference}, {
      headers: createAuthHeader(new HttpHeaders())
    });
  }
  //test for mobile app route
  prefUpdatee(){
    let u = {preference1: 'p1nww', preference2: 'p2nww', userID:'c39796d0-710c-11eb-8830-0bb33f64e492'};
    return this.httpClient.post(this.baseUrl + '/updatePreferences', u);
  }
}
