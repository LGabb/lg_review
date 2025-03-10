/**
 * Created By: Susan Durand
 * Created Date: 12/16/2019
 * Description: Adds a note to a SFCC basket, which can be sent to shipping.
 */

public with sharing class OCAPIAddNoteToOrder {

    /**
    * @description This method adds a note to an order
    * @param List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
    */

    @InvocableMethod
    public static List<OCAPIData> addNoteToOrder(List<OCAPIData> inputVars){

        //List OCAPIData that is being returned by the method
        List<OCAPIData> retVars = new List<OCAPIData>();

        for(OCAPIData ocapi : inputVars){
            //Create the HttpRequest and endpoint url
            String urlResource = '/orders/' + ocapi.orderNumber + '/notes';
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint(urlResource, ocapi.bearerToken);

            //Create the body for the HttpRequest
            String body =   '{' +
                                '"subject":"' + ocapi.noteSubject + '",' +
                                '"text":"' + ocapi.noteText + '"' +
                            '}';

            //Callout to attach a note to the basket
            HttpResponse res = OCAPICalloutHandler.POSTCallout(req,body);

            if(res.getStatusCode() == 200){
                //If callout was successful, return the ocapi variables
                ocapi.basketResponseJSON = res.getBody();
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