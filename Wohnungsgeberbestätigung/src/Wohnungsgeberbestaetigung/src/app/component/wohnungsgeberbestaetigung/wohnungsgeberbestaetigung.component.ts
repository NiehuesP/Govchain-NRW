import {Component, OnInit} from '@angular/core';
import {SubmitAndSendService} from '../../service/submit-and-send.service';
import {MatSnackBar} from '@angular/material/snack-bar';
import {WohnungsgeberbestaetigungDto} from '../../dto/wohnungsgeberbestaetigung-dto';
import {DatePipe} from '@angular/common';
import {Router} from '@angular/router';

@Component({
  selector: 'app-wohnungsgeberbestaetigung',
  templateUrl: './wohnungsgeberbestaetigung.component.html',
  styleUrls: ['./wohnungsgeberbestaetigung.component.css']
})
export class WohnungsgeberbestaetigungComponent implements OnInit {
  submitted: boolean;
  nameBeauftragt: string;
  wohnortBeauftragt: string;
  nameEigentuemer: string;
  wohnortEigentuemer: string;
  nameWohnungsgeber: string;
  wohnortWohnungsgeber: string;
  adresse: string;
  einzugsbestaetigung: string;
  tagDesEinzugs: Date;
  email: string;
  wohnungsgeberbestaetigungDto: WohnungsgeberbestaetigungDto;

  constructor(private submitAndSendService: SubmitAndSendService,
              public snackBar: MatSnackBar,
              private router: Router) { }

  ngOnInit(): void {
    this.submitted = true;
    this.wohnungsgeberbestaetigungDto = new WohnungsgeberbestaetigungDto();
  }

  submit(): void {
    this.submitted = false;
    const pipe = new DatePipe('de-DE');
    this.wohnungsgeberbestaetigungDto.nameBeauftragt = this.nameBeauftragt;
    this.wohnungsgeberbestaetigungDto.wohnortBeauftragt = this.wohnortBeauftragt;
    this.wohnungsgeberbestaetigungDto.nameEigentuemer = this.nameEigentuemer;
    this.wohnungsgeberbestaetigungDto.wohnortEigentuemer = this.wohnortEigentuemer;
    this.wohnungsgeberbestaetigungDto.nameWohnungsgeber = this.nameWohnungsgeber;
    this.wohnungsgeberbestaetigungDto.wohnortWohnungsgeber = this.wohnortWohnungsgeber;
    this.wohnungsgeberbestaetigungDto.adresse = this.adresse;
    this.wohnungsgeberbestaetigungDto.einzugsbestaetigung = this.einzugsbestaetigung;
    this.wohnungsgeberbestaetigungDto.tagDesEinzugs = pipe.transform(this.tagDesEinzugs, 'yyyy-MM-dd').toString();
    this.wohnungsgeberbestaetigungDto.email = this.email;
    this.submitAndSendService.send(this.wohnungsgeberbestaetigungDto).subscribe(result2 => {
      this.submitted = true;
      this.router.navigate(['home']);
      this.snackBar.open('Wohnungsgeberbestätigung erfolgreich gesendet!', 'Schließen', {duration: 3000});
      });
  }
}
