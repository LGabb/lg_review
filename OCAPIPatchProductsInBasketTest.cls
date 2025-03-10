/**
 * Name: Susan Durand
 * Date: 08/20/2019
 * Description: Test class for OCAPIPatchProductsInBasket class
 */

@IsTest
public with sharing class OCAPIPatchProductsInBasketTest {

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
     * @description: Tests updating the quantity of a product in the basket when the api callout was successful
     *                  Checks that the basket info was saved, and no error message.
     */
    @IsTest
    public static void patchProductsInBasketSuccess(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIPatchProductsInBasketMock(200));

        //Set up JSON of products to update in basket
        //Cannot do more than 100, or will hit API callout limit
        OCAPIData ocapi = new OCAPIData();
        ocapi.productsToUpdate = '[';
        for(Integer i = 0; i < 100; i++){
            if(i > 0){
                ocapi.productsToUpdate += ',';
            }
            ocapi.productsToUpdate += '{"lineId":"' + i + '","qty":"' + i + '"}';
        }
        ocapi.productsToUpdate += ']';

        //Create a List of OCAPIData
        ocapi.bearerToken = 'abc123';
        ocapi.parishCustomerGroup = true;
        List<OCAPIData> listOcapi = new List<OCAPIData>{ocapi};

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPIPatchProductsInBasket.processChangesToProducts(listOcapi);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Check that basket json was saved
        System.assert(responseOcapi.basketResponseJSON != null && responseOcapi.basketResponseJSON != '');

        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);
    }

    /**
     * @description: Tests updating the quantity of a product in the basket when the api callout had an error
     *                  Checks that error message was saved, and error log object created.
     */
    @isTest
    public static void patchProductsInBasketFail(){
        //Set the HTTP mock response to return an error
        Test.setMock(HttpCalloutMock.class, new OCAPIPatchProductsInBasketMock(400));

        //Set up JSON of products to update in basket
        OCAPIData ocapi = new OCAPIData();
        ocapi.productsToUpdate = '[{"lineId":"ab06584599ab5932bc15506fe3","qty":"10"},{"lineId":"188999d7437eb3c19719ae01d3","qty":"10"}]';

        //Create a List of OCAPIData
        ocapi.bearerToken = 'abc123';
        ocapi.parishCustomerGroup = true;
        List<OCAPIData> listOcapi = new List<OCAPIData>{ocapi};

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPIPatchProductsInBasket.processChangesToProducts(listOcapi);
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