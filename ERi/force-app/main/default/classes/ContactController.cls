public with sharing class ContactController {
    @AuraEnabled(cacheable=true)
    public static Contact getSingleContact(){
        return [SELECT Id, Name, FirstName, LastName FROM Contact LIMIT 1];
    }
}