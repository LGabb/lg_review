/**
 * Name: Susan Durand
 * Date: 08/20/2019
 * Description: Test class for OCAPICalloutHandler class
 */

@IsTest
public with sharing class OCAPICalloutHandlerTest {

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

    @IsTest
    public static void testSetAuthEndpoint(){

        Test.startTest();
        HttpRequest req = OCAPICalloutHandler.setAuthEndpoint();
        Test.stopTest();

        // Client Id gets placed on the end of every callout - so need to get it form the custom setting
        String clientId = SFCC_Integration_Creds__c.getOrgDefaults().Client_Id__c;

        //Check that endpoint and header were set
        System.assert(req.getEndpoint() == 'callout:OCAPI_Auth/oauth2/access_token?client_id=' + clientId);
        System.assert(req.getHeader('Content-Type') == 'application/x-www-form-urlencoded');
    }

    @IsTest
    public static void testSetShopEndpoint(){

        String testUrl = 'testUrl';
        String testToken = '123abc';

        Test.startTest();
        HttpRequest req = OCAPICalloutHandler.setShopEndpoint(testUrl,testToken);
        Test.stopTest();

        // Client Id gets placed on the end of every callout - so need to get it form the custom setting
        String clientId = SFCC_Integration_Creds__c.getOrgDefaults().Client_Id__c;

        //Check that the url was added to the endpoint correctly
        System.assert(req.getEndpoint() == 'callout:OCAPI_DCI_Shop' + testUrl + '?client_id=' + clientId);

        //Check that headers were set
        System.assert(req.getHeader('Authorization') == 'Bearer ' + testToken);
        System.assert(req.getHeader('Content-Type') == 'application/json');
    }

    @IsTest
    public static void testSetDatandpoint(){

        String testUrl = 'testUrl';
        String testToken = '123abc';

        Test.startTest();
        HttpRequest req = OCAPICalloutHandler.setDataEndpoint(testUrl,testToken);
        Test.stopTest();

        // Client Id gets placed on the end of every callout - so need to get it form the custom setting
        String clientId = SFCC_Integration_Creds__c.getOrgDefaults().Client_Id__c;

        //Check that the url was added to the endpoint correctly
        System.assert(req.getEndpoint() == null);

        //Check that headers were set
        System.assert(req.getHeader('Authorization') == 'Bearer ' + testToken);
        System.assert(req.getHeader('Content-Type') == 'application/json');
    }

    @IsTest
    public static void testPostCalloutSuccess(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICalloutHandlerMock(200));

        String body = 'TestBody';
        HttpRequest req = new HttpRequest();

        Test.startTest();
        HttpResponse res = OCAPICalloutHandler.POSTCallout(req, body);
        Test.stopTest();

        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that no Error log was created
        System.assert(errorLogs.size() == 0);
    }

    @IsTest
    public static void testPostCalloutFail(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICalloutHandlerMock(400));

        String body = 'TestBody';
        HttpRequest req = new HttpRequest();
        req.setEndpoint('testEndpoint');

        Test.startTest();
        HttpResponse res = OCAPICalloutHandler.POSTCallout(req, body);
        Test.stopTest();

        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that only one Error log was created
        System.assert(errorLogs.size() == 1);
        Error_Handling_Log__c error = errorLogs.get(0);
        //Check that data was recorded on the Error Log
        System.assert(  error.Url__c != null &&
                error.Request_body__c != null &&
                error.Response_Body__c != null &&
                error.Response_Code__c != null);
    }

    @IsTest
    public static void testGetCalloutSuccess(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICalloutHandlerMock(200));

        String body = 'TestBody';
        HttpRequest req = new HttpRequest();

        Test.startTest();
        HttpResponse res = OCAPICalloutHandler.GETCallout(req, body);
        Test.stopTest();

        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that no Error log was created
        System.assert(errorLogs.size() == 0);
    }

    @IsTest
    public static void testGetCalloutFail(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICalloutHandlerMock(400));

        String body = 'TestBody';
        HttpRequest req = new HttpRequest();
        req.setEndpoint('testEndpoint');

        Test.startTest();
        HttpResponse res = OCAPICalloutHandler.GETCallout(req, body);
        Test.stopTest();

        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that only one Error log was created
        System.assert(errorLogs.size() == 1);
        Error_Handling_Log__c error = errorLogs.get(0);
        //Check that data was recorded on the Error Log
        System.assert(  error.Url__c != null &&
                error.Request_body__c != null &&
                error.Response_Body__c != null &&
                error.Response_Code__c != null);
    }

    @IsTest
    public static void testPatchCalloutSuccess(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICalloutHandlerMock(200));

        String body = 'TestBody';
        HttpRequest req = new HttpRequest();

        Test.startTest();
        HttpResponse res = OCAPICalloutHandler.PATCHRequest(req, body);
        Test.stopTest();

        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that no Error log was created
        System.assert(errorLogs.size() == 0);
    }

    @IsTest
    public static void testPatchCalloutFail(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICalloutHandlerMock(400));

        String body = 'TestBody';
        HttpRequest req = new HttpRequest();
        req.setEndpoint('testEndpoint');

        Test.startTest();
        HttpResponse res = OCAPICalloutHandler.PATCHRequest(req, body);
        Test.stopTest();

        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that only one Error log was created
        System.assert(errorLogs.size() == 1);
        Error_Handling_Log__c error = errorLogs.get(0);
        //Check that data was recorded on the Error Log
        System.assert(  error.Url__c != null &&
                error.Request_body__c != null &&
                error.Response_Body__c != null &&
                error.Response_Code__c != null);
    }

    @IsTest
    public static void testPutCalloutSuccess(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICalloutHandlerMock(200));

        String body = 'TestBody';
        HttpRequest req = new HttpRequest();

        Test.startTest();
        HttpResponse res = OCAPICalloutHandler.PUTRequest(req, body);
        Test.stopTest();

        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that no Error log was created
        System.assert(errorLogs.size() == 0);
    }

    @IsTest
    public static void testPutCalloutFail(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICalloutHandlerMock(400));

        String body = 'TestBody';
        HttpRequest req = new HttpRequest();
        req.setEndpoint('testEndpoint');

        Test.startTest();
        HttpResponse res = OCAPICalloutHandler.PUTRequest(req, body);
        Test.stopTest();

        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that only one Error log was created
        System.assert(errorLogs.size() == 1);
        Error_Handling_Log__c error = errorLogs.get(0);
        //Check that data was recorded on the Error Log
        System.assert(  error.Url__c != null &&
                error.Request_body__c != null &&
                error.Response_Body__c != null &&
                error.Response_Code__c != null);
    }

    @IsTest
    public static void testDeleteCalloutSuccess(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICalloutHandlerMock(200));

        String body = 'TestBody';
        HttpRequest req = new HttpRequest();

        Test.startTest();
        HttpResponse res = OCAPICalloutHandler.DELETECallout(req, body);
        Test.stopTest();

        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that no Error log was created
        System.assert(errorLogs.size() == 0);
    }

    @IsTest
    public static void testDeleteCalloutFail(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICalloutHandlerMock(400));

        String body = 'TestBody';
        HttpRequest req = new HttpRequest();
        req.setEndpoint('testEndpoint');

        Test.startTest();
        HttpResponse res = OCAPICalloutHandler.DELETECallout(req, body);
        Test.stopTest();

        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that only one Error log was created
        System.assert(errorLogs.size() == 1);
        Error_Handling_Log__c error = errorLogs.get(0);
        //Check that data was recorded on the Error Log
        System.assert(  error.Url__c != null &&
                error.Request_body__c != null &&
                error.Response_Body__c != null &&
                error.Response_Code__c != null);
    }

    @IsTest
    public static void testGetErrorMessage(){
        String errorResBody = '{"_v":"20.8","fault":{"arguments":{"email":"testErrorEmail"},"type":"InvalidEmailException","message":"The profile email address \'testErrorEmail\' isn\'t valid."}}';

        Test.startTest();
        String errorMsg = OCAPICalloutHandler.getErrorMessage(errorResBody);
        Test.stopTest();

        System.assert(errorMsg == 'The profile email address \'testErrorEmail\' isn\'t valid.');
    }

    @IsTest
    public static void testCheckHookStatusExceptionTrue(){
        String errorMessage = '{"_v":"20.8","fault":{"arguments":{"extensionPoint":"dw.ocapi.shop.basket.billing_address.beforePUT","statusCode":"ERROR","statusMessage":"The address was found but the street number in the input address was not between the low and high range of the post office database.","statusDetails":{"Avalara Validation Message":{"summary":"The address number is out of range","details":"The address was found but the street number in the input address was not between the low and high range of the post office database.","refersTo":"Address.Line0","severity":"Error","source":"Avalara.AvaTax.Services.Address"}}},"type":"HookStatusException","message":"An error occurred in ExtensionPoint \'dw.ocapi.shop.basket.billing_address.beforePUT\'."}}';

        Test.startTest();
        Boolean hookException = OCAPICalloutHandler.checkHookStatusException(errorMessage);
        Test.stopTest();

        System.assert(hookException);
    }

    @IsTest
    public static void testCheckHookStatusExceptionFalse(){
        String errorMessage = '{"_v":"20.8","fault":{"arguments":{"email":"testErrorEmail"},"type":"InvalidEmailException","message":"The profile email address \'testErrorEmail\' isn\'t valid."}}';

        Test.startTest();
        Boolean hookException = OCAPICalloutHandler.checkHookStatusException(errorMessage);
        Test.stopTest();

        System.assert(!hookException);
    }

}