@isTest
private class CustomerRestServiceTest {

    @testSetup
    static void setup() {
        List<Customer__c> listC = new List<Customer__c>{
            new Customer__c(Name='Customer A', Email__c='a@a.com', Status__c='Active'),
            new Customer__c(Name='Customer B', Email__c='b@b.com', Status__c='Inactive')
        };
        insert listC;
    }

    // Helper para Requests
    private static void prepareRequest(String method, String url, Object body) {
        RestRequest req = new RestRequest();
        req.httpMethod = method;
        req.requestURI = url;

        if (body != null) {
            req.requestBody = Blob.valueOf(JSON.serialize(body));
        }

        RestContext.request = req;
        RestContext.response = new RestResponse();
    }

    // --------------------------
    // GET List
    // --------------------------
    @isTest
    static void testGetList() {
        prepareRequest('GET', '/services/apexrest/v1/customers', null);

        Test.startTest();
        CustomerRestService.doGet();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
    }

    // --------------------------
    // GET by Id
    // --------------------------
    @isTest
    static void testGetSingle() {
        Customer__c c = [SELECT Id FROM Customer__c LIMIT 1];

        prepareRequest('GET', '/services/apexrest/v1/customers/' + c.Id, null);

        Test.startTest();
        CustomerRestService.doGet();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
    }

    @isTest
    static void testGetNotFound() {
        prepareRequest('GET', '/services/apexrest/v1/customers/001XXXX', null);

        Test.startTest();
        CustomerRestService.doGet();
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode);
    }

    // --------------------------
    // POST
    // --------------------------
    @isTest
    static void testPost() {
        Map<String,Object> payload = new Map<String,Object>{
            'Name' => 'Created Test',
            'Email' => 'new@ex.com',
            'Status' => 'Active'
        };

        prepareRequest('POST', '/services/apexrest/v1/customers', payload);

        Test.startTest();
        CustomerRestService.doPost();
        Test.stopTest();

        System.assertEquals(201, RestContext.response.statusCode);
    }

    // --------------------------
    // PUT
    // --------------------------
    @isTest
    static void testPut() {
        Customer__c c = [SELECT Id FROM Customer__c LIMIT 1];

        Map<String,Object> payload = new Map<String,Object>{
            'Email' => 'updated@ex.com'
        };

        prepareRequest('PUT', '/services/apexrest/v1/customers/' + c.Id, payload);

        Test.startTest();
        CustomerRestService.doPut();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
    }

    @isTest
    static void testPutNotFound() {
        Map<String,Object> payload = new Map<String,Object>{ 'Email' => 'x@x.com' };

        prepareRequest('PUT', '/services/apexrest/v1/customers/001XXXXX', payload);

        Test.startTest();
        CustomerRestService.doPut();
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode);
    }

    // --------------------------
    // DELETE
    // --------------------------
    @isTest
    static void testDelete() {
        Customer__c c = [SELECT Id FROM Customer__c LIMIT 1];

        prepareRequest('DELETE', '/services/apexrest/v1/customers/' + c.Id, null);

        Test.startTest();
        CustomerRestService.doDelete();
        Test.stopTest();

        System.assertEquals(204, RestContext.response.statusCode);
    }

    @isTest
    static void testDeleteNotFound() {
        prepareRequest('DELETE', '/services/apexrest/v1/customers/001XXXXX', null);

        Test.startTest();
        CustomerRestService.doDelete();
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode);
    }
    
}
