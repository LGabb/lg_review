/**
 * @author  Susan Durand
 * @date    11/12/2019
 * @description Removes a payment instrument from a SFCC basket
*/

public with sharing class OCAPIRemovePaymentInstrumentFromBasket {

    /*
    * @description This method removes a payment instrument from a SFCC basket
    * @param List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
     */
    @InvocableMethod
    public static List<OCAPIData> removePaymentInstrument(List<OCAPIData> inputVars){

        // List OCAPIData that's being returned by the method
        List<OCAPIData> retVars = new List<OCAPIData>();

        for(OCAPIData ocapi : inputVars) {

            //HttpRequest and endpoint url
            HttpRequest req = OCAPICalloutHandler.setEndpoint('Shop', '/baskets/' + ocapi.basketId + '/payment_instruments/' + ocapi.paymentInstrumentId, ocapi.bearerToken);

            //Callout for payment token
            HttpResponse res = OCAPICalloutHandler.DELETECallout(req, null);

            if(res.getStatusCode() == 200){
                //If callout was successful, Pass back OCAPI Data
                ocapi.basketResponseJSON = res.getBody();

                //Remove the payment instrument id, since it is no longer attached to the basket
                ocapi.paymentInstrumentId = null;

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