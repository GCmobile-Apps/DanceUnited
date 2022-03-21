import {AfterViewInit, Component, OnInit} from '@angular/core';
import {Router} from '@angular/router';
import {AuthenticationService} from "../shared/services/authentication.service";

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent implements OnInit {
  toggleNavbar = false;
  data ;
  constructor(private router: Router, private authService: AuthenticationService) { }

  ngOnInit(): void {
  }
  toggleSidebar() : void{
    this.toggleNavbar = !this.toggleNavbar;
    console.log(this.toggleNavbar);

    if(this.toggleNavbar){
      document.getElementById('sidebar').style.display = 'block';
    }
    else {
      document.getElementById('sidebar').style.display = 'none';
    }
  }
  logout(){
    this.authService.logout();
  }

}
