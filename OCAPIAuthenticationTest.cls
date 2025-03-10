/**
 * Created by jacob.fisher 
 * Created Date 12/11/2019.
 * Description: Test class for OCAPIAuthentication
 */

@IsTest
private class OCAPIAuthenticationTest {
    /*
     * @description: Creates custom setting needed to work with integration since it stores the Client Id needed for OCAPI calls
     */
    @TestSetup
    private static void setup(){

        //Insert basic required test data
        TestDataFactory.testDataSetup();

        // Add client Id so call can be made for bearer token
        SFCC_Integration_Creds__c integrationCred = new SFCC_Integration_Creds__c();
        integrationCred.Client_Id__c = 'abc123';
        insert integrationCred;
    }

    /*
     * @description: This will test the Authentication Process to see if it returns an Bearer Token
     */

    @IsTest
    public static void successBearerToken(){
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAuthenticationMock(200));

        //Test callout to get Bearer token
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPIAuthentication.processBearerToken();
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Checks to see if bearerToken gets added to OCAPI Data
        System.assert(responseOcapi.bearerToken != null);

        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);

    }

    /*
     * @description: This will test the Authentication Process to see if Error happens that it will stamp the Error message.
     */

    @IsTest
    public static void failBearerToken(){
        //Set the HTTP mock response to return a failed
        Test.setMock(HttpCalloutMock.class, new OCAPIAuthenticationMock(400));

        //Test callout to get Bearer token
        Test.startTest();
        List<OCAPIData> responsesOcapi = OCAPIAuthentication.processBearerToken();
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Checks to see if bearerToken gets added to OCAPI Data
        System.assert(responseOcapi.bearerToken == null);

        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg != null);
    }
/*
    //@description: No custom setting for user - new custom setting created with bearer token and expiration

    @IsTest
    public static void testCustomSetting() {
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAuthenticationMock(200));

        //Test callout to get Bearer token and create customSetting for bearer token
        Test.startTest();
            List<OCAPIData> responsesOcapi = OCAPIAuthentication.processBearerToken();
        Test.stopTest();

        // Check to see if customSetting for bearer token gets created.
        OCAPI_Bearer_Token__c csBearerToken = OCAPI_Bearer_Token__c.getInstance();
        System.assert(csBearerToken != null && csBearerToken.Bearer_Token__c != null);

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Checks to see if bearerToken gets added to OCAPI Data
        System.assert(responseOcapi.bearerToken != null);

        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);

    }


    //description: User has custom setting and bearer token expired - custom setting updated with new bearer token returned and with expiration date

    @IsTest
    public static void testBearerTokenExpired() {
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAuthenticationMock(200));

        //Create Bearer token customSetting with Expiration date and Token
        OCAPI_Bearer_Token__c customSetting = new OCAPI_Bearer_Token__c();
        customSetting.Bearer_Token__c = 'aaaaaaaa';
        customSetting.Token_Expiration__c = Datetime.now().addMinutes(-5);
        insert customSetting;

        //Test callout to get Bearer token and create customSetting for bearer token
        Test.startTest();
            List<OCAPIData> responsesOcapi = OCAPIAuthentication.processBearerToken();
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOcapi.size() == 1);
        OCAPIData responseOcapi = responsesOcapi.get(0);

        //Check to see if the Token Expiration got updated on the custom setting for the bearer token.
        OCAPI_Bearer_Token__c csBearerToken = OCAPI_Bearer_Token__c.getInstance();
        System.assert(csBearerToken.Token_Expiration__c >= Datetime.now().addMinutes(20));

        //Check to see if the bearer token was updated to the new bearer token.
        System.assert(responseOcapi.bearerToken != 'aaaaaaaa');

        //Check that no error message was returned
        System.assert(responseOcapi.errorMsg == null);

    }


    //@description: Failed response - code handles failure as expected

    @IsTest
    public static void testFailedResponse() {
        //Set the HTTP mock response to return a failed
        Test.setMock(HttpCalloutMock.class, new OCAPIAuthenticationMock(400));

        //Create Bearer token customSetting with Expiration date and Token
        OCAPI_Bearer_Token__c customSetting = new OCAPI_Bearer_Token__c();
        customSetting.Bearer_Token__c = 'aaaaaaaa';
        customSetting.Token_Expiration__c = Datetime.now();
        insert customSetting;

        //Test callout to get Bearer token and create customSetting for bearer token
        Test.startTest();
            List<OCAPIData> responsesOcapi = OCAPIAuthentication.processBearerToken();
        Test.stopTest();

        //Lookup Error Log
        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c, Response_Body__c, Response_Code__c FROM Error_Handling_Log__c]);

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

 */

}