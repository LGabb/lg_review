/**
 * Created by jacob.fisher 
 * Created Date 1/2/2020.
 * Description: The method adds coupon codes to customer baskets in Commerce Cloud
 */

public with sharing class OCAPIAddCouponToBasket {

    /*
    * @description This method adds coupon codes to customer baskets in Commerce Cloud.
    * @param List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
    */


    @InvocableMethod
    public static List<OCAPIData> addCoupon(List<OCAPIData> inputVars) {

        // List OCAPIData that's being returned by the method
        List<OCAPIData> retVars = new List<OCAPIData>();

        for (OCAPIData ocapi : inputVars) {

            //Create the HttpRequest and endpoint url
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/baskets/' + ocapi.basketId + '/coupons', ocapi.bearerToken);

            //Create the body for the HttpRequest
            String body =   '{' +
                                '"code" : "' + ocapi.couponCode + '"'+
                            '}';

            //Callout to add coupon code to basket
            HttpResponse res = OCAPICalloutHandler.POSTCallout(req, body);
            System.debug('@@@Add coupon to basket: '+ res.getBody());


            if(res.getStatusCode() == 200){
                //If callout was successful, Get Coupon id just in case we need to Remove coupon from basket
                Map<String, Object> basket = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> couponItems = (List<Object>)basket.get('coupon_items');
                Map<String, Object> couponItemsMap = (Map<String, Object>)couponItems.get(0);
                ocapi.couponCodeID = (String)couponItemsMap.get('coupon_item_id');
                ocapi.basketResponseJSON = res.getBody();

            }else{
                //If the callout failed, return the error
                String message = OCAPICalloutHandler.getErrorMessage(res.getBody());
                ocapi.errorMsg = 'Error: Code ' + res.getStatusCode() + '\nMessage: ' + message;
            }
            retVars.add(ocapi);
        }

        return retVars;

    }
}