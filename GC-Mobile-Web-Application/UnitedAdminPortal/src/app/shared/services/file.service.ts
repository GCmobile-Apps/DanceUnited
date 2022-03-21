import { Injectable } from '@angular/core';
import {HttpClient, HttpHeaders} from '@angular/common/http';
import {BASE_URL, createAuthHeader} from '../../models/globals';

@Injectable({
  providedIn: 'root'
})
export class FileService {

  baseUrl = BASE_URL + '/file';
  constructor(private httpClient: HttpClient) { }

  uploadUserImage(file, folderName, Id){
    return this.httpClient.post(this.baseUrl + '/upload?folderName=' + folderName + '&Id=' + Id, file,
      {headers: createAuthHeader(new HttpHeaders())});
  }


}
