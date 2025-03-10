/**
 * Name: Susan Durand
 * Date: 08/20/2019
 * Description: Test class for OCAPIRemovePaymentInstrumentFromBasket class
 */

@IsTest
public with sharing class OCAPIRemovePaymentInstrumentTest {

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
     * @description: Tests removing a payment instrument from a basket when the api callout was successful
     *                  Checks that the basket was saved, payment id set to null, and no error message.
     */
    @IsTest
    public static void removePaymentInstrumentSuccess(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIRemovePaymentInstrumentMock(200));

        //Create a List of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = 'abc123';
        ocapi.basketId = 'def456';
        ocapi.paymentInstrumentId = 'ghi789';
        List<OCAPIData> listOcapi = new List<OCAPIData>{ocapi};

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPIRemovePaymentInstrumentFromBasket.removePaymentInstrument(listOcapi);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Check that basket was saved
        System.assert(responseOcapi.basketResponseJSON != null && responseOcapi.basketResponseJSON != '');

        //Check that the payment instrument id was set to null
        System.assert(responseOcapi.paymentInstrumentId == null);

        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);
    }

    /**
     * @description: Tests removing a payment instrument from a basket when the api callout had an error
     *                  Checks that error message was saved, and error log object created.
     */
    @isTest
    public static void removePaymentInstrumentFail(){
        //Set the HTTP mock response to return an error
        Test.setMock(HttpCalloutMock.class, new OCAPIRemovePaymentInstrumentMock(400));

        //Create a List of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = 'abc123';
        ocapi.basketId = 'def456';
        ocapi.paymentInstrumentId = 'ghi789';
        List<OCAPIData> listOcapi = new List<OCAPIData>{ocapi};

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPIRemovePaymentInstrumentFromBasket.removePaymentInstrument(listOcapi);
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
                error.Response_Body__c != null &&
                error.Response_Code__c != null);
    }

}