/**
 * Created by jacob.fisher 
 * Created Date 8/6/2020.
 * Description:
 */

@IsTest
private class OCAPIAddNoteToOrderTest {
    @TestSetup
    private static void setup() {

        //Insert basic required test data
        TestDataFactory.testDataSetup();

        //Create a Custom Setting to represent the SFCC Client Id
        SFCC_Integration_Creds__c integrationCred = TestDataFactory.generateSFCCIntegrationCred();
        insert integrationCred;

    }
    /*
        * @description: Add Order Note to order successfully
        */
    @IsTest
    public static void addOrderNoteSuccessfully() {
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAddNoteToOrderMock(200));

        //Set Ocapi data to pass to class
        List<OCAPIData> ocapiList = new List<OCAPIData>();
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = 'abc123';
        ocapi.orderNumber = '00008509';
        ocapi.noteSubject = 'testsubject';
        ocapi.noteText = 'testNote';

        ocapiList.add(ocapi);

        //Test callout to add order note
        Test.startTest();
        List<OCAPIData> responsesOCAPI = OCAPIAddNoteToOrder.addNoteToOrder(ocapiList);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOCAPI.size() == 1);
        OCAPIData responseOcapi = responsesOCAPI.get(0);

        //Check that there is no error message
        System.assert(responseOcapi.errorMsg == null);
    }
    /*
       * @description: Add Order Note to order successfully
       */
    @IsTest
    public static void addOrderNoteFail() {
        //Set the HTTP mock response to return a Error
        Test.setMock(HttpCalloutMock.class, new OCAPIAddNoteToOrderMock(404));

        //Set Ocapi data to pass to class
        List<OCAPIData> ocapiList = new List<OCAPIData>();
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = 'abc123';
        ocapi.orderNumber = 'aaaaaaaa';
        ocapi.noteSubject = 'testsubject';
        ocapi.noteText = 'testNote';

        ocapiList.add(ocapi);

        //Test callout to add order note
        Test.startTest();
        List<OCAPIData> responsesOCAPI = OCAPIAddNoteToOrder.addNoteToOrder(ocapiList);
        Test.stopTest();

        //Lookup Error Log
        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOCAPI.size() == 1);
        OCAPIData responseOcapi = responsesOCAPI.get(0);

        //Check that there is no error message
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