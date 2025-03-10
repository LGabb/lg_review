/**
 * Created by jacob.fisher 
 * Created Date 8/20/2020.
 * Description:
 */

@IsTest
public with sharing class OCAPIPlaceOrderTest {
    @TestSetup
    public static void setup(){
        //Insert basic required test data
        TestDataFactory.testDataSetup();

        //Create a Custom Setting to represent the SFCC Client Id
        SFCC_Integration_Creds__c integrationCred = TestDataFactory.generateSFCCIntegrationCred();
        insert integrationCred;
    }
    @IsTest
    public static void createOrderSuccess() {
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIPlaceOrderMock(200));

        OCAPIData ocapi = new OCAPIData();
        ocapi.basketId = '1234657435465';
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to add payment instrument to basket
        Test.startTest();
        List<OCAPIData> responseList = OCAPIPlaceOrder.placeOrder(ocapiList);
        Test.stopTest();

        //Check that only one OCAPIData record was returned
        System.assert(responseList.size() == 1);
        OCAPIData responseOcapi = responseList.get(0);

        //Check no error was saved
        System.assert(responseOcapi.errorMsg == null);
    }
    @IsTest
    public static void createOrderFail(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIPlaceOrderMock(404));

        OCAPIData ocapi = new OCAPIData();
        ocapi.basketId = null;
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to add payment instrument to basket
        Test.startTest();
        List<OCAPIData> responseList = OCAPIPlaceOrder.placeOrder(ocapiList);
        Test.stopTest();

        //Check that we only got one OCAPIData returned
        System.assert(responseList.size() == 1);
        OCAPIData ocapiResponse = responseList.get(0);

        //Lookup Error Log
        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that the error was saved
        System.assert(ocapiResponse.errorMsg != null && ocapiResponse.errorMsg != '');
        //Check that the basket response was not saved
        System.assert(ocapiResponse.basketResponseJSON == null);
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