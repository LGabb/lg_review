/**
 * @author  Chris Eager
 * @date    12/6/2019
 * @description This class handles Comp orders by automatically adding a price adjustment
*/

public with sharing class OCAPIPriceAdjustmentHelper {
    // This is what ship item the price adjustment should be applied to.
    public static String parentShipItemId;
    public static Set<String> compWithPriceAdjustments;

    /*
   * @description Makes a product in the basket a comp product
   * @param ocapi - wrapper of all information from flow
   * @param comProducts - set of sku for products to be converted to Comp
   * @return OCAPIData - OCAPI data that houses all the needed information from adding products to the basket
   */
    public static OCAPIData handleCompProduct(OCAPIData ocapi){
        // Loop over basket response to get full list of product sku to sfcc line basket code

        Map<String, SFCCProduct> productIdToSKUMap = getProductSkusFromBasketJSON(ocapi.basketResponseJSON);

        // loop through each comp item and add the price adjustment
        for(SFCCProduct sfccProd : productIdToSKUMap.values()){
            if(sfccProd.isComp && !compWithPriceAdjustments.contains(sfccProd.sku)){
                String body = '{ ' +
                        '"discount" : {' +
                            '"value" : '+ sfccProd.itemShipCost + ',' +
                            '"type" : "amount"' +
                        '},' +
                        '"item_text" : "Ocapi Storefront Price Adjustment ProductId:' + sfccProd.sku + '",' +
                        '"level" : "shipping",' +
                        '"item_id" : "' + parentShipItemId + '",' +
                        '"reason_code" : "PRICE_MATCH"' +
                        '}';

                // Need to do the callouts one at a time, so if there are multiple then will need to make this call in a loop
                HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/baskets/' + ocapi.basketId + '/price_adjustments', ocapi.bearerToken);
System.debug('@@@@ this is the price adjustment req');
                System.debug(req.getBody());
                HttpResponse res = OCAPICalloutHandler.POSTCallout(req, body);
System.debug('@@@@ this the response ');
                System.debug(res.getBody());
                if(res.getStatusCode() == 200){
                    ocapi.basketResponseJSON = res.getBody();
                }else{
                    String message = OCAPICalloutHandler.getErrorMessage(res.getBody());
                    ocapi.errorMsg = 'Error: Code ' + res.getStatusCode() +'\nMessage: '+  message;
                    break;
                }
            }
        }
        return ocapi;
    }

    /*
   * @description Parses data in basket in order to get line id for items to be become complimentary
   * @param basketJSON - last response JSON from the OCAPI call
   * @return Map<String, String> - Sku to basket's item id - this is to identify the the product(s) that should become comp
   */
    public static Map<String, SFCCProduct> getProductSkusFromBasketJSON(String basketJSON){
        Map<String, SFCCProduct> shipIdToProdMap = new Map<String, SFCCProduct>();

        JSONParse parsedBasket = new JSONParse(basketJSON);

        for(JSONParse prodItem : parsedBasket.get('product_items').asList()){
            SFCCProduct sfccProd = new SFCCProduct(prodItem);
            shipIdToProdMap.put(sfccProd.itemShipId, sfccProd);
        }

        compWithPriceAdjustments = new Set<String>();
        for(JSONParse shipItem : parsedBasket.get('shipping_items').asList()){
            String shipItemId = shipItem.get('item_id').getStringValue();

            if(shipIdToProdMap.containsKey(shipItemId)){
                SFCCProduct sfccProd = shipIdToProdMap.get(shipItemId);
                sfccProd.calcShipping(shipItem);
            }else{
                parentShipItemId = shipItemId;
                if(shipItem.asMap().containsKey('price_adjustments')){
                    if(shipItem.get('price_adjustments').asList().size() != compWithPriceAdjustments.size()){
                        for(JSONParse priceAdj : shipItem.get('price_adjustments').asList()){
                            String priceAdjText = priceAdj.get('item_text').getStringValue();
                            if(priceAdjText.contains('ProductId:')){
                                compWithPriceAdjustments.add(priceAdjText.split('ProductId:')[1]);
                            }
                        }
                    }
                }
            }
        }


        return shipIdToProdMap;
    }

    /**
     * @description Class that handles return response of JSON parsing
    */
    public class SFCCProduct{
        public String sku;
        public String sfccId;
        public Boolean isComp;
        public String itemShipId;
        public Decimal itemShipCost;

        public SFCCProduct(JSONParse productInfo){
            this.sku = productInfo.get('product_id').getStringValue();
            this.sfccId = productInfo.get('item_id').getStringValue();
            this.isComp = false;

            if(productInfo.asMap().containsKey('c_customPrice')){
                if(productInfo.get('c_customPrice').getStringValue() != null){
                    Double customPrice = productInfo.get('c_customPrice').getDecimalValue();
                    this.isComp = (customPrice > 0) ? false : true;
                }
            }

            this.itemShipId = null;
            if(productInfo.asMap().containsKey('shipping_item_id')){
                this.itemShipId = productInfo.get('shipping_item_id').getStringValue();
            }

        }

        public void calcShipping(JSONParse shipItemInfo){
            this.itemShipCost = shipItemInfo.get('price').getDecimalValue();
        }
    }
}