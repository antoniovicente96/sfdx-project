global with sharing class NewCampaign implements Database.Batchable<SObject>, Schedulable{
    global String query;
    private List<Contact> lstContacts;

    public NewCampaign() {
        this.query = getBatchQuery();
        this.lstContacts = [SELECT id, Name, Email FROM Contact];
    }
    private String getBatchQuery() {
        String query = 'SELECT Id, Name FROM Campaign';
        return query;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<SObject> scope) {

    }

    global void finish(Database.BatchableContext bc) {
        EmailTemplate template = [SELECT Id, Name, Subject, HtmlValue, body FROM Emailtemplate WHERE Name = 'NewCampaignEmail' LIMIT 200];

        String htmlBody = template.HtmlValue;

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        Messaging.SingleEmailMessage[] messages;
        Messaging.SendEmailResult[] results;

        message.setTemplateId(template.ID);
        message.setHtmlBody(htmlBody);
        message.setSubject(template.Subject);
        message.toaddresses = new String[] {'antoniorunscape123@gmail.com'};

        messages = new List<Messaging.SingleEmailMessage> {message};

        results = Messaging.sendEmail(messages);
    }
    global void execute(SchedulableContext sc) {
        NewCampaign be = new NewCampaign();
        Database.executeBatch(be);
    }
}