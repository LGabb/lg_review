/**
 * @author  Susan Durand
 * @date    05/05/2020
 * @description Test class for OCAPICustomerAddPaymentInstrument
 */

@IsTest
private class OCAPICustomerAddPaymentInstrumentTest {

    /**
    * @description: Setup method - creates the Integration Credentials needed for api calls in the Callout Handler
    */
    @TestSetup
    public static void setup(){
        //Create a Custom Setting to represent the SFCC Client Id
        SFCC_Integration_Creds__c integrationCred = TestDataFactory.generateSFCCIntegrationCred();
        insert integrationCred;
    }

    /**
    * @description: Test adding a credit card to a basket
    */
    @IsTest
    public static void OCAPICustomerAddPaymentInstrumentCC(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICustomerAddPaymentInstrumentMock(200));

        //Create a list of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.basketId = '123456abcdef';
        ocapi.bearerToken = '123abc';
        ocapi.cardType = 'Visa';
        ocapi.creditCardName = 'Jane Doe';
        ocapi.creditCardLastFour = '1111';
        ocapi.creditCardExpirationMonth = '01';
        ocapi.creditCardExpirationYear = '2021';
        Web_Profile__c wp = new Web_Profile__c(Commerce_Cloud_ID__c = 'a1b2c3');
        //wp.Commerce_Cloud_ID__c = 'a1b2c3';
        ocapi.profile = wp;
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to add payment instrument to basket
        Test.startTest();
        List<OCAPIData> responseList = OCAPICustomerAddPaymentInstrument.addCustomerPaymentInstrument(ocapiList);
        Test.stopTest();

        //Check that only one OCAPIData record was returned
        System.assert(responseList.size() == 1);
        OCAPIData responseOcapi = responseList.get(0);

        //Check that the payment instrument Id was saved
        System.assert(responseOcapi.customerPaymentInstrumentId != null && responseOcapi.customerPaymentInstrumentId != '');
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
        ocapi.cardType = 'Visa';
        ocapi.creditCardName = 'Jane Doe';
        ocapi.creditCardLastFour = '1111';
        ocapi.creditCardExpirationMonth = '01';
        ocapi.creditCardExpirationYear = '2021';
        Web_Profile__c wp = new Web_Profile__c(Commerce_Cloud_ID__c = 'a1b2c3');
        //wp.Commerce_Cloud_ID__c = 'a1b2c3';
        ocapi.profile = wp;
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to add payment instrument to basket
        Test.startTest();
        List<OCAPIData> responseList = OCAPICustomerAddPaymentInstrument.addCustomerPaymentInstrument(ocapiList);
        Test.stopTest();

        //Check that only one OCAPIData record was returned
        System.assert(responseList.size() == 1);
        OCAPIData responseOcapi = responseList.get(0);

        //Lookup Error Log
        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c, Response_Body__c, Response_Code__c FROM Error_Handling_Log__c]);

        //Check that the shipment id was not saved
        System.assert(responseOcapi.customerPaymentInstrumentId == '' || responseOcapi.customerPaymentInstrumentId == null);
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