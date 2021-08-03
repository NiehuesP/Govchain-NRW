import {Component, OnInit} from '@angular/core';
import {NavigationEnd, Router, RouterEvent} from '@angular/router';
import {filter} from 'rxjs/operators';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  title = 'Wohnungsgeberbestaetigung';
  currentRoute: string;

  constructor(public router: Router) { }

  ngOnInit(): void {
    this.router.events.pipe(filter(event => event instanceof NavigationEnd)
    ).subscribe(event =>
    {
      if (event instanceof RouterEvent) {
        this.currentRoute = event.url;
      }
    });
  }
}
