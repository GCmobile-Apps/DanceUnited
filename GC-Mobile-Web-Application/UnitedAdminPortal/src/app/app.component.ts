import {Component, OnInit} from '@angular/core';
import {AuthenticationService} from "./shared/services/authentication.service";

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit{
  title = 'AngularApp';
  constructor(private  authService: AuthenticationService) {
  }
  ngOnInit() {
    const timer = JSON.parse(localStorage.getItem('timer'));
    console.log(Date.now() > timer);
    if (timer && (Date.now() > timer)) {
      this.authService.logout();
    }
  }

}
