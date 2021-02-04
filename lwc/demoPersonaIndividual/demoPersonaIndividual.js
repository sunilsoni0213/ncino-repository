import { LightningElement, api } from 'lwc';

export default class DemoPersonaIndividual extends LightningElement {

    @api user = {};

    @api
    set userIndex(index) {
        this._userIndex = index + 10;
    }

    get userIndex() {
        return this._userIndex;
    }

    get hasPhoto() {
        return this.user.imageURL ? true : false;
    }

    get photo() {
        return this.user.imageURL;
    }

    get initials() {
        let userArray = this.user.name.split(' ');
        return userArray[0].charAt(0) + userArray[1].charAt(0);
    }

    get abbrClassString() {
        return `slds-avatar__initials slds-icon-custom-${this.userIndex}`;
    }
}