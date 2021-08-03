import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Router} from '@angular/router';
import {User} from '../model/user';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  user: User;

  constructor(private http: HttpClient, private router: Router) {
    this.updateUser();
  }
  isLoggedIn(): boolean {
    return !!this.user;
  }

  isAdmin(): boolean {
    return this.user ? this.user.roleName === 'ROLE_ADMIN' : false;
  }

  updateUser(): void {
    this.http.get('/api/account').subscribe((user: User) =>  {
      this.user = user;
      if (window.location.pathname === '/login') {
        this.router.navigateByUrl('/connection');
      } else {
        this.router.navigateByUrl(localStorage.getItem('redirect_url'));
      }
    });
  }

  login(username: string, password: string): void {
    const url = '/api/authenticate';
    const body = {
      username,
      password
    };
    this.http.post<any>(url, body).subscribe(data => {
      localStorage.setItem('access_token', data.id_token);
      this.updateUser();
      const redirectUrl = localStorage.getItem('redirect_url');
      localStorage.removeItem('redirect_url');
      this.router.navigateByUrl(redirectUrl);
    }, err => {
    });
  }

  logout(): void {
    localStorage.removeItem('access_token');
    this.user = undefined;
    this.router.navigate(['login']);
  }
}
