import {Injectable, OnInit} from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {ProfessionalUser} from '../../models/professionalUser';
import {BASE_URL, createAuthHeader} from '../../models/globals';

@Injectable({
  providedIn: 'root'
})
export class ProfessionalUserService {

  readonly baseURL = BASE_URL;
  header = new HttpHeaders();

  constructor(public http: HttpClient) {
  }
  // tslint:disable-next-line:typedef

  // tslint:disable-next-line:typedef
  postUser(user: ProfessionalUser){
    return this.http.post(this.baseURL + '/createNewProfessionalUserFromPortal', user,
      {headers : createAuthHeader(this.header)});
  }
  // tslint:disable-next-line:typedef
  getAllUsers(){
    return this.http.get(this.baseURL + '/findAllProUsers',
      {headers: createAuthHeader(this.header)});
  }
  // tslint:disable-next-line:typedef
  editUser(user){
    return this.http.post(this.baseURL + '/updateProUser?userID=' + user.userID, user,
      {headers: createAuthHeader(this.header)});
  }
  // tslint:disable-next-line:typedef
  deleteUser(userEmail) {
    return this.http.post(this.baseURL + '/deleteProUser?email=' + userEmail, userEmail, {
      headers: createAuthHeader(this.header),
    });
  }
  // editDescription(){
  //   return this.http.post(this.baseURL + '/editDescription',
  //     {userID: 'bb0b946b-646c-4dfd-9529-2d3ce12316f8',
  //           description: 'upddateed onee'
  //
  //   },
  //     {
  //       headers: createAuthHeader(this.header),
  //     })
  // }
}
