import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {BASE_URL, createAuthHeader} from '../../models/globals';

@Injectable({
  providedIn: 'root'
})
export class LinksService {
  baseUrl = BASE_URL;
  header = new HttpHeaders();

  constructor(private httpClient: HttpClient) { }

  getLinks(){
    return this.httpClient.get(this.baseUrl + '/findAllLinks', {
      headers: createAuthHeader(this.header)
    });
  }
  updateLink(link){
    this.header = this.header.set('authorization', localStorage.getItem('token'));
    return this.httpClient.post(this.baseUrl + '/updateLink', link , {headers: createAuthHeader(this.header)});
  }

  UpdateMarketingToggle(Value){
  console.log("I am calling thus");
  console.log(Value);
  this.header = this.header.set('authorization', localStorage.getItem('token'));
  return this.httpClient.post(this.baseUrl + '/marketingtoggle', Value , {headers: createAuthHeader(this.header)});

  }

}
