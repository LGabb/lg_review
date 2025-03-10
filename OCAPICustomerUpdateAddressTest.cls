/**
 * Created by susan.durand
 * Created Date 8/20/2020 - No code written until 6/7/2023
 * Description: Test class for OCAPICustomerUpdateAddress class
 */

@IsTest
public with sharing class OCAPICustomerUpdateAddressTest {

    /**
    * @description: Setup method - creates the Integration Credentials needed for api calls in the Callout Handler
    */
    @TestSetup
    public static void setup(){

        //Insert basic required test data
        TestDataFactory.testDataSetup();

        //Create a Custom Setting to represent the SFCC Client Id
        SFCC_Integration_Creds__c integrationCred = TestDataFactory.generateSFCCIntegrationCred();
        insert integrationCred;
    }

    /**
     * @description: Tests the Customer Address Update class when the api callout was successful
     *                  Checks that no error message was returned.
     */
    @IsTest
    public static void OCAPICustomerAddressSuccess(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICustomerUpdateAddressMock(200));

        //Create a Contact and Web Profile
        List<Contact> cons = TestDataFactory.generateContactList(1,'','');
        List<Web_Profile__c> profiles = TestDataFactory.generateWebProfiles(cons);
        profiles.get(0).Commerce_Cloud_ID__c = 'abc123def456';
        insert profiles;
        //Create an address related to the WP
        TestDataFactory.AddressWrapper wrapper = TestDataFactory.generateTestAddressList(1,TRUE,0).get(0);
        Map<Id, TestDataFactory.AddressWrapper> wpIdToWrapper = new Map<Id, TestDataFactory.AddressWrapper>{profiles.get(0).Id => wrapper};
        List<Web_Profile_Address__c> addresses = TestDataFactory.generateWPAddress(profiles, wpIdToWrapper);
        insert addresses;

        //Create a List of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.profile = profiles.get(0);
        ocapi.bearerToken = 'abc123';
        ocapi.customerAddress = addresses.get(0);
        List<OCAPIData> listOcapi = new List<OCAPIData>();
        listOcapi.add(ocapi);

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPICustomerUpdateAddress.updateCustomerAddress(listOcapi);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);
    }

    /**
     * @description: Tests the Customer Address Update class when the api callout had an error
     *                  Checks that error message was saved, and error log object created.
     */
    @isTest
    public static void OCAPICustomerAddressFail(){
        //Set the HTTP mock response to return an error
        Test.setMock(HttpCalloutMock.class, new OCAPICustomerUpdateAddressMock(400));

        //Create a Contact and Web Profile
        List<Contact> cons = TestDataFactory.generateContactList(1,'','');
        List<Web_Profile__c> profiles = TestDataFactory.generateWebProfiles(cons);
        profiles.get(0).Commerce_Cloud_ID__c = 'abc123def456';
        insert profiles;
        //Create an address related to the WP
        TestDataFactory.AddressWrapper wrapper = TestDataFactory.generateTestAddressList(1,TRUE,0).get(0);
        Map<Id, TestDataFactory.AddressWrapper> wpIdToWrapper = new Map<Id, TestDataFactory.AddressWrapper>{profiles.get(0).Id => wrapper};
        List<Web_Profile_Address__c> addresses = TestDataFactory.generateWPAddress(profiles, wpIdToWrapper);
        insert addresses;

        //Create a List of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.profile = profiles.get(0);
        ocapi.bearerToken = 'abc123';
        ocapi.customerAddress = addresses.get(0);
        List<OCAPIData> listOcapi = new List<OCAPIData>();
        listOcapi.add(ocapi);

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPICustomerUpdateAddress.updateCustomerAddress(listOcapi);
        Test.stopTest();

        //Lookup Error Log
        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that only one OCAPIData was returned
        System.assert(responsesOcapi.size() == 1);
        OCAPIData ocapiResponse = responsesOcapi.get(0);

        //Check that no error message was returned
        System.assert(ocapiResponse.errorMsg != null);

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