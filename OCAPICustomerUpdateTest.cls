/**
 * Name: Susan Durand
 * Date: 08/20/2019
 * Description: Test class for OCAPICustomerUpdate class
 */

@IsTest
public with sharing class OCAPICustomerUpdateTest {

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
     * @description: Tests  the Customer Update class when the api callout was successful
     *                  Checks that the SFCC Customer info was saved, and no error message.
     */
    @IsTest
    public static void customerUpdateSuccess(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICustomerUpdateMock(200));

        //Create a Contact and Web Profile
        List<Web_Profile__c> profiles = TestDataFactory.generateWebProfiles(1);
        Web_Profile__c wp = profiles.get(0);
        wp.Commerce_Cloud_ID__c = 'abNqrdgLmbqREiqjriq46qFWGq';
        wp.Customer_Num__c = '00005501';
        wp.First_Name__c = 'TestFirst';
        wp.Last_Name__c = 'TestLast';
        wp.Phone__c = '1111111111';
        wp.Group_Bookstore__c = false;
        wp.Group_Parish__c = true;
        insert profiles;

        //Create a List of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.profile = wp;
        ocapi.bearerToken = 'abc123';
        ocapi.parishCustomerGroup = true;
        List<OCAPIData> listOcapi = new List<OCAPIData>{ocapi};

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPICustomerUpdate.updateCustomer(listOcapi);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Make sure values from Mock are assigned correctly
        System.assert(responseOcapi.profile.Commerce_Cloud_ID__c == 'abNqrdgLmbqREiqjriq46qFWGq');
        System.assert(responseOcapi.profile.Customer_Num__c == '00005501');
        System.assert(responseOcapi.profile.Email__c == 'testsd@noemail.com');
        System.debug(responseOcapi.profile.Last_Name__c);
        System.debug(responseOcapi.profile.First_Name__c);
        System.debug(responseOcapi.profile.Phone__c);
        System.assert(responseOcapi.profile.Last_Name__c == 'TestLast');
        System.assert(responseOcapi.profile.First_Name__c == 'TestFirst');
        System.assert(responseOcapi.profile.Phone__c == '1111111111');

        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);
    }

    /**
     * @description: Tests  the Customer Update class when the api callout had an error
     *                  Checks that error message was saved, and error log object created.
     */
    @isTest
    public static void customerUpdateFail(){
        //Set the HTTP mock response to return an error
        Test.setMock(HttpCalloutMock.class, new OCAPICustomerUpdateMock(400));

        //Create a Contact and Web Profile
        List<Web_Profile__c> profiles = TestDataFactory.generateWebProfiles(1);
        Web_Profile__c wp = profiles.get(0);
        wp.Commerce_Cloud_ID__c = 'abNqrdgLmbqREiqjriq46qFWGq';
        wp.Customer_Num__c = '00005501';
        wp.First_Name__c = 'TestFirst';
        wp.Last_Name__c = 'TestLast';
        wp.Phone__c = '1111111111';
        insert profiles;

        //Create a List of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.profile = wp;
        ocapi.bearerToken = 'abc123';
        ocapi.parishCustomerGroup = true;
        List<OCAPIData> listOcapi = new List<OCAPIData>{ocapi};

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPICustomerUpdate.updateCustomer(listOcapi);
        Test.stopTest();

        //Lookup Error Log
        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                                                                                    Response_Body__c, Response_Code__c
                                                                                    FROM Error_Handling_Log__c]);

        //Check that only one OCAPIData was returned
        System.assert(responsesOcapi.size() == 1);
        OCAPIData ocapiResponse = responsesOcapi.get(0);

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