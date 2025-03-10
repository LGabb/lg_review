/**
 * @author  Susan Durand
 * @date    08/18/2020
 * @description Test class for OCAPIAddressValidationHelper
 */

@IsTest
public with sharing class OCAPIAddressValidationHelperTest {

    @TestSetup
    public static void setup(){

        //Insert basic required test data
        TestDataFactory.testDataSetup();

    }

    @IsTest
    public static void testAvalaraAddressError(){
        String jsonResponse = '{"_v":"20.8","fault":{"arguments":{"extensionPoint":"dw.ocapi.shop.basket.billing_address.beforePUT","statusCode":"ERROR","statusMessage":"Resolution Quality: Intersection, but given address does not match validated address.","statusDetails":{"Avalara Validated Address":{"addressType":"StreetOrResidentialAddress","line1":"5081 Olympic Blvd","line2":"","line3":"","city":"Erlanger","region":"KY","country":"US","postalCode":"41018-3164","latitude":39.041547,"longitude":-84.616261}}},"type":"HookStatusException","message":"An error occurred in ExtensionPoint \'dw.ocapi.shop.basket.billing_address.beforePUT\'."}}';
        String validationMessage = '"Resolution Quality: Intersection, but given address does not match validated address."';
        String avalaraAddressesJSON = '{"region":"KY","postalCode":"41018-3164","line3":"","line2":"","line1":"5081 Olympic Blvd","country":"US","city":"Erlanger"}';

        OCAPIAddressValidationHelper.Input inputClass = new OCAPIAddressValidationHelper.Input();
        inputClass.jsonResponse = jsonResponse;
        List<OCAPIAddressValidationHelper.Input> listInputClass = new List<OCAPIAddressValidationHelper.Input>{inputClass};

        List<OCAPIAddressValidationHelper.Result> listResults = OCAPIAddressValidationHelper.tempMethod(listInputClass);

        System.assert(listResults.size() == 1,'The wrong number of results was returned');
        OCAPIAddressValidationHelper.Result r = listResults.get(0);
        System.assert(r.validationMessage == validationMessage,'The validation message returned was not as expected.');
        System.assert(System.JSON.serialize(r.avalaraAddresses) == avalaraAddressesJSON, 'The recommended address was not as expected.');
    }

}