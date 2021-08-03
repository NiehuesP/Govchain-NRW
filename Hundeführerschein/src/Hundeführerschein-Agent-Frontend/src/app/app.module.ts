import {LOCALE_ID, NgModule} from '@angular/core';
import {BrowserModule} from '@angular/platform-browser';

import {AppComponent} from './app.component';
import {ConnectionComponent} from './component/connection/connection.component';
import {ConnectionDetailComponent} from './component/connection-detail/connection-detail.component';
import {LoginComponent} from './component/login/login.component';
import {HundehaltungComponent} from './component/hundehaltung/hundehaltung.component';
import {PageNotFoundComponent} from './component/page-not-found/page-not-found.component';
import {QrCodeComponent} from './component/qr-code/qr-code.component';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {MaterialModule} from './material/material.module';
import {registerLocaleData} from '@angular/common';
import localeDe from '@angular/common/locales/de';
import localeDeExtra from '@angular/common/locales/extra/de';
import {environment} from '../environments/environment';
import {HTTP_INTERCEPTORS, HttpClientModule} from '@angular/common/http';
import {MatDatepickerModule} from '@angular/material/datepicker';
import {AuthGuard} from './auth-guard';
import {LoginRequiredInterceptor} from './http-interceptor';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {JWT_OPTIONS, JwtModule} from '@auth0/angular-jwt';
import {AppRoutingModule} from './app-routing.module';
import {ConnectionPendingComponent} from './component/connection-pending/connection-pending.component';

export function jwtOptionsFactory(): any {
  return {
    tokenGetter: () => localStorage.getItem('access_token'),
    whitelistedDomains: environment.whitelistedDomains
  };
}

registerLocaleData(localeDe, 'de-DE', localeDeExtra);

@NgModule({
  declarations: [
    AppComponent,
    ConnectionComponent,
    ConnectionDetailComponent,
    LoginComponent,
    HundehaltungComponent,
    PageNotFoundComponent,
    QrCodeComponent,
    ConnectionPendingComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    MaterialModule,
    HttpClientModule,
    JwtModule.forRoot({
      jwtOptionsProvider: {
        provide: JWT_OPTIONS,
        useFactory: jwtOptionsFactory
      }
    }),
    FormsModule,
    ReactiveFormsModule,
    AppRoutingModule
  ],
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: LoginRequiredInterceptor,
      multi: true
    },
    AuthGuard,
    MatDatepickerModule,
    { provide: LOCALE_ID, useValue: 'de-DE' }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
