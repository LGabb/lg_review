/**
 * Created by jacob.fisher 
 * Created Date 11/8/2019.
 * Description: This takes the basket of a customer and creates the basket into an order in SFCC. This is being feeded by the master order flow in salesforce
 */

public with sharing class OCAPIPlaceOrder {

    /*
    * @description This method creates an order from the basket using Commerce Cloud
    * @param List<OCAPIData>: List of invocable OCAPIData objects
    * @return List<OCAPIData>: List of invocable OCAPIData objects
    */
    @InvocableMethod
    public static List<OCAPIData> placeOrder(List<OCAPIData> inputVars){
        // List OCAPIData that's being returned by the method
        List<OCAPIData> retVars = new List<OCAPIData>();

        for(OCAPIData ocapi : inputVars){

            // Construct body request
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/orders',ocapi.bearerToken);
            String body = '{"basket_id" : "'+ ocapi.basketId + '"}';
            HttpResponse res = OCAPICalloutHandler.POSTCallout(req,body);

            if(res.getStatusCode() == 200){
                //If callout was successful, Pass back OCAPI Data
                ocapi.orderResponseJSON = res.getBody();
                System.debug(res.getBody());
                // Getting the order number from the order Response body
                setOrderDetails(res.getBody(), ocapi);

                retVars.add(ocapi);
            } else {
                // If the callout failed, return the error
                String message = OCAPICalloutHandler.getErrorMessage(res.getBody());
                ocapi.errorMsg = 'Error: Code ' + res.getStatusCode() + '\nMessage: ' + message;
                retVars.add(ocapi);
            }
        }
        return retVars;
    }

    /*
    * @decription This method is used to parse out the order response so that we can create the data in Salesforce CRM
    * @param orderJSON - order response from order creation
    * @param ocapiData - data passed from flows and to classes
    */
    public static void setOrderDetails(String orderJSON, OCAPIData ocapiData){
        Opportunity newOrder = new Opportunity();

        // Order attribute to object (since sometime are list)
        Map<String, Object> orderMap = (Map<String, Object>) JSON.deserializeUntyped(orderJSON);

        newOrder.Name = (String) orderMap.get('order_no');
        newOrder.Amount = (Decimal) orderMap.get('order_total');
        newOrder.Shipping_Total__c = (Decimal) orderMap.get('shipping_total');
        newOrder.Tax_Total__c = (Decimal) orderMap.get('tax_total');

        // Get list of products in basket to create Opp Line Item
        List<Object> products = (List<Object>) orderMap.get('product_items');

        // Need to get the list of Product Ids to link to correct Pricebook Entry
        Set<String> sfccProdId = new Set<String>();

        for(Object product : products){
            Map<String, Object> productObj = (Map<String, Object>) product;
            sfccProdId.add((String)productObj.get('product_id'));
            System.debug(sfccProdId.add((String)productObj.get('product_id')));
        }

        Map<String, PricebookEntry> pricebookIdToSKU = new Map<String, PricebookEntry>();
        for(PricebookEntry pbe : [SELECT Id, ProductCode FROM PricebookEntry WHERE ProductCode IN :sfccProdId]){
            pricebookIdToSKU.put(pbe.ProductCode, pbe);
        }

        List<OpportunityLineItem> oliToCreate = new List<OpportunityLineItem>();
        Integer i = 1;
        for(Object product : products){
            Map<String, Object> productObj = (Map<String, Object>) product;

            String productSku = (String) productObj.get('product_id');

            if(pricebookIdToSKU.containsKey(productSku)){
                OpportunityLineItem oli = new OpportunityLineItem();
                oli.Quantity = (Decimal) productObj.get('quantity');
                oli.Tax_Amount__c = (Decimal) productObj.get('tax');
                oli.PricebookEntryId = pricebookIdToSKU.get(productSku).Id;
                oli.SKU__c = productSku;
                oli.External_Id__c = (String) orderMap.get('order_no') + '-' + i ;
                Decimal unitPrice = ((Decimal) productObj.get('price') + oli.Tax_Amount__c)/oli.Quantity;
                oli.UnitPrice = unitPrice;
                oliToCreate.add(oli);
            }else{
                // throw error
            }
            i++;
        }
        ocapiData.opp = newOrder;
        ocapiData.lineItems = oliToCreate;
        ocapiData.orderNumber = newOrder.Name;
    }
}