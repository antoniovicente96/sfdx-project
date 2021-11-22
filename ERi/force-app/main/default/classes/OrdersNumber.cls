public with sharing class OrdersNumber implements Schedulable {
    private List<Order> lstOrd;
    private List<user> lstUsr;
    
    public OrdersNumber() {
        this.lstOrd = [SELECT Id, Name, Status FROM Order WHERE Status = 'Draft'];
        this.lstUsr = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator'];
    }

    public void execute(SchedulableContext sc) {
        try {
            sendEmail(this.lstOrd,this.lstUsr);
        } catch (Exception e) {
            System.debug('Excepction Caught: ' + e.getMessage());
        }
    }

    public static void sendEmail(List<Order> lstOrd, List<User> lstUsr) {
        Integer countOpp = 0;
        for (Order opp : lstOrd) {
            countOpp++;
        }

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        Messaging.SingleEmailMessage[] messages;
        Messaging.SendEmailResult[] results;

        message.setSubject('Número de Orders por aprovar');
        message.setHtmlBody('O número de orders com o estado draft são: ' + String.valueOf(countOpp));
        List<String> listEmail = new List<String>();
    
        for (User usr : lstUsr) {
            listEmail.add(usr.Email);
        }
        message.setToAddresses(listEmail);

        messages = new List<Messaging.SingleEmailMessage> {message};

        results = Messaging.sendEmail(messages);
    }
}