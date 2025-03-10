/**
 * @author  Susan Durand
 * @date    10/28/2019
 * @description Test class for OCAPICustomerCreation class
 */

@IsTest
public with sharing class OCAPICustomerCreationTest {

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
     * @description: Tests  the Customer Creation class when the api callout was successful
     *                  Checks that a SFCC Customer Id was saved, and no error message.
     */
    @IsTest
    public static void OCAPICustomerCreationSuccess(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICustomerCreationMock(200));

        //Create a Contact and Web Profile
        List<Contact> cons = TestDataFactory.generateContactList(1,'','');
        List<Web_Profile__c> profiles = TestDataFactory.generateWebProfiles(cons);

        //Create a List of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.profile = profiles.get(0);
        ocapi.bearerToken = 'abc123';
        List<OCAPIData> listOcapi = new List<OCAPIData>();
        listOcapi.add(ocapi);

        //Test callout to create Customer
        Test.startTest();
            List<OCAPIData> responsesOcapi = OCAPICustomerCreation.createCustomer(listOcapi);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Check that the Commerice Cloud Id was correctly set on the Web Profile
        System.assert(responseOcapi.profile.Commerce_Cloud_ID__c == 'abFyPc4IVBHQmfPfePYk7oozvu');
        //Check that the Customer Number was correctly set on the Web Profile
        System.assert(responseOcapi.profile.Customer_Num__c == '00005502');
        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);
    }

    /**
     * @description: Tests  the Customer Creation class when the api callout had an error
     *                  Checks that error message was saved, and error log object created.
     */
    @isTest
    public static void OCAPICustomerCreationFail(){
        //Set the HTTP mock response to return an error
        Test.setMock(HttpCalloutMock.class, new OCAPICustomerCreationMock(400));

        //Create a Web Profile
        Web_Profile__c profile = new Web_Profile__c();
        profile.Email__c = 'rmaccorley8@wordpress.com';
        profile.First_Name__c = 'Riobard';
        profile.Last_Name__c = 'MacCorley';

        //Create a List of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.profile = profile;
        ocapi.bearerToken = 'abc123';
        List<OCAPIData> listOcapi = new List<OCAPIData>();
        listOcapi.add(ocapi);

        //Test callout to create Customer
        Test.startTest();
            List<OCAPIData> ocaliResponseList = OCAPICustomerCreation.createCustomer(listOcapi);
        Test.stopTest();

        //Lookup Error Log
        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                                                                                    Response_Body__c, Response_Code__c
                                                                                FROM Error_Handling_Log__c]);

        //Check that only one OCAPIData was returned
        System.assert(ocaliResponseList.size() == 1);
        OCAPIData ocapiResponse = ocaliResponseList.get(0);
        //Check that no Commerce Cloud Id was set on the profile
        System.assert(ocapiResponse.profile.Commerce_Cloud_ID__c == null);
        //Check that an error message was added to OCAPIData
        System.assert(ocapiResponse.errorMsg != null && ocapiResponse.errorMsg != '');
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