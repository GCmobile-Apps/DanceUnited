import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';


@Component({
  selector: 'app-adminsidebar',
  templateUrl: './adminsidebar.component.html',
  styleUrls: ['./adminsidebar.component.scss']
})
export class AdminsidebarComponent implements OnInit {

  constructor(private router: Router) { }

  ngOnInit(): void {
  }
  logoutuser(){
    localStorage.removeItem('userId');
    localStorage.removeItem('token');
    localStorage.removeItem('loggedInStatus');
    this.router.navigateByUrl("/userlogin");
  }

}
