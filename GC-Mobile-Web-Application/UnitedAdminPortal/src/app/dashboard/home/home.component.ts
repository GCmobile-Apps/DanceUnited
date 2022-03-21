import { Component, OnInit } from '@angular/core';
import {AuthenticationService} from "../../shared/services/authentication.service";

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent implements OnInit {

  constructor(private authService: AuthenticationService) { }

  ngOnInit(): void {
    // this.authService.validateToken().subscribe((res: any) => {
    //   console.log(res);
    // })
  }

}
