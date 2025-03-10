/**
 * Created by jacob.fisher 
 * Created Date 4/17/2020.
 * Description: Reset Customer Password for Commerce Cloud
 */

public with sharing class OCAPIResetCustomerPassword {

    /*
     * @description: Reset Customer Password for Commerce Cloud.
     * @param inputVars: List<OCAPIData> - pushed in from the flow
     */

    @InvocableMethod
    public static List<OCAPIData> resetCustomerPassword(List<OCAPIData> inputVars){

        List<OCAPIData> returnOcapiData = new List<OCAPIData>();
        for (OCAPIData ocapi : inputVars){
            //Create HttpRequest and Endpoint url
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/customers/password_reset', ocapi.bearerToken);

            //Create the body for the HttpRequest
            String body = '{'+
                            '"identification": "' + ocapi.profile.Email__c +'",'+
                            '"type":"email"'+
                           '}';

            //Callout to reset Password
            HttpResponse res = OCAPICalloutHandler.POSTCallout(req,body);
            
            if(res.getStatusCode() != 204){
                //If the callout failed, return the error
                String message = OCAPICalloutHandler.getErrorMessage(res.getBody());
                ocapi.errorMsg = 'Error: Code ' + res.getStatusCode() + '\nMessage: ' + message;
                returnOcapiData.add(ocapi);
            }
        }

        return returnOCAPIData;
    }
}