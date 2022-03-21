import {Component, OnInit, ViewChild} from '@angular/core';
import {NgForm} from '@angular/forms';
import {Router} from '@angular/router';
import {AuthenticationService} from '../shared/services/authentication.service';
import {Subscription} from 'rxjs';

@Component({
  selector: 'app-professonallogin',
  templateUrl: './professonallogin.component.html',
  styleUrls: ['./professonallogin.component.scss']
})
export class ProfessonalloginComponent implements OnInit {

  @ViewChild('loginForm', {static: false}) loginForm: NgForm;
  user = {
    email: '',
    password : ''
  };
  ifForgotPassword = false;
  invalidCredentials = false;
  passwordResetMsg = false;
  subscriptions: Subscription[] = [];
  constructor(private router: Router, private authenticationService: AuthenticationService) { }

  ngOnInit(): void {
    if (localStorage.getItem('loggedInStatus') === '1'){
      this.router.navigate(['/createvent']);
    }
    else
    {
      this.router.navigate(['userlogin']);
    }
  }
  login(){
    this.invalidCredentials = false;
    this.subscriptions.push(
      this.authenticationService.professionallogin(this.user).subscribe((data: any) => {
        console.log(data);
        if (data.status === true){
          localStorage.setItem('token', data.data.token);
          localStorage.setItem('loggedInStatus', '1');
          localStorage.setItem('userId', data.data.userId);
          localStorage.setItem("location",data.data.location);
          this.router.navigate(['/createvent']);
          this.loginForm.reset();
          return;
        }
        this.invalidCredentials = true;
      })
    );

  }
  forgotPassword(): void{
    this.subscriptions.push(
      this.authenticationService.forgotPassword(this.user.email).subscribe((res: any) => {
        if (res.status){
          this.invalidCredentials = false;
          this.passwordResetMsg = true;
          this.ifForgotPassword = false;
          this.user.email = '';
          this.user.password = '';
        }
        else {
          this.passwordResetMsg = false;
          this.invalidCredentials = true;
        }
      })
    );

  }


  AdminloginRedirect(){
    this.router.navigate(['/adminlogin']);
  }

}
