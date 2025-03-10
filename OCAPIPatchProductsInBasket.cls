/**
 * @author  chris.eager
 * @date    11/11/2019
 * @description 
*/

public with sharing class OCAPIPatchProductsInBasket {
    @InvocableMethod
    public static List<OCAPIData> processChangesToProducts(List<OCAPIData> inputVars){
        List<OCAPIData> returnVals = new List<OCAPIData>();

        for(OCAPIData ocapi : inputVars){
            if(!String.isBlank(ocapi.productsToUpdate)){

                List<Object> productUpdateList = (List<Object>) JSON.deserializeUntyped(ocapi.productsToUpdate);
                Integer i = 1;
                Integer updateCount = productUpdateList.size();
                for(Object productObj : productUpdateList){
                    Map<String, Object> product = (Map<String, Object>)productObj;

                    String sfccLineId = String.valueOf(product.get('lineId'));
                    HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/baskets/' + ocapi.basketId + '/items/' + sfccLineId, ocapi.bearerToken);

                    Integer qty = Integer.valueOf(product.get('qty'));
                    String body = '{"quantity": ' + qty + '}';

                    HttpResponse res = OCAPICalloutHandler.PATCHRequest(req, body);

                    if(res.getStatusCode() == 200){
                        if(i == updateCount){
                            ocapi.basketResponseJSON = res.getBody();
                        }
                    }
                    else{
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