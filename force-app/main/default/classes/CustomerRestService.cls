@RestResource(urlMapping='/v1/customers/*')
global with sharing class CustomerRestService {
    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        String id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if (id == 'v1' || id == 'customers' || id == '') {
            List<Customer__c> listC = [SELECT Id, Name, Email__c, Phone__c, Status__c FROM Customer__c LIMIT 200];
            RestContext.response.statusCode = 200;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listC));
            return;
        }
        try {
            Customer__c c = [SELECT Id, Name, Email__c, Phone__c, Status__c FROM Customer__c WHERE Id = :id LIMIT 1];
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(c));
            RestContext.response.statusCode = 200;
        } catch (Exception e) {
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new Map<String,String>{ 'error' => 'Not found' }));
        }
    }

    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        String body = req.requestBody.toString();
        Map<String,Object> payload = (Map<String,Object>) JSON.deserializeUntyped(body);
        Customer__c c = new Customer__c(
            Name = (String) payload.get('Name'),
            Email__c = (String) payload.get('Email'),
            Phone__c = (String) payload.get('Phone'),
            Status__c = (String) payload.get('Status')
        );
        insert c;
        RestContext.response.statusCode = 201;
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(c));
    }
}