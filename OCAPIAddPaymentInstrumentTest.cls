/**
 * @author  Susan Durand
 * @date    02/13/2020
 * @description Test class for OCAPIAddPaymentInstrument
 */

@IsTest
public with sharing class OCAPIAddPaymentInstrumentTest {

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
    * @description: Test adding a credit card to a basket
    */
    @IsTest
    public static void OCAPIAddPaymentInstrumentCreditCard(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAddPaymentInstrumentMock(200));

        //Create a list of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.basketId = '123456abcdef';
        ocapi.bearerToken = '123abc';
        ocapi.paymentMethod = 'CREDIT_CARD';
        ocapi.cardType = 'Visa';
        ocapi.totalAmount = String.valueOf(10);
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to add payment instrument to basket
        Test.startTest();
            List<OCAPIData> responseList = OCAPIAddPaymentInstrument.addPaymentInstrument(ocapiList);
        Test.stopTest();

        //Check that only one OCAPIData record was returned
        System.assert(responseList.size() == 1);
        OCAPIData responseOcapi = responseList.get(0);

        //Check that the payment instrument Id was saved
        System.assert(responseOcapi.paymentInstrumentId != null && responseOcapi.paymentInstrumentId != '');
        //Check no error was saved
        System.assert(responseOcapi.errorMsg == null);
    }

    //TODO: Update or remove this method after OCAPIAddPaymentInstrument Class is updated
    /**
    * @description: Test adding a bank transfer to a basket
    */
    @IsTest
    public static void OCAPIAddPaymentInstrumentBankTransfer(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAddPaymentInstrumentMock(200));

        //Create a list of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.basketId = '123456abcdef';
        ocapi.bearerToken = '123abc';
        ocapi.paymentMethod = 'BANK_TRANSFER';
        ocapi.totalAmount = String.valueOf(10);
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to add payment instrument to basket
        Test.startTest();
        List<OCAPIData> responseList = OCAPIAddPaymentInstrument.addPaymentInstrument(ocapiList);
        Test.stopTest();

        //Check that only one OCAPIData record was returned
        System.assert(responseList.size() == 1);
        OCAPIData responseOcapi = responseList.get(0);

        //Check that the payment instrument Id was saved
        System.assert(responseOcapi.paymentInstrumentId != null && responseOcapi.paymentInstrumentId != '');
        //Check no error was saved
        System.assert(responseOcapi.errorMsg == null);
    }

    /**
    * @description: Test when the API callout fails
    */
    @IsTest
    public static void OCAPIAddPaymentInstrumentFail(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAddPaymentInstrumentMock(400));

        //Create a list of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.basketId = '123456abcdef';
        ocapi.bearerToken = '123abc';
        ocapi.paymentMethod = 'CREDIT_CARD';
        ocapi.cardType = 'Visa';
        ocapi.totalAmount = String.valueOf(10);
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to add payment instrument to basket
        Test.startTest();
        List<OCAPIData> responseList = OCAPIAddPaymentInstrument.addPaymentInstrument(ocapiList);
        Test.stopTest();

        //Check that only one OCAPIData record was returned
        System.assert(responseList.size() == 1);
        OCAPIData responseOcapi = responseList.get(0);

        //Lookup Error Log
        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c, Response_Body__c, Response_Code__c FROM Error_Handling_Log__c]);

        //Check that the shipment id was not saved
        System.assert(responseOcapi.paymentInstrumentId == '' || responseOcapi.paymentInstrumentId == null);
        //Check that no error message was returned
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