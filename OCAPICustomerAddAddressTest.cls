/**
 * Created by jacob.fisher 
 * Created Date 8/6/2020.
 * Description: Test class for OCAPICustomerAddAddress
 */

@IsTest
private class OCAPICustomerAddAddressTest {
    @TestSetup
    private static void setup() {

        //Insert basic required test data
        TestDataFactory.testDataSetup();

        //Create a Custom Setting to represent the SFCC Client Id
        SFCC_Integration_Creds__c integrationCred = TestDataFactory.generateSFCCIntegrationCred();
        insert integrationCred;

    }
    /*
        * @description: Add Customer Address Successfully
        */
    @IsTest
    public static void addCustomerAddressSuccessfully() {
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPICustomerAddAddressMock(200));

        //Create a Contact and Web Profile
        List<Contact> cons = TestDataFactory.generateContactList(1,'','');
        List<Web_Profile__c> profiles = TestDataFactory.generateWebProfiles(cons);
        List<TestDataFactory.AddressWrapper> wrapperList = TestDataFactory.generateTestAddressList(1, true, null);
        List<Web_Profile_Address__c> startingAddress = TestDataFactory.generateWPAddress(profiles,New Map<Id, TestDataFactory.AddressWrapper>{profiles[0].Id=>wrapperList[0]});

        //Set Ocapi data to pass to class
        List<OCAPIData> ocapiList = new List<OCAPIData>();
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = 'abc123';
        ocapi.profile = profiles.get(0);
        ocapi.customerAddress = startingAddress[0];
        ocapiList.add(ocapi);

        //Test callout to add order note
        Test.startTest();
        List<OCAPIData> responsesOCAPI = OCAPICustomerAddAddress.addCustomerAddress(ocapiList);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOCAPI.size() == 1);
        OCAPIData responseOcapi = responsesOCAPI.get(0);

        //Check to see if the Address was added
        System.assert(responseOcapi.customerAddress.Address_Title__c == 'Test');

        //Check that there is no error message
        System.assert(responseOcapi.errorMsg == null);
    }
    /*
       * @description: Inserting Address using wrong Commerce cloud Id
       */
    @IsTest
    public static void addCustomerAddressFail() {
        //Set the HTTP mock response to return a Error
        Test.setMock(HttpCalloutMock.class, new OCAPICustomerAddAddressMock(404));

        //Create a Contact and Web Profile and address
        List<Contact> cons = TestDataFactory.generateContactList(1,'','');
        List<Web_Profile__c> profiles = TestDataFactory.generateWebProfiles(cons);
        List<TestDataFactory.AddressWrapper> wrapperList = TestDataFactory.generateTestAddressList(1, true, null);
        List<Web_Profile_Address__c> startingAddress = TestDataFactory.generateWPAddress(profiles,New Map<Id, TestDataFactory.AddressWrapper>{profiles[0].Id=>wrapperList[0]});


        //Set Ocapi data to pass to class
        List<OCAPIData> ocapiList = new List<OCAPIData>();
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = 'abc123';
        ocapi.profile = profiles.get(0);
        ocapi.profile.Commerce_Cloud_ID__c = '111111111111';
        ocapi.customerAddress = startingAddress.get(0);
        ocapiList.add(ocapi);

        //Test callout to add order note
        Test.startTest();
        List<OCAPIData> responsesOCAPI = OCAPICustomerAddAddress.addCustomerAddress(ocapiList);
        Test.stopTest();

        //Lookup Error Log
        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                Response_Body__c, Response_Code__c
        FROM Error_Handling_Log__c]);

        //Check that only one OCAPIData was returned in the list
        System.debug(responsesOCAPI.size());
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