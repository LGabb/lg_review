/**
 * Created by jacob.fisher 
 * Created Date 12/4/2019.
 * Description: This class updates address for customers in Commerce Cloud.
 */

public with sharing class OCAPICustomerUpdateAddress {
    /*
    * @description This method updates address for customers in Commerce Cloud.
    * @param List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
    */
    @InvocableMethod
    public static List<OCAPIData> updateCustomerAddress(List<OCAPIData> inputVars){

        // List OCAPIData that's being returned by the method
        List<OCAPIData> retVars = new List<OCAPIData>();

        for(OCAPIData ocapi : inputVars){

            //HttpRequest and endpoint url
            //Added logic to handle white space in Address Title - 06/07/2023 SD
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/customers/'+ ocapi.profile.Commerce_Cloud_ID__c +'/addresses/'+ ocapi.customerAddress.Address_Title__c.replace(' ', '%20'), ocapi.bearerToken);

            String body =   '{' +
                                '"address_id": "'+ ocapi.customerAddress.Address_Title__c + '",'+
                                '"company_name":"' + ocapi.customerAddress.Company_Name__c + '",' +
                                '"address1" : "'+ ocapi.customerAddress.Address_1__c +'",'+
                                '"address2" : "'+ ocapi.customerAddress.Address_2__c +'",'+
                                '"city" : "'+ ocapi.customerAddress.City__c +'",'+
                                '"country_code" : "'+ String.valueOf(ocapi.customerAddress.Country__c) +'",'+
                                '"first_name": "'+ ocapi.customerAddress.First_Name__c +'",'+
                                '"last_name" : "'+ ocapi.customerAddress.Last_Name__c +'",'+
                                '"phone" : "'+ ocapi.customerAddress.Phone_Number__c +'",'+
                                '"postal_code" : "'+ ocapi.customerAddress.ZIP_Code__c +'",'+
                                '"preferred" :'+ ocapi.customerAddress.Default__c +','+
                                '"state_code": "'+ String.valueOf(ocapi.customerAddress.State__c) +'"'+
                            '}';

            //Call out to update address records for customers
            HttpResponse  res = OCAPICalloutHandler.PATCHRequest(req, body);
            

            if(res.getStatusCode() == 200){
                //If callout was successful updates address information to OCAPI data
                retVars.add(ocapi);
            } else{
                //If the callout failed, return the error
                String message = OCAPICalloutHandler.getErrorMessage(res.getBody());
                ocapi.errorMsg = 'Error: Code ' + res.getStatusCode() + '\nMessage: ' + message;
                retVars.add(ocapi);
            }
        }
        return retVars;
    }

}