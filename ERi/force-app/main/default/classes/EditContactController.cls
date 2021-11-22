public with sharing class EditContactController {
    @AuraEnabled
    public static List<Contact> getContact () {
        string query= 'SELECT Id, Name from Contacts';
        
         return Database.query( query );
    }
}