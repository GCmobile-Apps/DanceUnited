import {Component, OnInit, ViewChild} from '@angular/core';
import {LinksService} from '../../shared/services/links.service';
import {Link} from '../../models/links.model';
import {NgForm} from '@angular/forms';
import {Subscription} from "rxjs";
import {AutoLogout, logout} from "../../models/globals";
import {MessageService} from "primeng/api";

@Component({
  selector: 'app-update-links',
  templateUrl: './update-links.component.html',
  styleUrls: ['./update-links.component.scss']
})
export class UpdateLinksComponent implements OnInit {
  links: Link[] = [];
  subscriptions: Subscription[] = [];
  noData = false;
  @ViewChild('updateLinkForm') updateLinkForm: NgForm;
  constructor(private linkService: LinksService, private messageService: MessageService) { }

  ngOnInit(): void {
    this.subscriptions.push(
      this.linkService.getLinks().subscribe((data: any) => {
        if(data?.statusCode === 401){
          logout();
          return;
        }
        if(data.data.length > 0){
          this.links = data.data;
        }
        else {
          this.noData = true;
        }
      },
        error => {
          AutoLogout(error)
        })
    );

  }
  updateLink(link){
    console.log(link);
    this.subscriptions.push(
      this.linkService.updateLink(link).subscribe((data: any) => {
          this.messageService.add({severity: 'success', summary: 'Success', detail: 'Link Updated'});
          if(data?.statusCode === 401){
            logout();
            return;
          }
      },
        error => {
          AutoLogout(error)
        })
    );
  }

}
