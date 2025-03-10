/**
 * Name: Susan Durand
 * Date: 08/20/2019
 * Description: Test class for OCAPIGetShippingMethods class
 */

@IsTest
public with sharing class OCAPIGetShippingMethodsTest {

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
    public static void getShippingMethodsSuccess(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIGetShippingMethodsMock(200));

        //Create a List of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = 'abc123';
        ocapi.basketId = 'def456';
        ocapi.shipmentId = 'me';
        List<OCAPIData> listOcapi = new List<OCAPIData>{ocapi};

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPIGetShippingMethods.getShippingMethods(listOcapi);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Check that shipping methods and ids were returned
        System.assert(responseOcapi.availableShippingMethods != null && responseOcapi.availableShippingMethods.size() > 0);
        System.assert(responseOcapi.availableShippingIds != null && responseOcapi.availableShippingIds.size() > 0);
        System.assert(responseOcapi.availableShippingMethods.size() == responseOcapi.availableShippingIds.size());

        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);
    }

    /**
     * @description: Tests  the Customer Update class when the api callout had an error
     *                  Checks that error message was saved, and error log object created.
     */
    @isTest
    public static void getShippingMethodsFail(){
        //Set the HTTP mock response to return an error
        Test.setMock(HttpCalloutMock.class, new OCAPIGetShippingMethodsMock(400));

        //Create a List of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = 'abc123';
        ocapi.basketId = 'def456';
        ocapi.shipmentId = 'me';
        List<OCAPIData> listOcapi = new List<OCAPIData>{ocapi};

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPIGetShippingMethods.getShippingMethods(listOcapi);
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
        //This callout request has no Body to be saved to Error Log
        System.assert(  error.Url__c != null &&
                error.Response_Body__c != null &&
                error.Response_Code__c != null);

        //Check that no shipping information was returned
        System.assert(ocapiResponse.availableShippingMethods == null || ocapiResponse.availableShippingMethods.size() == 0);
        System.assert(ocapiResponse.availableShippingIds == null || ocapiResponse.availableShippingIds.size() == 0);
    }

}