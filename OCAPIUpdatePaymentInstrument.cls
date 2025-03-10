/**
 * Created by: Susan Durand
  * Created Date: 11/11/2019
  * Description: Updates payment method attached to basket in SFCC
 */

public with sharing class OCAPIUpdatePaymentInstrument {


    /*
    * @description: This method updates payment method attached to basket in SFCC
    * @param inputVars - List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
    */

    @InvocableMethod
    public static List<OCAPIData> updatePaymentMethods(List<OCAPIData> inputVars){

        List<OCAPIData> retVars = new List<OCAPIData>();
        for(OCAPIData ocapi : inputVars){
            //Create the HttpRequest and endpoint url
            String urlResource = '/baskets/' + ocapi.basketId + '/payment_instruments/' + ocapi.paymentInstrumentId;
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint(urlResource, ocapi.bearerToken);

            System.debug(ocapi.paymentMethod);
            String body = '';
            if(ocapi.paymentMethod == 'CREDIT_CARD'){
                body  = '{' +
                            '"amount":' + ocapi.totalAmount + ',' +
                            '"payment_card":{' +
                                '"credit_card_token":"' + ocapi.paymentToken + '",'+
                                '"card_type":"'+ ocapi.cardType + '"' +
                            '},' +
                            '"payment_method_id":"' + ocapi.paymentMethod + '"' +
                        '}';
            }else if(ocapi.paymentMethod == 'BANK_TRANSFER'){
                body  = '{' +
                            '"amount":' + ocapi.totalAmount + ',' +
                            '"payment_bank_account":{' +
                                '"holder":"Susan Durand"'+
                            '},' +
                            '"payment_method_id":"' + ocapi.paymentMethod + '"' +
                        '}';
            }

            //Callout to update payment instruments
            HttpResponse res = OCAPICalloutHandler.PATCHRequest(req,body);

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