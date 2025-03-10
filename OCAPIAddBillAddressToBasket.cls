/**
 * Created by: Susan.Durand
  * Created Date: 10/21/2019
  * Description: Attaches a new billing address to a basket.  Does not save address in SFCC.
  *              Optionally makes this address the shipping address for the basket too.
 */

public with sharing class OCAPIAddBillAddressToBasket {

    /**
    * @description: This method attaches a billing address to a SFCC basket
    * @param inputVars - List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
    */

    @InvocableMethod
    public static List<OCAPIData> addBillAddressToBasket(List<OCAPIData> inputVars){

        List<OCAPIData> retVars = new List<OCAPIData>();
        for(OCAPIData ocapi : inputVars){
            //Setting null to false - should help prevent issues in the future
            Boolean sameBillingAndShipping = (ocapi.sameBillAndShipAddress == null || !ocapi.sameBillAndShipAddress) ? false : true;

            //Create the HttpRequest and endpoint url
            String urlResource = '/baskets/' + ocapi.basketId + '/billing_address?use_as_shipping=' + sameBillingAndShipping;
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint(urlResource, ocapi.bearerToken);

            //Create the body for the HttpRequest
            String body = '{' +
                                '"c_validateAddress":' + ocapi.validateAddress + ',' +
                                '"first_name":"' + ocapi.billingAddress.First_Name__c + '",' +
                                '"last_name":"' + ocapi.billingAddress.Last_Name__c + '",' +
                                '"phone":"' + ocapi.billingAddress.Phone_Number__c + '",' +
                                '"address1":"' + ocapi.billingAddress.Address_1__c + '",' +
                                '"city":"' + ocapi.billingAddress.City__c + '",' +
                                '"state_code":"' + String.valueOf(ocapi.billingAddress.State__c) + '",' +
                                '"postal_code":"' + ocapi.billingAddress.ZIP_Code__c + '",' +
                                '"country_code":"' + String.valueOf(ocapi.billingAddress.Country__c) + '"';

            if(ocapi.billingAddress.Address_2__c != null && !ocapi.billingAddress.Address_2__c.equalsIgnoreCase('null')){
                body += ',"address2":"' + ocapi.billingAddress.Address_2__c + '"';
            }
            if(ocapi.billingAddress.Company_Name__c != null && !ocapi.billingAddress.Company_Name__c.equalsIgnoreCase('null')){
                body += ',"company_name":"' + ocapi.billingAddress.Company_Name__c + '"';
            }

            body += '}';

            //Callout to attach billing address to basket
            HttpResponse res = OCAPICalloutHandler.PUTRequest(req,body);

            if(res.getStatusCode() == 200){
                //If callout was successful, return the ocapi variables
                ocapi.basketResponseJSON = res.getBody();
                retVars.add(ocapi);
            }else{
                //If the callout failed, return the error
                String message = OCAPICalloutHandler.getErrorMessage(res.getBody());
                ocapi.errorMsg = 'Error: Code ' + res.getStatusCode() + '\nMessage: ' + message;

                //Return the full error and Hook Status Exception for Avalara Address Validaiton handling
                ocapi.isHookStatusException = OCAPICalloutHandler.checkHookStatusException(res.getBody());
                ocapi.fullErrorResponse = res.getBody();
                retVars.add(ocapi);
            }
        }
        return retVars;

    }

}