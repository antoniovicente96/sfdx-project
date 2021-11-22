import { LightningElement, api } from 'lwc';
import storePdf from '@salesforce/apex/PdfController.generatePDF';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class SavePdf extends LightningElement {
    @api recordId;

    btnPdf() {
        storePdf({
            recordId : this.recordId
        }).then(result => {
            this.isLoading = false;
            const evt = new ShowToastEvent({
                title:'Success!',
                message: 'NDA document created sucessfully!',
                variant: 'success',
            });
        })
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
      }
}