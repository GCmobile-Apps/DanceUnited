import { Injectable } from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {User} from '../../models/user.model';
import {Router} from '@angular/router';
import { BASE_URL} from '../../models/globals';
import {of, Subscription} from "rxjs";
import {delay} from "rxjs/operators";
// import { JwtHelperService } from "@auth0/angular-jwt";

@Injectable({
  providedIn: 'root'
})
export class AuthenticationService {

  currentUser: User;
  baseUrl = BASE_URL;
  timeout;
  authToken: any;
  tokenSubscription = new Subscription()

  constructor(private httpClient: HttpClient, private router: Router) {
  }
  login(user){
    this.currentUser = user;
    // const response = this.httpClient.post(this.baseUrl + '/adminLogin', user).subscribe((res: any) => {
    //   console.log(res.token);
    //   if(res.status === true){
    //     localStorage.setItem('token', res.token);
    //     localStorage.setItem('loggedInStatus', '1')
    //     const time_to_login = Date.now() + 604800000; // one week
    //     localStorage.setItem('timer', JSON.stringify(time_to_login));
    //   }
    //
    // });
    return this.httpClient.post(this.baseUrl + '/adminLogin', {user});
  }
  getToken(){
    return localStorage.getItem('token');
  }

  forgotPassword(email){
    return this.httpClient.post(this.baseUrl + '/forgotPasswordFromPortal', {email});
  }


  logout() {
    localStorage.removeItem('loggedInStatus');
    localStorage.removeItem('token');
    this.router.navigate(['/']);
  }
  professionallogin(user:any){
    return this.httpClient.post(this.baseUrl + '/professionalLogin', {user});
  }
}
