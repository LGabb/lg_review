/**
 * Name: Susan Durand
 * Date: 9/10/2019
 * Description: Creates a basket in Commerce Cloud using OCAPI
 */

global with sharing class OCAPIBasketCreate {

    /**
     * @description: This method creates a basket in Commerce Cloud using OCAPI
     * @param List<OCAPIData>: List of invocable OCAPIData objects
     * @return List<OCAPIData>: List of invocable OCAPIData objects
     */
    @InvocableMethod
    public static List<OCAPIData> createBasket(List<OCAPIData> inputVars) {

        //OCAPIData to be returned by the method
        List<OCAPIData> retVars = new List<OCAPIData>();

        for(OCAPIData ocapi : inputVars) {
            //Create the HttpRequest and endpoint url
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/baskets', ocapi.bearerToken);

            //Callout to create basket
            HttpResponse res = OCAPICalloutHandler.POSTCallout(req, null);

            if(res.getStatusCode() == 200){
                //If callout was successful, parse result and return the basket Id
                Map<String, Object> o = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                ocapi.basketId = String.valueOf(o.get('basket_id'));
                List<Object> shipments = (List<Object>)o.get('shipments');
                Map<String, Object> s = (Map<String,Object>)shipments.get(0);
                ocapi.shipmentId = String.valueOf(s.get('shipment_id'));
                retVars.add(ocapi);

            }else{
                //If the callout failed, return the error
                System.debug('@@@@ here in theh failure');
                try{
                    String message = OCAPICalloutHandler.getErrorMessage(res.getBody());
                    ocapi.errorMsg = 'Error: Code ' + res.getStatusCode() + '\nMessage: ' + message;
                }catch(Exception e){
                    ocapi.errorMsg = res.getBody();
                }

                retVars.add(ocapi);
            }

        }
        return retVars;
    }

}