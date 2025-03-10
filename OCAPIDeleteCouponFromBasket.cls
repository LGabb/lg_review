/**
 * Created by jacob.fisher 
 * Created Date 1/2/2020.
 * Description: This method deletes coupon codes for customer baskets in Commerce Cloud.
 */

public with sharing class OCAPIDeleteCouponFromBasket {

    /*
    * @description This method deletes coupon codes for customer baskets in Commerce Cloud.
    * @param List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
    */

    @InvocableMethod
    public static List<OCAPIData> deleteCoupon(List<OCAPIData> inputVars) {

        // List OCAPIData that's being returned by the method
        List<OCAPIData> retVars = new List<OCAPIData>();

        for (OCAPIData ocapi : inputVars) {

            //Create the HttpRequest and endpoint url
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/baskets/' + ocapi.basketId + '/coupons/' + ocapi.couponCodeID, ocapi.bearerToken);

            //Callout to create customer
            HttpResponse res = OCAPICalloutHandler.DELETECallout(req, null);

            system.debug(res.getBody());

            if(res.getStatusCode() == 200){
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