/**
 * @author  Chris Eager
 * @date    11/12/2019
 * @description This class handles deleting of products from a basket
*/

public with sharing class OCAPIDeleteProductFromBasket {
    @InvocableMethod
    public static List<OCAPIData> deleteProductsFromBasket(List<OCAPIData> inputVars){
        // Make sure the values are set in the donations constants class
        DonationConstants.setVals();

        List<OCAPIData> returnVals = new List<OCAPIData>();

        for(OCAPIData ocapi : inputVars){
            System.debug(ocapi.productsToDelete);
            if(!String.isBlank(ocapi.productsToDelete)){
                List<Object> productToDeleteList = (List<Object>) JSON.deserializeUntyped(ocapi.productsToDelete);

                Integer i = 1;
                Integer deleteCount = productToDeleteList.size();

                for(Object product : productToDeleteList){
                    Map<String, Object> productMap = (Map<String, Object>) product;

                    String sfccLineId = String.valueOf(productMap.get('lineId'));
                    HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/baskets/' + ocapi.basketId + '/items/' + sfccLineId, ocapi.bearerToken);

                    HttpResponse res = OCAPICalloutHandler.DELETECallout(req, null);
                    if(res.getStatusCode() == 200){
                        String productSKU = String.valueOf(productMap.get('sku'));
                        //Update boolean variable if a One Time Gift or Recurring Gift was removed from the basket
                        if(productSKU == DonationConstants.OTG.sku){
                            ocapi.basketContainsOneTimeGift = false;
                        }
                        if(productSKU == DonationConstants.MonthlyTAC.sku || productSKU == DonationConstants.AnnualTAC.sku){
                            ocapi.basketContainsRecurringGift = false;
                        }

                        if(i == deleteCount){
                            ocapi.basketResponseJSON = res.getBody();
                        }
                    }else{
                        String message = OCAPICalloutHandler.getErrorMessage(res.getBody());
                        ocapi.errorMsg = 'Error: Code ' + res.getStatusCode() +'\nMessage: '+  message;
                        break;
                    }
                    i++;
                }
            }
            returnVals.add(ocapi);
        }
        return returnVals;
    }
}