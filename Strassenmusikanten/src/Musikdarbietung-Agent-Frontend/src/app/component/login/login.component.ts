import {Component, OnInit} from '@angular/core';
import {AuthService} from '../../service/auth.service';
import {Router} from '@angular/router';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  password: string;
  username: string;
  submitted: boolean;

  constructor(private authService: AuthService, private router: Router) { }

  ngOnInit(): void {
    localStorage.setItem('redirect_url', this.router.url);
    this.submitted = false;
    if (this.authService.isLoggedIn()) {
      this.router.navigate(['/connection']);
    }
  }

  login(): void {
    this.submitted = true;
    this.authService.login(this.username, this.password);
  }
}
