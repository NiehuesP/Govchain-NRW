import {BrowserModule} from '@angular/platform-browser';
import {LOCALE_ID, NgModule} from '@angular/core';

import {AppComponent} from './app.component';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {MatProgressSpinnerModule} from '@angular/material/progress-spinner';
import {PageNotFoundComponent} from './component/page-not-found/page-not-found.component';
import {AppRoutingModule} from './app-routing.module';
import {HttpClientModule} from '@angular/common/http';
import {MatButtonModule} from '@angular/material/button';
import {MatDialogModule} from '@angular/material/dialog';
import {MatSnackBarModule} from '@angular/material/snack-bar';
import {MatInputModule} from '@angular/material/input';
import {FormsModule} from '@angular/forms';
import {WohnungsgeberbestaetigungComponent} from './component/wohnungsgeberbestaetigung/wohnungsgeberbestaetigung.component';
import {MatDatepickerModule} from '@angular/material/datepicker';
import {MatNativeDateModule} from '@angular/material/core';
import {registerLocaleData} from '@angular/common';
import localeDe from '@angular/common/locales/de';
import localeDeExtra from '@angular/common/locales/extra/de';
import {StartPageComponent} from './component/start-page/start-page.component';

registerLocaleData(localeDe, 'de-DE', localeDeExtra);

@NgModule({
  declarations: [
    AppComponent,
    PageNotFoundComponent,
    WohnungsgeberbestaetigungComponent,
    StartPageComponent
  ],
  imports: [
    AppRoutingModule,
    BrowserModule,
    BrowserAnimationsModule,
    HttpClientModule,
    MatNativeDateModule,
    MatDatepickerModule,
    MatDialogModule,
    MatProgressSpinnerModule,
    MatSnackBarModule,
    MatButtonModule,
    FormsModule,
    MatInputModule
  ],
  providers: [
    MatDatepickerModule,
    { provide: LOCALE_ID, useValue: 'de-DE' }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
