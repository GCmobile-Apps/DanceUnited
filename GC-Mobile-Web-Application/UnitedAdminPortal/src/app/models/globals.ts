import {HttpErrorResponse} from "@angular/common/http";

export let BASE_URL = 'http://localhost:3000';
export let SERVER_PATH = 'http://localhost:3000';

export const v4options = {
  random: [
    0x10,
    0x91,
    0x56,
    0xbe,
    0xc4,
    0xfb,
    0xc1,
    0xea,
    0x71,
    0xb4,
    0xef,
    0xe1,
    0x67,
    0x1c,
    0x58,
    0x36,
  ]
};

// tslint:disable-next-line:typedef
export function createAuthHeader(header){
  return header.set('authorization', localStorage.getItem('token'));
}

export const Preferences = [
    {label: 'Kizomba', value: 'Kizomba'},
    {label: 'Cuban Salsa', value: 'Cuban Salsa'},
    {label: 'UrbanKiz', value: 'UrbanKiz'},
    {label: 'Salsa', value: 'Salsa'},
    {label: 'Semba', value: 'Semba'},
    {label: 'Zouk', value: 'Zouk'},
    {label: 'Bachata', value: 'Bachata'},
    {label: 'Bachata Sensual', value: 'Bachata Sensual'},
    {label: 'Domenican Bachata', value: 'Domenican Bachata'},
    {label: 'Salsa L.A. Style', value: 'Salsa L.A. Style'},
];
export const locations = [
  {label: 'Europe', value: 'Europe'},
  {label: 'Sweden', value: 'Sweden'},
  {label: 'Gothenburg', value: 'Gothenburg'},
];

export const eventTypes = [
  'Classes', 'Social', 'Party', 'Festival', 'Dancers', 'Professionals', 'Events'
];


export function AutoLogout(err): void{
  const arr = ['token', 'loggedInStatus'];
  if (err instanceof HttpErrorResponse){
    if (err.status === 401){
      arr.forEach(i => {
        localStorage.removeItem(i);
      });

      window.location.href = '';
    }
  }
}
export function logout() {
  localStorage.removeItem('loggedInStatus');
  localStorage.removeItem('token');
  window.location.href = '';
}

