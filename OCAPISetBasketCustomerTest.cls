/**
 * @author  Susan Durand
 * @date    12/19/2019
 * @description Test class for OCAPISetBasketCustomer class
 */

@IsTest
public with sharing class OCAPISetBasketCustomerTest {

    /*
     * @description: Creates SFCC Integration Creds, Contact, and Web Profile
     */
    @testSetup
    static void setup(){

        //Insert basic required test data
        TestDataFactory.testDataSetup();

        //Create a Custom Setting to represent the SFCC Client Id
        SFCC_Integration_Creds__c integrationCred = TestDataFactory.generateSFCCIntegrationCred();
        insert integrationCred;

        //Create a Contact and Web Profile
        List<Contact> cons = TestDataFactory.generateContactList(1,'','');
        insert cons;
        List<Web_Profile__c> wps = TestDataFactory.generateWebProfiles(cons);
        Integer i = 0;
        for(Web_Profile__c wp : wps){
            wp.Customer_Num__c = String.valueOf(i);
            wp.Email__c = cons.get(i).Email;
        }
        insert wps;
    }

    /*
     * @description: Tests the Set Basket Customer class when the api callout was successful
     *                  Checks that basket JSON was saved, and no error message.
     */
    @IsTest
    public static void OCAPISetBasketCustomerSuccess(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPISetBasketCustomerMock(200));

        //Get web profile
        Web_Profile__c wp = [SELECT Id, Customer_Num__c, Email__c
                              FROM Web_Profile__c
                              LIMIT 1];

        //Create a list of OCAPIData
        List<OCAPIData> listOcapi = new List<OCAPIData>();
        OCAPIData ocapi = new OCAPIData();
        ocapi.profile = wp;
        ocapi.bearerToken = 'abc123';
        ocapi.basketId = 'qwerty12345';
        listOcapi.add(ocapi);

        Test.startTest();
            List<OCAPIData> responsesOcapi = OCAPISetBasketCustomer.setBasketCustomer(listOcapi);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Check that basket response json was saved to OCAPIData
        System.assert(responseOcapi.basketResponseJSON != '' && responseOcapi.basketResponseJSON != null);
        //Check that there is no error message
        System.assert(responseOcapi.errorMsg == null);
    }

    /*
     * @description: Tests the Set Basket Customer class when the api callout failed
     *                  Checks that error was saved, and no basket JSON.
     */
    @IsTest
    public static void OCAPISetBasketCustomerFail(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPISetBasketCustomerMock(400));

        //Get web profile
        List<Web_Profile__c> wps = [SELECT Id, Customer_Num__c, Email__c
                                    FROM Web_Profile__c
                                    LIMIT 1];

        //Create a list of OCAPIData
        List<OCAPIData> listOcapi = new List<OCAPIData>();
        OCAPIData ocapi = new OCAPIData();
        ocapi.profile = wps.get(0);
        ocapi.bearerToken = 'abc123';
        ocapi.basketId = 'qwerty12345';
        listOcapi.add(ocapi);

        Test.startTest();
            List<OCAPIData> responsesOcapi = OCAPISetBasketCustomer.setBasketCustomer(listOcapi);
        Test.stopTest();

        //Lookup Error Log
        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                                                                                        Response_Body__c, Response_Code__c
                                                                                FROM Error_Handling_Log__c]);

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Check that basket response json was saved to OCAPIData
        System.assert(responseOcapi.basketResponseJSON == null);
        //Check that there is no error message
        System.assert(responseOcapi.errorMsg != null && responseOcapi.errorMsg != '');
        //Check that only one Error log was created
        System.assert(errorLogs.size() == 1);
        Error_Handling_Log__c error = errorLogs.get(0);
        //Check that data was recorded on the Error Log
        System.assert(  error.Url__c != null &&
                error.Request_body__c != null &&
                error.Response_Body__c != null &&
                error.Response_Code__c != null);
    }

}