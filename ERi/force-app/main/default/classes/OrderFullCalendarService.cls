global with sharing class OrderFullCalendarService {
    @AuraEnabled
    global static string getOrd()
    {
        List<Order> ordList = new List<Order>();
        ordList = [ SELECT Id, OrderNumber, EffectiveDate FROM Order];
        return JSON.serialize(ordList); 
    }
}