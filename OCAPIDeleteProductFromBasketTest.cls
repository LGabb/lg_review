/**
 * Name: Susan Durand
 * Date: 08/20/2019
 * Description: Test class for OCAPIDeleteProductFromBasket class
 */

@IsTest
public with sharing class OCAPIDeleteProductFromBasketTest {

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
     * @description: Tests deleting a product from a basket when the api callout was successful
     *                  Checks that the basket JSON info was saved, and no error message.
     */
    @IsTest
    public static void deleteProductFromBasketSuccess(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIDeleteProductFromBasketMock(200));

        //Set up JSON of products to delete from basket
        //Cannot do more than 100, or will hit API callout limit
        OCAPIData ocapi = new OCAPIData();
        ocapi.productsToDelete = '[';
        for(Integer i = 0; i < 100; i++){
            if(i > 0){
                ocapi.productsToDelete += ',';
            }
            ocapi.productsToDelete += '{"lineId":"' + i + '","sku":"sku' + i + '"}';
        }
        ocapi.productsToDelete += ']';

        //Create a List of OCAPIData
        ocapi.bearerToken = 'abc123';
        ocapi.parishCustomerGroup = true;
        List<OCAPIData> listOcapi = new List<OCAPIData>{ocapi};

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPIDeleteProductFromBasket.deleteProductsFromBasket(listOcapi);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Make sure basketJSON was saved
        System.assert(responseOcapi.basketResponseJSON != null && responseOcapi.basketResponseJSON != '');

        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);
    }

    /**
     * @description: Tests deleting a OTG from a basket
     */
    @IsTest
    public static void testRemoveOTG(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIDeleteProductFromBasketMock(200));

        //Get OTG SKU
        String otgSKU = DonationConstants.oneTimeGiftSku;

        //Set up JSON of products to delete from basket
        OCAPIData ocapi = new OCAPIData();
        ocapi.productsToDelete = '[{"lineId":"dbf1a417739effac2255d3124a","sku":"' + otgSKU + '"}]';

        //Create a List of OCAPIData
        ocapi.bearerToken = 'abc123';
        ocapi.parishCustomerGroup = true;
        ocapi.basketContainsOneTimeGift = true;
        List<OCAPIData> listOcapi = new List<OCAPIData>{ocapi};

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPIDeleteProductFromBasket.deleteProductsFromBasket(listOcapi);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Make sure basketJSON was saved
        System.assert(responseOcapi.basketResponseJSON != null && responseOcapi.basketResponseJSON != '');

        //Make sure basket was marked as not having a OTG
        System.assert(!responseOcapi.basketContainsOneTimeGift);

        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);
    }

    /**
     * @description: Tests deleting a Monthly RD from a basket
     */
    @IsTest
    public static void testRemoveMonthlyRD(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIDeleteProductFromBasketMock(200));

        //Get Monthly RD SKU
        String montlyTACSKU = DonationConstants.monthlyTACSku;

        String otgSKU = DonationConstants.oneTimeGiftSku;

        //Set up JSON of products to delete from basket
        OCAPIData ocapi = new OCAPIData();
        ocapi.productsToDelete = '[{"lineId":"dbf1a417739effac2255d3124a","sku":"' + montlyTACSKU + '"}]';

        //Create a List of OCAPIData
        ocapi.bearerToken = 'abc123';
        ocapi.parishCustomerGroup = true;
        ocapi.basketContainsRecurringGift = true;
        List<OCAPIData> listOcapi = new List<OCAPIData>{ocapi};

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPIDeleteProductFromBasket.deleteProductsFromBasket(listOcapi);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Make sure basketJSON was saved
        System.assert(responseOcapi.basketResponseJSON != null && responseOcapi.basketResponseJSON != '');

        //Make sure basket is marked as not having a Recurring Donation
        System.assert(!responseOcapi.basketContainsRecurringGift);

        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);
    }

    /**
     * @description: Tests deleting an Annual RD from a basket
     */
    @IsTest
    public static void testRemoveAnnualRD(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIDeleteProductFromBasketMock(200));

        //Get Annual RD SKU
        String annualTACSKU = DonationConstants.annualTACSku;

        String otgSKU = DonationConstants.oneTimeGiftSku;

        //Set up JSON of products to delete from basket
        OCAPIData ocapi = new OCAPIData();
        ocapi.productsToDelete = '[{"lineId":"dbf1a417739effac2255d3124a","sku":"' + annualTACSKU + '"}]';

        //Create a List of OCAPIData
        ocapi.bearerToken = 'abc123';
        ocapi.parishCustomerGroup = true;
        ocapi.basketContainsRecurringGift = true;
        List<OCAPIData> listOcapi = new List<OCAPIData>{ocapi};

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPIDeleteProductFromBasket.deleteProductsFromBasket(listOcapi);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Make sure basketJSON was saved
        System.assert(responseOcapi.basketResponseJSON != null && responseOcapi.basketResponseJSON != '');

        //Make sure basket is marked as not having a Recurring Donation
        System.assert(!responseOcapi.basketContainsRecurringGift);

        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);
    }

    /**
     * @description: Tests deleting a product from a basket when the api callout had an error
     *                  Checks that error message was saved, and error log object created.
     */
    @isTest
    public static void deleteProductFromBasketFail(){
        //Set the HTTP mock response to return an error
        Test.setMock(HttpCalloutMock.class, new OCAPIDeleteProductFromBasketMock(400));

        //Set up JSON of products to delete from basket
        OCAPIData ocapi = new OCAPIData();
        ocapi.productsToDelete = '[{"lineId":"dbf1a417739effac2255d3124a","sku":"GTBC-06-MM-ENG"},{"lineId":"067b4a24992e928acbd054856d","sku":"13PW-88-MM-ENG"},{"lineId":"336155c10fe1d5bebfb4111308","sku":"RCAT-9-HC-ENG"},{"lineId":"c231012f147f14fdadfbf9a131","sku":"RCAT-67-MM-ENG"},{"lineId":"d3259655c54a9560c8e7287fd6","sku":"RCAT-20-MM-SPA"}]';

        //Create a List of OCAPIData
        ocapi.bearerToken = 'abc123';
        ocapi.parishCustomerGroup = true;
        List<OCAPIData> listOcapi = new List<OCAPIData>{ocapi};

        //Test callout to create Customer
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPIDeleteProductFromBasket.deleteProductsFromBasket(listOcapi);
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