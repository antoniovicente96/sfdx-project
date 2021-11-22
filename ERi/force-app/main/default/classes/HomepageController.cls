public with sharing class HomepageController {
    public HomepageController() {

    }

    public List<Product2> getProducts(){
        return [ SELECT Id, Name FROM Product2 LIMIT 5];
        }
        
}
