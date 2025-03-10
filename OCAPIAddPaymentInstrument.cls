/**
 * @author  Jacob.fisher
 * @date    10/1/2019
 * @description Process credit Card payments with Commerce Cloud.
*/

public with sharing class OCAPIAddPaymentInstrument {

    /*
    * @description This method process credit card numbers using Commerce Cloud
    * @param List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
     */
    @InvocableMethod
    public static List<OCAPIData> addPaymentInstrument(List<OCAPIData> inputVars){

       // List OCAPIData that's being returned by the method
        List<OCAPIData> retVars = new List<OCAPIData>();

        for(OCAPIData ocapi : inputVars) {

            //HttpRequest and endpoint url
            HttpRequest req = OCAPICalloutHandler.setEndpoint('Shop', '/baskets/' + ocapi.basketId + '/payment_instruments', ocapi.bearerToken);

            String body = '';
            if(ocapi.paymentMethod == 'CREDIT_CARD'){
                body  = '{' +
                            '"payment_card":{' +
                                '"credit_card_token" : "' + ocapi.paymentToken + '",' +
                                '"expiration_month" :' + ocapi.creditCardExpirationMonth + ',' +
                                '"expiration_year" :' + ocapi.creditCardExpirationYear + ',' +
                                '"card_type" : "'+ ocapi.cardType + '",' +
                                '"holder" : "' + ocapi.creditCardName + '",' +
                                '"number" : "' + ocapi.creditCardLastFour + '"' +
                            '},' +
                            '"payment_method_id":"' + ocapi.paymentMethod + '"';
            }else{
                body  = '{' +
                        '"payment_method_id":"' + ocapi.paymentMethod + '"';
            }
            if(ocapi.customerPaymentInstrumentId != null){
                body += ',"customer_payment_instrument_id":"' + ocapi.customerPaymentInstrumentId + '"';
            }
            body += '}';

            //Callout for payment token
            HttpResponse res = OCAPICalloutHandler.POSTCallout(req, body);

            if(res.getStatusCode() == 200){
                //If callout was successful, Pass back OCAPI Data
                ocapi.basketResponseJSON = res.getBody();

                //Return the payment instrument id
                Map<String, Object> basket = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> paymentInstrument = (List<Object>)basket.get('payment_instruments');
                Map<String, Object> paymentInstrumentMap = (Map<String, Object>)paymentInstrument.get(0);
                ocapi.paymentInstrumentId = (String)paymentInstrumentMap.get('payment_instrument_id');

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