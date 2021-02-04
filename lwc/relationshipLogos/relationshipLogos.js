import { LightningElement, wire, api } from 'lwc';
import Id from '@salesforce/user/Id';
import { NavigationMixin } from 'lightning/navigation';
import getCustomerLogos from '@salesforce/apex/relationshipLogoController.getCustomerLogos';
import getProspectLogos from '@salesforce/apex/relationshipLogoController.getProspectLogos';

export default class RelationshipLogos extends NavigationMixin(LightningElement) {
    userId = Id;
    @api customerLogos;
    @api prospectLogos;

    @wire(getCustomerLogos, {userId : '$userId' }) customerLogos;
    @wire(getProspectLogos, {userId : '$userId' }) prospectLogos;

    // Navigate to view Customer or Prospect
    navigateTo(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.target.name,
                actionName: 'view'
            },
        });
    }
}