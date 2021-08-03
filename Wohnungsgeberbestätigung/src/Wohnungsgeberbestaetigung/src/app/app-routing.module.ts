import {NgModule} from '@angular/core';
import {RouterModule, Routes} from '@angular/router';
import {WohnungsgeberbestaetigungComponent} from './component/wohnungsgeberbestaetigung/wohnungsgeberbestaetigung.component';
import {PageNotFoundComponent} from './component/page-not-found/page-not-found.component';
import {StartPageComponent} from './component/start-page/start-page.component';

const routes: Routes = [
  { path: '',   redirectTo: '/home', pathMatch: 'full' },
  { path: 'home', component: StartPageComponent },
  { path: 'wohnungsgeberbestaetigung', component: WohnungsgeberbestaetigungComponent },
  { path: '**', component: PageNotFoundComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
