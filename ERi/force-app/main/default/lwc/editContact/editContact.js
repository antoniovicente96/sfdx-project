import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

const FIELDS = [
    'Contact.Name',
];

export default class editContact extends LightningElement {
    @api recordId;
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    contact;
    isLoading = false;

    handleLoad() {
        this.isLoading = !this.isLoading;
    }

    get name() {
        return this.contact.data.fields.Name.value;
    }
    
}