/**
 * @author  Susan Durand
 * @date    02/11/2020
 * @description This class is the mock data for the OCAPIAddItemToBasket Api callout
 */

@IsTest
public with sharing class OCAPIAddItemToBasketTest {

    /**
    * @description Set method to create Products, Pricebook Entries, Contact, Opportunity, and Line Items
    */
    @TestSetup
    public static void setup(){

        //Insert basic required test data
        TestDataFactory.testDataSetup();

        //Create a Custom Setting to represent the SFCC Client Id
        SFCC_Integration_Creds__c integrationCred = TestDataFactory.generateSFCCIntegrationCred();
        insert integrationCred;

        //Create products
        Map<String, String> nameSKUMap = new Map<String, String>{'One-Time Donation' => DonationConstants.oneTimeGiftSku,
                                    'Recurring Donation Monthly' => DonationConstants.monthlyTACSku,
                                    'Recurring Donation Annual' => DonationConstants.annualTACSku,
                                    'Committed Gift' => DonationConstants.committedGiftSku,
                                    'Rediscover Jesus' => 'Rediscover Jesus',
                                    'Rediscover The Saints' => 'Rediscover The Saints'};
        List<Product2> products = TestDataFactory.generateProductList(nameSKUMap);
        insert products;

        //Create Pricebook Entries
        Map<Id, Product2> productId = new Map<Id, Product2>();
        Map<Id, Decimal> productMap = new Map<Id, Decimal>();
        for(Product2 prod : products){
            productMap.put(prod.Id, 10.00);
            productId.put(prod.Id, prod);
        }
        List<PricebookEntry> pricebookEntries = TestDataFactory.generatePricebookEntries(productMap);
        insert pricebookEntries;

        //Create a contact
        List<Contact> cons = TestDataFactory.generateContactList(1,'Last','test@noemail.com');
        insert cons;
        Contact con = cons.get(0);
        Map<String, String> conAccMap = new Map<String, String>{con.Id => con.AccountId};

        //Create an Opportunity
        List<Opportunity> opps = TestDataFactory.generateOpportunityList('Test',conAccMap,'Closed Won');
        insert opps;
        Opportunity opp = opps.get(0);

        //Create Line Items
        List<TestDataFactory.OLICreateWrapper> oliWrapperList = new List<TestDataFactory.OLICreateWrapper>();
        for(PricebookEntry pbe : pricebookEntries){
            TestDataFactory.OLICreateWrapper oliWrapper = new TestDataFactory.OLICreateWrapper(pbe, 1);
            oliWrapperList.add(oliWrapper);
        }
        Map<String, List<TestDataFactory.OLICreateWrapper>> oppToPBEMap = new Map<String, List<TestDataFactory.OLICreateWrapper>>{opp.Id => oliWrapperList
        };
        List<OpportunityLineItem> olis = TestDataFactory.generateOpportunityLineItemList(oppToPBEMap);
        for(OpportunityLineItem oli : olis){
            oli.SKU__c = productId.get(oli.Product2Id).ProductCode;
        }
        insert olis;

    }

    /**
    * @description Tests adding an Annual Recurring Donation and One Time Donation, as Line Item objects
    */
    @IsTest
    public static void OCAPIAddItemToBasketSuccessOli(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAddItemToBasketMock(200));

        //Get products, not including Recurring Donation Monthly so we can test adding an Annual Recurring
        List<OpportunityLineItem> olis = [SELECT SKU__c, Quantity, TotalPrice, Discount_Type__c
                                            FROM OpportunityLineItem
                                            WHERE SKU__c != 'Recurring Donation Monthly'];

        //Create a list of OCAPIData
        //Add products as Opportunity Line Item objects
        OCAPIData ocapi = new OCAPIData();
        ocapi.newLineItems = olis;
        ocapi.basketId = 'abc123BasketId';
        ocapi.bearerToken = '123456abcdef';
        ocapi.basketContainsRecurringGift = false;
        ocapi.basketContainsOneTimeGift = false;
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to the addItemToBasket method
        Test.startTest();
            List<OCAPIData> ocapiResponseList = OCAPIAddItemToBasket.addItemToBasket(ocapiList);
        Test.stopTest();

        //Check that we only got one OCAPIData returned
        System.assert(ocapiResponseList.size() == 1);
        OCAPIData ocapiResponse = ocapiResponseList.get(0);

        //Check that the One-Time Donation caused basketContainsOneTimeGift to be true
        System.assert(ocapiResponse.basketContainsOneTimeGift == true);
        //Check that the Annual Recurring Donation caused basketContainsRecurringGift to be true
        System.assert(ocapiResponse.basketContainsRecurringGift == true);
        //Check that the basket response was saved
        System.assert(ocapiResponse.basketResponseJSON != null && ocapiResponse.basketResponseJSON != '');
        //Check that no errors were saved
        System.assert(ocapiResponse.errorMsg == null);

    }

    /**
    * @description Tests adding a Monthly Recurring Donation and One Time Donation, as Line Item JSON
    */
    @IsTest
    public static void OCAPIAddItemToBasketSuccessJSON(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAddItemToBasketMock(200));

        //Get products, not including Recurring Donation Annual so we can test adding a Monthly Recurring
        List<OpportunityLineItem> olis = [SELECT SKU__c, Quantity, TotalPrice, Discount_Type__c
                                            FROM OpportunityLineItem
                                            WHERE SKU__c != 'Recurring Donation Annual'];

        //Create a list of OCAPIData
        //Add products as Line Item JSON
        OCAPIData ocapi = new OCAPIData();
        ocapi.newLineItemsJSON = JSON.serialize(olis);
        ocapi.basketId = 'abc123BasketId';
        ocapi.bearerToken = '123456abcdef';
        ocapi.basketContainsRecurringGift = false;
        ocapi.basketContainsOneTimeGift = false;
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to the addItemToBasket method
        Test.startTest();
        List<OCAPIData> ocapiResponseList = OCAPIAddItemToBasket.addItemToBasket(ocapiList);
        Test.stopTest();

        //Check that we only got one OCAPIData returned
        System.assert(ocapiResponseList.size() == 1);
        OCAPIData ocapiResponse = ocapiResponseList.get(0);

        //Check that the One-Time Donation caused basketContainsOneTimeGift to be true
        System.assert(ocapiResponse.basketContainsOneTimeGift == true);
        //Check that the Monthly Recurring Donation caused basketContainsRecurringGift to be true
        System.assert(ocapiResponse.basketContainsRecurringGift == true);
        //Check that the basket response was saved
        System.assert(ocapiResponse.basketResponseJSON != null && ocapiResponse.basketResponseJSON != '');
        //Check that no errors were saved
        System.assert(ocapiResponse.errorMsg == null);
    }

    /**
    * @description Tests adding no donations, and adding both Line Item objects and JSON, and Comp Item, and null TotalPrice
    */
    @IsTest
    public static void OCAPIAddItemToBasketSuccessNoDonation(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAddItemToBasketMock(200));

        //Do not include any donation products
        //Get products to add as Line Item objects
        List<OpportunityLineItem> olis = [SELECT SKU__c, Quantity, TotalPrice, Discount_Type__c
                                            FROM OpportunityLineItem
                                            WHERE SKU__c = 'Rediscover Jesus'];
        olis.get(0).Discount_Type__c = 'Complimentary';
        olis.get(0).TotalPrice = null;
        //Get products to add as JSON
        List<OpportunityLineItem> olisJSON = [SELECT SKU__c, Quantity, TotalPrice, Discount_Type__c
                                                FROM OpportunityLineItem
                                                WHERE SKU__c = 'Rediscover The Saints'];

        //Create a list of OCAPIData
        //Add products as Line Item JSON and Opportunity Line Item objects
        OCAPIData ocapi = new OCAPIData();
        ocapi.newLineItems = olis;
        ocapi.newLineItemsJSON = JSON.serialize(olisJSON);
        ocapi.basketId = 'abc123BasketId';
        ocapi.bearerToken = '123456abcdef';
        ocapi.basketContainsRecurringGift = false;
        ocapi.basketContainsOneTimeGift = false;
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to the addItemToBasket method
        Test.startTest();
        List<OCAPIData> ocapiResponseList = OCAPIAddItemToBasket.addItemToBasket(ocapiList);
        Test.stopTest();

        //Check that we only got one OCAPIData returned
        System.assert(ocapiResponseList.size() == 1);
        OCAPIData ocapiResponse = ocapiResponseList.get(0);

        //Check that NO One-Time Donation caused basketContainsOneTimeGift to be false
        System.assert(ocapiResponse.basketContainsOneTimeGift == false);
        //Check that NO Recurring Donation caused basketContainsRecurringGift to be false
        System.assert(ocapiResponse.basketContainsRecurringGift == false);
        //Check that the basket response was saved
        System.assert(ocapiResponse.basketResponseJSON != null && ocapiResponse.basketResponseJSON != '');
        //Check that no errors were saved
        System.assert(ocapiResponse.errorMsg == null);
    }

    /**
    * @description Tests the API callout failing
    */
    @IsTest
    public static void OCAPIAddItemToBasketFail(){
        //Set the HTTP Mock to return an error
        Test.setMock(HttpCalloutMock.class, new OCAPIAddItemToBasketMock(400));

        //Get products to add as Line Item objects
        List<OpportunityLineItem> olis = [SELECT SKU__c, Quantity, TotalPrice, Discount_Type__c
                                            FROM OpportunityLineItem];

        //Create a list of OCAPIData
        OCAPIData ocapi = new OCAPIData();
        ocapi.newLineItems = olis;
        ocapi.basketId = 'abc123BasketId';
        ocapi.bearerToken = '123456abcdef';
        ocapi.basketContainsRecurringGift = false;
        ocapi.basketContainsOneTimeGift = false;
        List<OCAPIData> ocapiList = new List<OCAPIData>{ocapi};

        //Test callout to the addItemToBasket method
        Test.startTest();
        List<OCAPIData> ocapiResponseList = OCAPIAddItemToBasket.addItemToBasket(ocapiList);
        Test.stopTest();

        //Check that we only got one OCAPIData returned
        System.assert(ocapiResponseList.size() == 1);
        OCAPIData ocapiResponse = ocapiResponseList.get(0);

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