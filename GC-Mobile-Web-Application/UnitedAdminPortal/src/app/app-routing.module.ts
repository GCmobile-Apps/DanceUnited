import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {AuthComponent} from './auth/auth.component';
import {DashboardComponent} from './dashboard/dashboard.component';
import {HomeComponent} from './dashboard/home/home.component';
import {EventsComponent} from './dashboard/events/events.component';
import { AllEventsComponent } from './dashboard/events/all-events/all-events.component';
import { AllUsersComponent } from './dashboard/users/all-users/all-users.component';
import { UsersComponent } from './dashboard/users/users.component';
import {AuthGaurdService} from './shared/gaurds/auth-gaurd.service';
import {UpdateLinksComponent} from './dashboard/update-links/update-links.component';
import {ProfessionalUsersComponent} from './dashboard/users/professional-users/professional-users.component';
import {OverviewComponent} from './dashboard/overview/overview.component';
import {PromotionsComponent} from './dashboard/promotions/promotions.component';
import {AddPromotionsComponent} from './dashboard/promotions/add-promotions/add-promotions.component';
import {UpdateStylesComponent} from './dashboard/update-styles/update-styles.component';
import {EditPromoPricesComponent} from './dashboard/promotions/edit-promo-prices/edit-promo-prices.component';
import {EventexploreComponent} from './eventexplore/eventexplore.component';
import {CreateventscreenComponent} from './createventscreen/createventscreen.component';
import { ProfessonalloginComponent } from './professonallogin/professonallogin.component';
import { ProfessionaldashboardComponent } from './professionaldashboard/professionaldashboard.component';
import { SidebarComponent } from './sidebar/sidebar.component';
import { AdmindashboardComponent } from './admindashboard/admindashboard.component';
import { AdminsidebarComponent } from './adminsidebar/adminsidebar.component';
import {ListeventComponent} from './dashboard/listevent/listevent.component';
const routes: Routes = [
  {
    path: '',
    component: EventexploreComponent
  },
  {
    path: 'sidebar',
    component: SidebarComponent
  },
  {
    path: 'adminevent',
    component: AdminsidebarComponent
  },
  {
    path: 'userdashboard',
    component: ProfessionaldashboardComponent
  },
  {
    path: 'userlogin',
    component:ProfessonalloginComponent
  },
  {
    path : 'createvent',
    component: CreateventscreenComponent
  },
  
  {
    path: 'adminlogin',
    component: AuthComponent
  },
  {
    path: 'admindashboard',
    component: AdmindashboardComponent
  },

  {
    path: 'dashboard',
    component: DashboardComponent,
    data: {username: 'admin'},
    canActivate: [AuthGaurdService],
    children: [
      {
        path: 'home',
        component: HomeComponent
      },
      {
        path: 'events',
        component: EventsComponent
      },
      {
        path: 'users',
        component: UsersComponent
      },
      {
        path: 'allEvents',
        component: AllEventsComponent
      },
      {
        path: 'allUsers',
        component: AllUsersComponent
      },
      {
        path: 'updateLinks',
        component: UpdateLinksComponent
      },
      {
        path: 'allProUsers',
        component: ProfessionalUsersComponent
      },
      {
        path: 'overview',
        component: OverviewComponent
      },
      {
        path: 'promotions',
        component: PromotionsComponent
      },
      {
        path: 'addPromo',
        component: AddPromotionsComponent
      },
      {
        path: 'updateDanceStyles',
        component: UpdateStylesComponent
      },
      {
        path: 'editPromoPrices',
        component: EditPromoPricesComponent
      },
      {
        path: 'eventexplore',
        component: EventexploreComponent
      },
      {
        path: 'listevent',
        component: ListeventComponent
      }

    ]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
