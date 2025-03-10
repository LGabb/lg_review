/**
 * @author  Chris Eager
 * @date    1/2/2020
 * @description This class is the last step in placing in order via OCAPI. It passes the payment instrument information into SFCC authorizing it and billing against it.
*/

public with sharing class OCAPIProcessPayment {
    /*
    * @description This method process the payment against an order
    * @param List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
    */
    @InvocableMethod
    public static List<OCAPIData> processOrderPayment(List<OCAPIData> inputVars){
        // List OCAPIData that's being returned by the method
        List<OCAPIData> retVars = new List<OCAPIData>();

        // TODO: this will need to handle different payment methods - and will need to integrate with CyberSource once that is set up in the sandbox
       /* for(OCAPIData ocapi : inputVars){
            // Construct request
            HttpRequest request = OCAPICalloutHandler.setShopEndpoint('/orders/' + ocapi.orderNumber + '/payment_instruments?skip_authorization=false', ocapi.bearerToken);
            String body = '{' +
                    '"amount" : '+ ocapi.opp.Amount +',' +
                    '"payment_card" : {' +
                        '"number" : "41111111111111",' +
                        '"card_type" : "Visa"' +
                    '},' +
                    '"payment_method_id" : "CREDIT_CARD"}';

            HttpResponse response = OCAPICalloutHandler.POSTCallout(request, body);

            if(response.getStatusCode() == 200){
                // If callout works then set to new order response
                ocapi.orderResponseJSON = response.getBody();

            }else{
                String message = OCAPICalloutHandler.getErrorMessage(response.getBody());
                ocapi.errorMsg = 'Error: Code ' + response.getStatusCode() + '\nMessage: ' + message;
            }
            retVars.add(ocapi);
        }*/
        return retVars;
    }
}