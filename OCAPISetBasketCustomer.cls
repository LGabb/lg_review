/**
 * Name: Susan Durand
 * Date: 9/10/2019
 * Description: Connects an existing Commerce Cloud basket to an existing Commerce Cloud Customer using OCAPI
 */

global with sharing class OCAPISetBasketCustomer {

    /*
     * Description: This method connects a Customer to a Basket using OCAPI
     * Parameter flowInputs: Class of @InvocableVariables
     * Return List<String>: This will return a String to indicate if the callout was a success or hit an error
     */

    @InvocableMethod
    public static List<OCAPIData> setBasketCustomer(List<OCAPIData> inputVars){

        List<OCAPIData> retVars = new List<OCAPIData>();
        for(OCAPIData ocapi : inputVars){
            //Create the HttpRequest and endpoint url
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/baskets/' + ocapi.basketId + '/customer', ocapi.bearerToken);

            //Create the body for the HttpRequest
            String body = '{' +
                          '"customer_no":"' + ocapi.profile.Customer_Num__c + '",' +
                          '"email":"' + ocapi.profile.Email__c +
                          '"}';

            //Callout to connect the customer and basket
            HttpResponse res = OCAPICalloutHandler.PUTRequest(req, body);

            if(res.getStatusCode() == 200){
                //If callout was successful, return success message
                ocapi.basketResponseJSON = res.getBody();
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