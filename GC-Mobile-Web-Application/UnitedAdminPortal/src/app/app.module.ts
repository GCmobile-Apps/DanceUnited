import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { AuthComponent } from './auth/auth.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {HTTP_INTERCEPTORS, HttpClientModule} from '@angular/common/http';
import {InputTextModule} from 'primeng/inputtext';
import {ButtonModule} from 'primeng/button';
import {SidebarModule} from 'primeng/sidebar';
import { HomeComponent } from './dashboard/home/home.component';
import { EventsComponent } from './dashboard/events/events.component';
import {CalendarModule} from 'primeng/calendar';
import {ToastModule} from 'primeng/toast';
import {DropdownModule} from 'primeng/dropdown';
import {MultiSelectModule} from 'primeng/multiselect';
import { AllEventsComponent } from './dashboard/events/all-events/all-events.component';
import {TableModule} from 'primeng/table';
import { AllUsersComponent } from './dashboard/users/all-users/all-users.component';
import { UsersComponent } from './dashboard/users/users.component';
import { UpdateLinksComponent } from './dashboard/update-links/update-links.component';
import {AccordionModule} from 'primeng/accordion';
import {InputTextareaModule} from 'primeng/inputtextarea';
import {RippleModule} from 'primeng/ripple';
import {DialogModule} from 'primeng/dialog';
import {ConfirmationService, MessageService} from 'primeng/api';
import { ConfirmDialogModule} from 'primeng/confirmdialog';
import { ProfessionalUsersComponent } from './dashboard/users/professional-users/professional-users.component';
import {ProgressSpinnerModule} from 'primeng/progressspinner';
import {ProgressBarModule} from 'primeng/progressbar';
import {OverlayPanelModule} from 'primeng/overlaypanel';
import {TooltipModule} from 'primeng/tooltip';
import { OverviewComponent } from './dashboard/overview/overview.component';
import { PromotionsComponent } from './dashboard/promotions/promotions.component';
import { AddPromotionsComponent } from './dashboard/promotions/add-promotions/add-promotions.component';
import { UpdateStylesComponent } from './dashboard/update-styles/update-styles.component';
import { EditPromoPricesComponent } from './dashboard/promotions/edit-promo-prices/edit-promo-prices.component';
import {ScrollPanelModule} from 'primeng/scrollpanel';
import {CardModule} from 'primeng/card';
import {ToggleButtonModule} from 'primeng/togglebutton';
import { EventexploreComponent } from './eventexplore/eventexplore.component';
import {ReplaceUnderscorePipe} from './Pipes/ReplaceString';
import { CreateventscreenComponent } from './createventscreen/createventscreen.component';
import { ProfessonalloginComponent } from './professonallogin/professonallogin.component';
import { ProfessionaldashboardComponent } from './professionaldashboard/professionaldashboard.component';
import { SidebarComponent } from './sidebar/sidebar.component';
import { AdmindashboardComponent } from './admindashboard/admindashboard.component';
import { AdminsidebarComponent } from './adminsidebar/adminsidebar.component';
import { ListeventComponent } from './dashboard/listevent/listevent.component';

@NgModule({
  declarations: [
    AppComponent,
    AuthComponent,
    DashboardComponent,
    HomeComponent,
    EventsComponent,
    AllEventsComponent,
    AllUsersComponent,
    UsersComponent,
    UpdateLinksComponent,
    ProfessionalUsersComponent,
    OverviewComponent,
    PromotionsComponent,
    AddPromotionsComponent,
    UpdateStylesComponent,
    EditPromoPricesComponent,
    EventexploreComponent,
    ReplaceUnderscorePipe,
    CreateventscreenComponent,
    ProfessonalloginComponent,
    ProfessionaldashboardComponent,
    SidebarComponent,
    AdmindashboardComponent,
    AdminsidebarComponent,
    ListeventComponent,
    
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    FormsModule,
    BrowserAnimationsModule,
    HttpClientModule,
    InputTextModule,
    DropdownModule,
    MultiSelectModule,
    ButtonModule,
    CalendarModule,
    ToastModule,
    SidebarModule,
    TableModule,
    AccordionModule,
    InputTextModule,
    InputTextareaModule,
    RippleModule,
    DialogModule,
    ToastModule,
    ConfirmDialogModule,
    ProgressSpinnerModule,
    ProgressBarModule,
    OverlayPanelModule,
    TooltipModule,
    ScrollPanelModule,
    CardModule,
    ToggleButtonModule,
    ReactiveFormsModule,

  ],
  exports: [ReplaceUnderscorePipe],
  providers: [MessageService, ConfirmationService,
   ],
  bootstrap: [AppComponent]
})


export class AppModule { }
