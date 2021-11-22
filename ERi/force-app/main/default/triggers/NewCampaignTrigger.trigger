trigger NewCampaignTrigger on Campaign (before insert) {
    List<Contact> listContactEmail = [SELECT Id, Email FROM Contact];
    EmailTemplate template = [SELECT Id, Name, Subject, HtmlValue, body FROM Emailtemplate WHERE Name = 'NewCampaignEmail' LIMIT 200];
    String htmlBody = template.HtmlValue;
    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
    for (Campaign cmp : trigger.new) {
        htmlBody = htmlBody.replace('{!NomedaCampanha}', cmp.Name);
        htmlBody = htmlBody.replace('{!campaignStart}', String.valueOf(cmp.StartDate));
        htmlBody = htmlBody.replace('{!campaignEnd}', String.valueOf(cmp.EndDate));
        message.setSubject(cmp.Name);
    }
    List<String> listEmail = new List<String>();
    
    for (Contact ct : listContactEmail) {
        listEmail.add(ct.Email);
    }
    message.setToAddresses(listEmail);

    Messaging.SingleEmailMessage[] messages;
    Messaging.SendEmailResult[] results;

    message.setTemplateId(template.ID);
    message.setHtmlBody(htmlBody);

    messages = new List<Messaging.SingleEmailMessage> {message};

    try {
        results = Messaging.sendEmail(messages);
    } catch (Exception e) {
        System.debug('Exception Caught :' + e.getMessage() + ' Line: '+ e.getLineNumber());
    }
}