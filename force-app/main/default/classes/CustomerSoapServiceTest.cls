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
private class CustomerSoapServiceTest {

    @TestSetup
    static void setup() {
        insert new Customer__c(
            Name = 'SOAP Test',
            Email__c = 'soap@test.com',
            Phone__c = '99999999',
            Status__c = 'Active'
        );
    }

    @IsTest
    static void testGetCustomer() {
        Customer__c c = [SELECT Id FROM Customer__c LIMIT 1];
        
        Test.startTest();
        CustomerSoapDTO dto = CustomerSoapService.getCustomer(c.Id);
        Test.stopTest();

        System.assertEquals(c.Id, dto.Id);
    }

    @IsTest
    static void testCreateCustomer() {
        CustomerSoapDTO dto = new CustomerSoapDTO();
        dto.Name = 'Created via SOAP';
        dto.Email = 'new@soap.com';

        Test.startTest();
        String newId = CustomerSoapService.createCustomer(dto);
        Test.stopTest();

        System.assertNotEquals(null, newId);
    }

    @IsTest
    static void testUpdateCustomer() {
        Customer__c c = [SELECT Id FROM Customer__c LIMIT 1];

        CustomerSoapDTO dto = new CustomerSoapDTO();
        dto.Id = c.Id;
        dto.Email = 'updated@soap.com';

        Test.startTest();
        CustomerSoapService.updateCustomer(dto);
        Test.stopTest();

        Customer__c updated = [SELECT Email__c FROM Customer__c WHERE Id = :c.Id];
        System.assertEquals('updated@soap.com', updated.Email__c);
    }

    @IsTest
    static void testDeleteCustomer() {
        Customer__c c = [SELECT Id FROM Customer__c LIMIT 1];

        Test.startTest();
        CustomerSoapService.deleteCustomer(c.Id);
        Test.stopTest();

        System.assertEquals(0, [SELECT COUNT() FROM Customer__c WHERE Id = :c.Id]);
    }
    
}