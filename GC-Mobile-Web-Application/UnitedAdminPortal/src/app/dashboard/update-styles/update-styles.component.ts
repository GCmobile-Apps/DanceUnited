import {Component, OnDestroy, OnInit, ViewChild} from '@angular/core';
import {PreferencesService} from '../../shared/services/preferences.service';
import {Subscription} from 'rxjs';
import {NgForm} from '@angular/forms';
import {DanceStyles} from '../../models/danceStyles';
import * as uuid from 'uuid';
import {MessageService} from "primeng/api";
import {AutoLogout, logout} from "../../models/globals";
@Component({
  selector: 'app-update-styles',
  templateUrl: './update-styles.component.html',
  styleUrls: ['./update-styles.component.scss']
})
export class UpdateStylesComponent implements OnInit, OnDestroy {

  preferences = [];
  subscriptions: Subscription[] = [];
  displayModal = false;
  preference: DanceStyles;
  @ViewChild('prefForm') prefForm: NgForm;
  constructor(private prefService: PreferencesService, private messageService: MessageService) { }

  ngOnInit(): void {
    this.getAllPreferences();
  }
  getAllPreferences(): void{
    this.subscriptions.push(
    this.prefService.getAllPreferences().subscribe((result:any) => {
        if(result?.statusCode === 401){
          logout();
          return;
        }

      this.preferences = result.list;

    },
      error => {
        AutoLogout(error)
      })
    );
  }
  addNewPreference(form): void {
    this.preference = {
      PreferenceID: uuid.v4(),
      PreferenceName: form.value.PreferenceName
    };

    this.subscriptions.push(
      this.prefService.addNewPreference(this.preference).subscribe((res: any) => {
          if(res?.statusCode === 401){
            logout();
            return;
          }
        this.preferences.push(this.preference);
        this.messageService.add({severity: 'success', summary: 'Successful', detail: 'Style Added', life: 3000});
        this.preference.PreferenceID = res.insertId;
        this.prefForm.reset();
      },
        error => {
          AutoLogout(error)
        })
    );
    this.displayModal = false;

  }

  ngOnDestroy(): void{
    this.subscriptions.forEach(sub => sub.unsubscribe());
  }

}
