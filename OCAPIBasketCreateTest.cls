/**
 * @author  Susan Durand
 * @date    02/11/2020
 * @description Test class for OCAPIBasketCreate class
 */

@IsTest
public with sharing class OCAPIBasketCreateTest {

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
    * @description: Tests  the Basket Creation class when the api callout was successful
     *                  Checks that the basket id and shipment id were saved, and no error message.
    */
    @IsTest
    public static void OCAPIBasketCreateSuccess() {
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIBasketCreateMock(200));

        //Create a list of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = 'abc123';
        List<OCAPIData> listOcapi = new List<OCAPIData>();
        listOcapi.add(ocapi);

        //Test callout to generate Basket
        Test.startTest();
            List<OCAPIData> responseList = OCAPIBasketCreate.createBasket(listOcapi);
        Test.stopTest();

        //Check that only one OCAPIData record was returned
        System.assert(responseList.size() == 1);
        OCAPIData responseOcapi = responseList.get(0);

        //Check that the basket id was saved
        System.assert(responseOcapi.basketId != '' && responseOcapi.basketId != null);
        //Check that the shipment id was saved
        System.assert(responseOcapi.shipmentId != '' && responseOcapi.shipmentId != null);
        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);
    }

    /**
     * @description: Tests  the Basket Creation class when the api callout had an error
     *                  Checks that error message was saved, and error log object created.
     */
    @IsTest
    public static void OCAPIBasketCreateFail(){
        //Set the HTTP mock response to return a fail
        Test.setMock(HttpCalloutMock.class, new OCAPIBasketCreateMock(400));

        //Create a list of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = 'abc123';
        List<OCAPIData> listOcapi = new List<OCAPIData>();
        listOcapi.add(ocapi);

        //Test callout to generate Basket
        Test.startTest();
            List<OCAPIData> responseList = OCAPIBasketCreate.createBasket(listOcapi);
        Test.stopTest();

        //Check that only one OCAPIData record was returned
        System.assert(responseList.size() == 1);
        OCAPIData responseOcapi = responseList.get(0);

        //Lookup Error Log
        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c, Response_Body__c, Response_Code__c FROM Error_Handling_Log__c]);

        //Check that the basket id was saved
        System.assert(responseOcapi.basketId == '' || responseOcapi.basketId == null);
        //Check that the shipment id was saved
        System.assert(responseOcapi.shipmentId == '' || responseOcapi.shipmentId == null);
        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg != null && responseOcapi.errorMsg != '');
        //Check that only one Error log was created
        System.assert(errorLogs.size() == 1);
        Error_Handling_Log__c error = errorLogs.get(0);
        //Check that data was recorded on the Error Log
        System.assert(  error.Url__c != null &&
                error.Request_body__c == null &&
                error.Response_Body__c != null &&
                error.Response_Code__c != null);

    }
}