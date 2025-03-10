/**
 * Created by: Susan Durand
  * Created Date: 10/21/2019
  * Description: Attaches a new shipping address to a basket.  Does not save address in SFCC.
 */

public with sharing class OCAPIAddShipAddressToBasket {

    /**
    * @description: This method attaches a shipping address to a SFCC basket
    * @param inputVars - List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
    */

    @InvocableMethod
    public static List<OCAPIData> addShipAddressToBasket(List<OCAPIData> inputVars){

        List<OCAPIData> retVars = new List<OCAPIData>();
        for(OCAPIData ocapi : inputVars){
            //Create the HttpRequest and endpoint url
            String urlResource = '/baskets/' + ocapi.basketId + '/shipments/' + ocapi.shipmentId;
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint(urlResource, ocapi.bearerToken);

            //Create the body for the HttpRequest
            String body =   '{' +
                                '"shipping_address":{' +
                                    '"c_validateAddress":' + ocapi.validateAddress + ',' +
                                    '"first_name":"' + ocapi.shippingAddress.First_Name__c + '",' +
                                    '"last_name":"' + ocapi.shippingAddress.Last_Name__c + '",' +
                                    '"phone":"' + ocapi.shippingAddress.Phone_Number__c + '",' +
                                    '"address1":"' + ocapi.shippingAddress.Address_1__c + '",' +
                                    '"city":"' + ocapi.shippingAddress.City__c + '",' +
                                    '"state_code":"' + String.valueOf(ocapi.shippingAddress.State__c) + '",' +
                                    '"postal_code":"' + ocapi.shippingAddress.ZIP_Code__c + '",' +
                                    '"country_code":"' + String.valueOf(ocapi.shippingAddress.Country__c) + '"';

            if(ocapi.shippingAddress.Address_2__c != null && !ocapi.shippingAddress.Address_2__c.equalsIgnoreCase('null')){
                body += ',"address2":"' + ocapi.shippingAddress.Address_2__c + '"';
            }
            if(ocapi.shippingAddress.Company_Name__c != null && !ocapi.shippingAddress.Company_Name__c.equalsIgnoreCase('null')){
                body += ',"company_name":"' + ocapi.shippingAddress.Company_Name__c + '"';
            }
            body += '}}';

            //Callout to attach shipping address to basket
            HttpResponse res = OCAPICalloutHandler.PATCHRequest(req,body);

            if(res.getStatusCode() == 200){
                //If callout was successful, return the ocapi variables
                ocapi.basketResponseJSON = res.getBody();
                ocapi = OCAPIPriceAdjustmentHelper.handleCompProduct(ocapi);
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