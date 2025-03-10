/**
 * Created By Susan Durand
 * Date: 05/05/2020
 * Description: Saves a payment instrument to the customer record in SFCC
 */

public with sharing class OCAPICustomerAddPaymentInstrument {

    @InvocableMethod
    public static List<OCAPIData> addCustomerPaymentInstrument(List<OCAPIData> inputVars){

        //List<OCAPIData> that is being returned by the method
        List<OCAPIData> retVars = new List<OCAPIData>();

        for(OCAPIData ocapi : inputVars){

            //HttpRequest and endpoint url
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/customers/' + ocapi.profile.Commerce_Cloud_ID__c + '/payment_instruments', ocapi.bearerToken);

            String body =   '{' +
                                '"payment_card" : {' +
                                    '"credit_card_token":"' + ocapi.paymentToken + '",'+
                                    '"card_type":"'+ ocapi.cardType + '",' +
                                    '"expiration_month":' + ocapi.creditCardExpirationMonth + ',' +
                                    '"expiration_year":' + ocapi.creditCardExpirationYear + ',' +
                                    '"holder":"' + ocapi.creditCardName + '",' +
                                    '"number":"' + ocapi.creditCardLastFour + '"' +
                                '}' +
                            '}';

            HttpResponse res = OCAPICalloutHandler.POSTCallout(req, body);

            if(res.getStatusCode() == 200){
                //If callout was successful, add payment instrument id to OCAPI data
                JSONParse pymtInstrument = new JSONParse(res.getBody());
                ocapi.customerPaymentInstrumentId = pymtInstrument.get('payment_instrument_id').toStringPretty().remove('"');
                retVars.add(ocapi);
                System.debug(res.getBody());
            }else{
                //If the callout failed, return the error
                String message = OCAPICalloutHandler.getErrorMessage(res.getBody());
                ocapi.errorMsg = 'Error: Code ' + res.getStatusCode() + '\nMessage: ' + message;
                retVars.add(ocapi);
                System.debug(res.getBody());
            }
        }

        return retVars;

    }

}