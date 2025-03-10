/**
 * Created by jacob.fisher 
 * Created Date 1/9/2020.
 * Description:Test code for adding a coupon to a basket.
 */

@IsTest
private class OCAPIAddCouponToBasketTest {
    /*
   * @description: Creates custom setting needed to work with integration since it stores the Client Id needed for OCAPI calls
   */
    @TestSetup
    private static void setup(){

        //Insert basic required test data
        TestDataFactory.testDataSetup();

        //Create a Custom Setting to represent the SFCC Client Id
        SFCC_Integration_Creds__c integrationCred = TestDataFactory.generateSFCCIntegrationCred();
        insert integrationCred;

    }
    /*
     * @description: Add coupon to basket successfully and see if everything that gets returned is right
     */
    @IsTest
    public static void addCouponSuccess() {
        //Set the HTTP mock response to return a success
        Test.setMock(HttpCalloutMock.class, new OCAPIAddCouponToBasketMock(200));

        //Set Ocapi data to pass to class
        List<OCAPIData> ocapiList = new List<OCAPIData>();
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = 'abc123';
        ocapi.basketId = '123abc';
        ocapi.couponCode ='Test';
        ocapiList.add(ocapi);

        //Test callout to add coupon coupon to basket
        Test.startTest();
            List<OCAPIData> responsesOCAPI = OCAPIAddCouponToBasket.addCoupon(ocapiList);
        Test.stopTest();

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOCAPI.size() == 1);
        OCAPIData responseOcapi = responsesOCAPI.get(0);

        //Check that CouponCodeID was added to OCAPIData
        System.assert(responseOcapi.couponCodeID != '' && responseOcapi.couponCodeID != null);

        //Check that CouponCode name was added to OCAPIData
        System.assert(responseOcapi.couponCode != '' && responseOcapi.couponCode != null);

        //Check that there is no error message
        System.assert(responseOcapi.errorMsg == null);
    }

    /*
     * @description: Add coupon to basket with not all the information needed to see if the error record is created
     */
    @IsTest
    public static void addCouponError() {
        //Set the HTTP mock response to return a error
        Test.setMock(HttpCalloutMock.class, new OCAPIAddCouponToBasketMock(400));

        //Set Ocapi data to pass to class
        List<OCAPIData> ocapiList = new List<OCAPIData>();
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = 'abc123';
        ocapiList.add(ocapi);

        //Test callout to add coupon coupon to basket
        Test.startTest();
        List<OCAPIData> responsesOCAPI = OCAPIAddCouponToBasket.addCoupon(ocapiList);
        Test.stopTest();

        //Lookup Error Log
        List<Error_Handling_Log__c> errorLogs = new List<Error_Handling_Log__c>([SELECT Id, Url__c, Request_body__c,
                                                                                        Response_Body__c, Response_Code__c
                                                                                 FROM Error_Handling_Log__c]);

        //Check that only one OCAPIData was returned in the list
        System.assert(responsesOCAPI.size() == 1);
        OCAPIData responseOcapi = responsesOCAPI.get(0);

        //Check that CouponCodeID was not added to OCAPIData
        System.assert(responseOcapi.couponCodeID == null);

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