import { Injectable } from '@angular/core';
import {User} from '../../models/user.model';
import {HttpClient, HttpHeaders, HttpParams} from '@angular/common/http';
import {BASE_URL, createAuthHeader} from '../../models/globals';

@Injectable({
  providedIn: 'root'
})
export class UsersService {

  readonly baseURL = BASE_URL;
  constructor(public http: HttpClient) {}

  postUser(user: User){
    console.log(user);
    return this.http.post(BASE_URL + '/createNewUserFromPortal', {user},
      {headers: createAuthHeader(new HttpHeaders())});
  }
  // tslint:disable-next-line:typedef
  getAllUsers(){
    return this.http.get(this.baseURL + '/allUsers', {headers: createAuthHeader(new HttpHeaders())});
  }
  editUser(user){
    console.log(user);
    return this.http.post(this.baseURL + '/updateUser?email=' + user.Email, user, {headers: createAuthHeader(new HttpHeaders()),
      // params : new HttpParams().append('email', user.Email)
    });
  }
  deleteUser(userEmail) {
    return this.http.post(this.baseURL + '/deleteUser?email=' + userEmail, userEmail, {
      headers: createAuthHeader(new HttpHeaders()),
      // params: new HttpParams().append('email', userEmail)
    });
  }
}
