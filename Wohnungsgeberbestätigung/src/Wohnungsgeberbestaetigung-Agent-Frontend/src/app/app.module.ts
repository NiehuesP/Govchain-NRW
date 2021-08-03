import {BrowserModule} from '@angular/platform-browser';
import {LOCALE_ID, NgModule} from '@angular/core';

import {AppComponent} from './app.component';
import {ConnectionComponent} from './component/connection/connection.component';
import {ConnectionDetailComponent} from './component/connection-detail/connection-detail.component';
import {PageNotFoundComponent} from './component/page-not-found/page-not-found.component';
import {AppRoutingModule} from './app-routing.module';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {HTTP_INTERCEPTORS, HttpClientModule} from '@angular/common/http';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {ProofDetailComponent} from './component/proof-detail/proof-detail.component';
import {MaterialModule} from './material/material.module';
import {LoginComponent} from './component/login/login.component';
import {LoginRequiredInterceptor} from './http-interceptor';
import {AuthGuard} from './auth-guard';
import {environment} from '../environments/environment';
import {JWT_OPTIONS, JwtModule} from '@auth0/angular-jwt';
import {MeldebestaetigungComponent} from './component/meldebestaetigung/meldebestaetigung.component';
import {registerLocaleData} from '@angular/common';
import localeDe from '@angular/common/locales/de';
import localeDeExtra from '@angular/common/locales/extra/de';
import {MatDatepickerModule} from '@angular/material/datepicker';
import {ConnectionPendingComponent} from './component/connection-pending/connection-pending.component';
import {QrCodeComponent} from './component/qr-code/qr-code.component';

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
    PageNotFoundComponent,
    ProofDetailComponent,
    LoginComponent,
    MeldebestaetigungComponent,
    ConnectionPendingComponent,
    QrCodeComponent
  ],
    imports: [
      AppRoutingModule,
      BrowserModule,
      BrowserAnimationsModule,
      HttpClientModule,
      ReactiveFormsModule,
      MaterialModule,
      FormsModule,
      JwtModule.forRoot({
        jwtOptionsProvider: {
          provide: JWT_OPTIONS,
          useFactory: jwtOptionsFactory
        }
      })
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
