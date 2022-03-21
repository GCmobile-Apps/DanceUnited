import {Component, OnInit, ViewChild} from '@angular/core';
import {NgForm} from '@angular/forms';
import {Router} from '@angular/router';
import {AuthenticationService} from '../shared/services/authentication.service';
import {Subscription} from 'rxjs';

@Component({
  selector: 'app-auth',
  templateUrl: './auth.component.html',
  styleUrls: ['./auth.component.scss']
})
export class AuthComponent implements OnInit {
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
      this.router.navigate(['/dashboard/home']);
    }
    else
    {
      this.router.navigate(['login']);
    }
  }
  login(){
    this.invalidCredentials = false;
    this.subscriptions.push(
      this.authenticationService.login(this.user).subscribe((data: any) => {
        if (data.status === true){
          localStorage.setItem('token', data.data.token);
          localStorage.setItem('loggedInStatus', '1');
          this.router.navigate(['/dashboard/home']);
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

}
