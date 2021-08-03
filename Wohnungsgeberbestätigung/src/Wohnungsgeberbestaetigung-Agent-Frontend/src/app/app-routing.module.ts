import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';
import {PageNotFoundComponent} from './component/page-not-found/page-not-found.component';
import {ConnectionComponent} from './component/connection/connection.component';
import {ConnectionDetailComponent} from './component/connection-detail/connection-detail.component';
import {AuthGuard} from './auth-guard';
import {LoginComponent} from './component/login/login.component';
import {ConnectionPendingComponent} from './component/connection-pending/connection-pending.component';

const routes: Routes = [
  { path: '',   redirectTo: '/login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { path: 'connection', component:  ConnectionComponent, canActivate: [AuthGuard], data: {roles: ['ROLE_ADMIN']} },
  { path: 'connection-pending', component:  ConnectionPendingComponent, canActivate: [AuthGuard], data: {roles: ['ROLE_ADMIN']} },
  { path: 'connection/detail/:id', component: ConnectionDetailComponent, canActivate: [AuthGuard], data: {roles: ['ROLE_ADMIN']} },
  { path: '**', component: PageNotFoundComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
