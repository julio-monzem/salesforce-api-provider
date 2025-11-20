/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class CustomerRestServiceTest {

    @isTest
    static void testListAndCreate() {
        // TO DO: implement unit test
        // criar dados
        Customer__c c1 = new Customer__c(Name='Cliente Teste', Email__c='a@b.com', Status__c='Active');
        insert c1;

        // test GET list
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestUri = '/services/apexrest/v1/customers';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        CustomerRestService.doGet();
        Test.stopTest();
        System.assertEquals(200, RestContext.response.statusCode);

        // test POST
        RestRequest req2 = new RestRequest();
        RestResponse res2 = new RestResponse();
        req2.requestUri = '/services/apexrest/v1/customers';
        req2.httpMethod = 'POST';
        Map<String,Object> payload = new Map<String,Object>{ 'Name' => 'Novo', 'Email' => 'n@e.com', 'Status' => 'Active' };
        req2.requestBody = Blob.valueOf(JSON.serialize(payload));
        RestContext.request = req2;
        RestContext.response = res2;
        Test.startTest();
        CustomerRestService.doPost();
        Test.stopTest();
        System.assertEquals(201, RestContext.response.statusCode);
    }
}