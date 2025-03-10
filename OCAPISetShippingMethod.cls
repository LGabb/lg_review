/**
 * Created by: Susan Durand
  * Created Date: 10/25/2019
  * Description: Attaches a shipping method to a basket.
 */

public with sharing class OCAPISetShippingMethod {

    /*
    * @description: This method attaches a shipping method to a SFCC basket
    * @param inputVars - List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
    */

    @InvocableMethod
    public static List<OCAPIData> setShippingMethod(List<OCAPIData> inputVars){

        List<OCAPIData> retVars = new List<OCAPIData>();
        for(OCAPIData ocapi : inputVars){
            //Create the HttpRequest and endpoint url
            String urlResource = '/baskets/' + ocapi.basketId + '/shipments/' + ocapi.shipmentId;
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint(urlResource, ocapi.bearerToken);

            //Create the body for the HttpRequest
            String body =   '{' +
                                '"shipping_method":{' +
                                '"id":"' + ocapi.shippingMethodId + '"' +
                                '}' +
                            '}';

            //Callout to attach shipping method to basket
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
                retVars.add(ocapi);
            }
        }
        return retVars;
    }
}