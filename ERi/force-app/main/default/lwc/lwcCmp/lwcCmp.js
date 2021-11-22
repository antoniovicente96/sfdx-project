import { LightningElement } from 'lwc';
 
export default class LwcCmp extends LightningElement {
    strRecordId;
    arrayFields = ['Name', 'Phone', 'Email', 'NIF__c', 'MailingAddress'];
}