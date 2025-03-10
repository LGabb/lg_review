/**
 * Created by: Susan Durand
  * Created Date: 10/25/2019
  * Description: Gets shipping methods and pricing that can be applied to a basket
 */

public with sharing class OCAPIGetShippingMethods {

    /*
    * @description: This method to get available shipping methods and pricing for a basket
    * @param inputVars - List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
    */

    @InvocableMethod
    public static List<OCAPIData> getShippingMethods(List<OCAPIData> inputVars){

        List<OCAPIData> retVars = new List<OCAPIData>();
        for(OCAPIData ocapi : inputVars){
            //Create the HttpRequest and endpoint url
            String urlResource = '/baskets/' + ocapi.basketId + '/shipments/' + ocapi.shipmentId + '/shipping_methods';
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint(urlResource, ocapi.bearerToken);

            //Callout to get shipping methods
            HttpResponse res = OCAPICalloutHandler.GETCallout(req,null);

            if(res.getStatusCode() == 200){
                //If callout was successful, return the shipping methods and pricing as a formatted string
                Map<String, String> shippingIdToMethod = formatShippingMethods(res.getBody());
                ocapi.availableShippingMethods = shippingIdToMethod.values();
                List<String> shippingIds = new List<String>(shippingIdToMethod.keySet());
                ocapi.availableShippingIds = shippingIds;
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

    /*
    * @description: This method formats shipping methods and pricing to be displayed in the flow
    * @param shippingMethodJSON - String: JSON list of shipping methods
    * @return String: Shipping methods and pricing formatted to be displayed in OCAPI flow
    */
    public static Map<String, String> formatShippingMethods(String shippingMethodJSON){
        //Initialize string to be returned
        Map<String, String> results = new Map<String, String>();

        //Deserialize shipping method JSON so we can get to the shipping methods
        Map<String, Object> o = (Map<String, Object>)JSON.deserializeUntyped(shippingMethodJSON);
        List<Object> shippingMethods = (List<Object>)o.get('applicable_shipping_methods');

        //Get shipping method name a price for each shipping method method
        for(Object shippingMethod : shippingMethods){
            Map<String, Object> ship = (Map<String, Object>)shippingMethod;
            //Add shipping method and pricing to string to be returned
            results.put((String)ship.get('id'),ship.get('name') + '\n');
        }
        return results;
    }
}