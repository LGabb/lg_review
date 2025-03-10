/**
 * @author  Susan Durand
 * @date    05/26/2020
 * @description Test class for OCAPIAddBillAddressToBasket
 */

@IsTest
public with sharing class OCAPIAddBillAddressToBasketTest {

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
    * @description: Test adding a billing address to a basket
    */
    @IsTest
    public static void OCAPIAddBillingAddressToBasketTest(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAddBillAddressToBasketMock(200));

        //Create a list of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.basketId = '123456abcdef';
        ocapi.bearerToken = '123abc';
        ocapi.sameBillAndShipAddress = true;

        Web_Profile_Address__c billingAddress = new Web_Profile_Address__c();
        billingAddress.First_Name__c = 'John';
        billingAddress.Last_Name__c = 'Smith';
        billingAddress.Phone_Number__c = '1234567890';
        billingAddress.Address_1__c = '5081 Olympic Blvd';
        billingAddress.Address_2__c = 'Office 2';
        billingAddress.City__c = 'Erlanger';
        billingAddress.State__c = 'KY';
        billingAddress.ZIP_Code__c = '41018';
        billingAddress.Country__c = 'United States';
        ocapi.billingAddress = billingAddress;
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to add payment instrument to basket
        Test.startTest();
        List<OCAPIData> responseList = OCAPIAddBillAddressToBasket.addBillAddressToBasket(ocapiList);
        Test.stopTest();

        //Check that only one OCAPIData record was returned
        System.assert(responseList.size() == 1);
        OCAPIData responseOcapi = responseList.get(0);

        //Check that the basketResponseJSON was saved
        System.assert(responseOcapi.basketResponseJSON != null && responseOcapi.basketResponseJSON != '');
        //Check no error was saved
        System.assert(responseOcapi.errorMsg == null);
    }

    /**
    * @description: Test when the API callout fails
    */
    @IsTest
    public static void OCAPIAddBillingAddressToBasketError(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAddBillAddressToBasketMock(400));

        //Create a list of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.basketId = '123456abcdef';
        ocapi.bearerToken = '123abc';
        ocapi.sameBillAndShipAddress = true;

        Web_Profile_Address__c billingAddress = new Web_Profile_Address__c();
        billingAddress.First_Name__c = 'John';
        billingAddress.Last_Name__c = 'Smith';
        billingAddress.Phone_Number__c = '1234567890';
        billingAddress.Address_1__c = '5081 Olympic Blvd';
        billingAddress.Address_2__c = 'Office 2';
        billingAddress.City__c = 'Erlanger';
        billingAddress.State__c = 'KY';
        billingAddress.ZIP_Code__c = '41018';
        billingAddress.Country__c = 'United States';
        ocapi.billingAddress = billingAddress;
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to add payment instrument to basket
        Test.startTest();
        List<OCAPIData> responseList = OCAPIAddBillAddressToBasket.addBillAddressToBasket(ocapiList);
        Test.stopTest();

        //Check that only one OCAPIData record was returned
        System.assert(responseList.size() == 1);
        OCAPIData responseOcapi = responseList.get(0);

        //Lookup Error Log
        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c, Response_Body__c, Response_Code__c FROM Error_Handling_Log__c]);

        //Check that the basketResponseJSON was not saved
        System.assert(responseOcapi.basketResponseJSON == null || responseOcapi.basketResponseJSON == '');
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