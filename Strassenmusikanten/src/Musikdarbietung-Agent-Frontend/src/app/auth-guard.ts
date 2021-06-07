import {Injectable} from '@angular/core';
import {ActivatedRouteSnapshot, CanActivate, RouterStateSnapshot} from '@angular/router';
import {Observable} from 'rxjs';
import {AuthService} from './service/auth.service';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private authService: AuthService) {}

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<boolean> | Promise<boolean> | boolean {
    if (!this.authService.isLoggedIn()) {
      return false;
    }
    const requiredRoles: string[] = route.data['roles'];
    return (!requiredRoles || requiredRoles.indexOf(this.authService.user.roleName) >= 0);
  }
}
