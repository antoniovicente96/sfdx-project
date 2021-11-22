public without sharing class PdfController {
    private final Id selectOrderItem;
    public List<OrderItem> ordItem {set; get;}
    public PdfController(Apexpages.StandardController stdController) {
        selectOrderItem = stdController.getId();
        ordItem = getOrderItems();
    }

    public List<OrderItem> getOrderItems() {
        return [SELECT Id, Product2.Name, UnitPrice, Quantity, TotalPrice FROM OrderItem WHERE OrderId =: selectOrderItem];
    }

    public static Boolean storePdf(String orderId) {
        PageReference pdf;
        pdf = Page.PdfTemplate;
        pdf.getParameters().put('Id',orderId);


        // the contents of the attachment from the pdf
        Blob body;

        try {
            // returns the output of the page as a PDF
            body = pdf.getContent();
        } catch (VisualforceException e) {
            body = Blob.valueOf('Some Text');
            System.debug(e.getMessage());
        }
        System.debug(body);

        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
        cVersion.PathOnClient ='Teste.pdf';//File name with extention
        cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
        cVersion.Title = 'Teste.pdf';//Name of the file
        cVersion.VersionData = body;//File content
        Insert cVersion;


        ContentVersion cVersion2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cVersion.Id LIMIT 1];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = orderId;
        contentlink.ContentDocumentId = cVersion2.ContentDocumentId;
        contentlink.ShareType = 'V';
        contentlink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
        insert contentlink;

        ContentDistribution cd = new ContentDistribution();
        cd.Name = 'Test.pdf';
        cd.ContentVersionId = cVersion2.id;
        cd.PreferencesAllowViewInBrowser= true;
        cd.PreferencesLinkLatestVersion=true;
        cd.PreferencesNotifyOnVisit=false;
        cd.PreferencesPasswordRequired=false;
        cd.PreferencesAllowOriginalDownload= true;
        insert cd;

        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setBody(body);
        attachment.setFileName('ConfirmacaodeEncomenda.pdf');
        attachment.setContentType('application/pdf');
        attachment.setInline(false);

        List<Order> listOrd= [SELECT Id, Cliente__R.Email FROM Order WHERE id =: orderId LIMIT 1];
        List<string> toAddress = new List<string>();
        toAddress.add(listOrd.get(0).Cliente__R.Email);
        EmailTemplate emltmp = [SELECT Id,Subject, HtmlValue FROM EmailTemplate WHERE Name = 'newOrderSuccess' LIMIT 1];
        String htmlBody = emltmp.HtmlValue;

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSenderDisplayName('noreply@eri.com');
        email.setSubject('Nova Encomenda - ERi');
        email.setToAddresses(toAddress);
        email.setSaveAsActivity(false);
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
        email.setHtmlBody(htmlBody);

        Order orderStatus = [SELECT Id, Status FROM Order WHERE Id = :orderId];

        if (orderStatus.Status == 'Activated' ) {
            try {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            } catch (Exception e) {
                System.debug(e.getMessage());
            }
        }

        return true;
    }

    @AuraEnabled
    public static String generatePDF(String orderId){
        try {
            storePdf(orderId);
            return ' ';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}