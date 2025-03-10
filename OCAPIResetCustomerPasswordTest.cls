/**
 * Created by jacob.fisher 
 * Created Date 4/20/2020.
 * Description: Test Class for OCAPIResetCustomerPassword
 */

@IsTest
private class OCAPIResetCustomerPasswordTest {
    /*
   * @description: Creates custom setting needed to work with integration since it stores the Client Id needed for OCAPI calls
   */
    @TestSetup
    private static void setup() {
        //Create a Custom Setting to represent the SFCC Client Id
        SFCC_Integration_Creds__c integrationCred = TestDataFactory.generateSFCCIntegrationCred();
        insert integrationCred;

    }
    /*
     * @description: Reset Customer Password Successfully and make sure nothing is returned.
     */
    @IsTest
    public static void resetPasswordSuccess() {
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIResetCustomerPasswordMock(204));

        //Create a Contact and Web Profile
        List<Contact> cons = TestDataFactory.generateContactList(1, 'test', 'test9898789@gmail.com');
        List<Web_Profile__c> webProfile = TestDataFactory.generateWebProfiles(cons);

        //Set Ocapi data to pass to class
        List<OCAPIData> ocapiList = new List<OCAPIData>();
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = 'abc123';
        ocapi.profile = webProfile.get(0);
        ocapiList.add(ocapi);

        //Test callout to reset customer password
        Test.startTest();
        List<OCAPIData> responsesOCAPI = OCAPIResetCustomerPassword.resetCustomerPassword(ocapiList);
        Test.stopTest();

        //Check that no OCAPIData was returned in the list
        System.assert(responsesOCAPI.size() == 0);

    }
    @IsTest
    public static void resetPasswordFail(){
        Test.setMock(HttpCalloutMock.class, new OCAPIResetCustomerPasswordMock(400));

    }

}