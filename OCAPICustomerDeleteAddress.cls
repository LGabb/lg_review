/**
 * Created by jacob.fisher 
 * Created Date 12/4/2019.
 * Description: This class deletes address for customers in Commerce Cloud.
 */

public with sharing class OCAPICustomerDeleteAddress {

    /*
    * @description This method deletes addresses for customers in Commerce Cloud.
    * @param List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
    */

    @InvocableMethod
    public static List<OCAPIData> deleteCustomerAddress(List<OCAPIData> inputVars){

        // List OCAPIData that's being returned by the method
        List<OCAPIData> retVars = new List<OCAPIData>();

        for(OCAPIData ocapi : inputVars){

            //HttpRequest and endpoint url
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/customers/'+ ocapi.profile.Commerce_Cloud_ID__c +'/addresses/'+ ocapi.customerAddress.Address_Title__c, ocapi.bearerToken);

            //Call out to delete address records for the customer
            HttpResponse   res = OCAPICalloutHandler.DELETECallout(req,null);

            if(res.getStatusCode() != 204){
                //If the callout failed, return the error
                String message = OCAPICalloutHandler.getErrorMessage(res.getBody());
                ocapi.errorMsg = 'Error: Code ' + res.getStatusCode() + '\nMessage: ' + message;
                retVars.add(ocapi);
            }
        }
        return retVars;
    }

}