/**
 * @author  Susan Durand
 * @date    05/21/2020
 * @description Test class for OCAPIAddShipAddressToBasket
 */

@IsTest
public with sharing class OCAPIAddShipAddressToBasketTest {

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
    * @description: Test adding a shipping address to a basket
    */
    @IsTest
    public static void OCAPIAddShippingAddressToBasketTest(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAddShipAddressToBasketMock(200));

        //Create a list of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.basketId = '123456abcdef';
        ocapi.shipmentId = 'me';
        ocapi.bearerToken = '123abc';

        Web_Profile_Address__c shippingAddress = new Web_Profile_Address__c();
        shippingAddress.First_Name__c = 'John';
        shippingAddress.Last_Name__c = 'Smith';
        shippingAddress.Phone_Number__c = '1234567890';
        shippingAddress.Address_1__c = '5081 Olympic Blvd';
        shippingAddress.Address_2__c = 'Office 2';
        shippingAddress.City__c = 'Erlanger';
        shippingAddress.State__c = 'KY';
        shippingAddress.ZIP_Code__c = '41018';
        shippingAddress.Country__c = 'United States';
        ocapi.shippingAddress = shippingAddress;
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to add payment instrument to basket
        Test.startTest();
        List<OCAPIData> responseList = OCAPIAddShipAddressToBasket.addShipAddressToBasket(ocapiList);
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
    public static void OCAPIAddShippingAddressToBasketError(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAddShipAddressToBasketMock(400));

        //Create a list of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.basketId = '123456abcdef';
        ocapi.shipmentId = 'me';
        ocapi.bearerToken = '123abc';

        Web_Profile_Address__c shippingAddress = new Web_Profile_Address__c();
        shippingAddress.First_Name__c = 'John';
        shippingAddress.Last_Name__c = 'Smith';
        shippingAddress.Phone_Number__c = '1234567890';
        shippingAddress.Address_1__c = '5081 Olympic Blvd';
        shippingAddress.Address_2__c = 'Office 2';
        shippingAddress.City__c = 'Erlanger';
        shippingAddress.State__c = 'KY';
        shippingAddress.ZIP_Code__c = '41018';
        shippingAddress.Country__c = 'United States';
        ocapi.shippingAddress = shippingAddress;
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to add payment instrument to basket
        Test.startTest();
        List<OCAPIData> responseList = OCAPIAddShipAddressToBasket.addShipAddressToBasket(ocapiList);
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