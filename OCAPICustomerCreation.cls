/**
 * Name: Susan Durand
 * Date: 9/12/2019
 * Description: Creates a Customer in Commerce Cloud using OCAPI
 */

global with sharing class OCAPICustomerCreation {

    /**
     * @description: This method creates a SFCC Customer
     * @param inputVars: List<OCAPIData> - pushed in from the flow
     * @return List<OCAPIData>: List<OCAPIData> - returns any changes to the data
     */

    @InvocableMethod
    public static List<OCAPIData> createCustomer(List<OCAPIData> inputVars) {

        List<OCAPIData> returnOCAPIData = new List<OCAPIData>();
        String taxExemptNumber = null;
        for (OCAPIData ocapi : inputVars) {
            //Create the HttpRequest and endpoint url
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/customers', ocapi.bearerToken);

            //Create the body for the HttpRequest
            if(ocapi.profile.Account__c != null){
                taxExemptNumber = ocapi.profile.Tax_Exempt_Number__c;
            }
            String body =   '{' +
                            '"customer": {' +
                                '"login":"' + ocapi.profile.Email__c + '",' +
                                '"email":"' + ocapi.profile.Email__c + '",' +
                                '"last_name":"' + ocapi.profile.Last_Name__c + '",' +
                                '"first_name":"' + ocapi.profile.First_Name__c + '",' +
                                '"phone_home":"' + ocapi.profile.Phone__c + '",' +
                                '"c_inParishGroup":' + ocapi.parishCustomerGroup +',' +
                                '"c_inBookstoreGroup":' + ocapi.bookstoreCustomerGroup +','+
                    '           "c_certificateNumber":"' + taxExemptNumber + '"' +
                                '}' +
                            '}';

            //Callout to create customer
            HttpResponse res = OCAPICalloutHandler.POSTCallout(req, body);

            if(res.getStatusCode() == 200){
                //If callout was successful, parse result and return the customer number and id
                Map<String, Object> o = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                ocapi.profile.Commerce_Cloud_ID__c = String.valueOf(o.get('customer_id'));
                ocapi.profile.Customer_Num__c = String.valueOf(o.get('customer_no'));
                ocapi.profile.Group_Parish__c = (o.containsKey('c_inParishGroup')) ? Boolean.valueOf(o.get('c_inParishGroup')) : false;
                ocapi.profile.Group_Bookstore__c = (o.containsKey('c_inBookstoreGroup')) ? Boolean.valueOf(o.get('c_inBookstoreGroup')) : false;
            }else{
                //If the callout failed, return the error
                String message = OCAPICalloutHandler.getErrorMessage(res.getBody());
                ocapi.errorMsg = 'Error: Code ' + res.getStatusCode() + '\nMessage: ' + message;
            }
            returnOCAPIData.add(ocapi);
        }

        return returnOCAPIData;

    }
}