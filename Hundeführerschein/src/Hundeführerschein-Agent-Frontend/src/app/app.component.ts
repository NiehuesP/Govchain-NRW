import {Component, OnInit} from '@angular/core';
import {AuthService} from './service/auth.service';
import {NavigationEnd, Router, RouterEvent} from '@angular/router';
import {MatDialog, MatDialogConfig} from '@angular/material/dialog';
import {QrCodeComponent} from './component/qr-code/qr-code.component';
import {filter} from 'rxjs/operators';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'Hundehaltererlaubnis-Agent-Frontend';
  currentRoute: string;

  constructor(public authService: AuthService,
              public router: Router,
              private dialog: MatDialog) { }

  ngOnInit(): void {
    this.router.events.pipe(filter(event => event instanceof NavigationEnd)
    ).subscribe(event =>
    {
      if (event instanceof RouterEvent) {
        this.currentRoute = event.url;
      }
    });
  }

  gotRoles(... roles: string[]): boolean {
    return this.authService.user && roles.includes(this.authService.user.roleName);
  }

  createConnection(): void {
    const dialogConfig = new MatDialogConfig();
    dialogConfig.autoFocus = true;
    this.dialog.open(QrCodeComponent);
  }

  logout(): void {
    this.authService.logout();
  }
}
