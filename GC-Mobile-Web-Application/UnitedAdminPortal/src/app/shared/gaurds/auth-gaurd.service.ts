import { Injectable } from '@angular/core';
import {
  ActivatedRoute,
  ActivatedRouteSnapshot,
  CanActivate,
  Router,
  RouterStateSnapshot,
  UrlTree
} from '@angular/router';
import {AuthenticationService} from '../services/authentication.service';
import {Observable} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthGaurdService implements CanActivate{

  // tslint:disable-next-line:variable-name
  constructor(private _route: ActivatedRoute, private _router: Router, private _authenticationService: AuthenticationService) { }

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot):
    Observable<boolean | UrlTree> | Promise<boolean | UrlTree> | boolean | UrlTree {
    return !!localStorage.getItem('loggedInStatus');

  }
}
