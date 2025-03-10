/**
 * Name: Susan Durand
 * Date: 11/08/2019
 * Description: Updates a Customer in Commerce Cloud using OCAPI
 */

global with sharing class OCAPICustomerUpdate {

    /*
     * @description: This method updates a SFCC Customer
     * @param inputVars: List<OCAPIData> - pushed in from the flow
     * @return List<OCAPIData>: List<OCAPIData> - returns any changes to the data
     */

    @InvocableMethod
    public static List<OCAPIData> updateCustomer(List<OCAPIData> inputVars) {

        List<OCAPIData> returnOCAPIData = new List<OCAPIData>();
        String taxExemptNumber = null;
        for (OCAPIData ocapi : inputVars) {
            //Create the HttpRequest and endpoint url
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/customers/' + ocapi.profile.Commerce_Cloud_ID__c, ocapi.bearerToken);

            //Create the body for the HttpRequest
            //TODO add null check - if we allow one field to be updated without inputting all of them
            if(ocapi.profile.Account__c != null){
                taxExemptNumber = ocapi.profile.Tax_Exempt_Number__c;
            }
            String body =   '{' +
                                '"email":"' + ocapi.profile.Email__c + '",' +
                                '"last_name":"' + ocapi.profile.Last_Name__c + '",' +
                                '"first_name":"' + ocapi.profile.First_Name__c + '",' +
                                '"phone_home":"' + ocapi.profile.Phone__c + '",' +
                                '"c_inParishGroup":' + ocapi.parishCustomerGroup +',' +
                                '"c_inBookstoreGroup":' + ocapi.bookstoreCustomerGroup +','+
                                '"c_inOrganizationGroup":' + ocapi.profile.Group_Organization__c +','+
                                '"c_certificateNumber":"' + taxExemptNumber + '"' +
                            '}';

            //Callout to create customer
            HttpResponse res = OCAPICalloutHandler.PATCHRequest(req, body);

            if(res.getStatusCode() == 200){
                //If callout was successful, parse result and return the customer info
                System.debug(res.getBody());
                Map<String, Object> o = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                ocapi.profile.Commerce_Cloud_ID__c = String.valueOf(o.get('customer_id'));
                ocapi.profile.Customer_Num__c = String.valueOf(o.get('customer_no'));
                ocapi.profile.Email__c = String.valueOf(o.get('email'));
                ocapi.profile.Last_Name__c = String.valueOf(o.get('last_name'));
                ocapi.profile.First_Name__c = String.valueOf(o.get('first_name'));
                ocapi.profile.Phone__c = String.valueOf(o.get('phone_home'));
                ocapi.profile.Group_Parish__c = (o.containsKey('c_inParishGroup')) ? Boolean.valueOf(o.get('c_inParishGroup')) : false;
                ocapi.profile.Group_Bookstore__c = (o.containsKey('c_inBookstoreGroup')) ? Boolean.valueOf(o.get('c_inBookstoreGroup')) : false;
                ocapi.profile.Group_Organization__c = (o.containsKey('c_inOrganizationGroup')) ? Boolean.valueOf(o.get('c_inOrganizationGroup')) : false;
            }else{
                //If the callout failed, return the error
                System.debug(res.getBody());
                String message = OCAPICalloutHandler.getErrorMessage(res.getBody());
                ocapi.errorMsg = 'Error: Code ' + res.getStatusCode() + '\nMessage: ' + message;
            }
            returnOCAPIData.add(ocapi);
        }

        return returnOCAPIData;

    }
}