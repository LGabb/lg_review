/**
 * Created by Jacob Fisher
 * Created Date 10/7/2019.
 * Description: This class handles the OCAPI callout to add selected products to a basket. This is being feed by selected
 *              items from the productPicker LWC embeded in the flow
 */

public with sharing class OCAPIAddItemToBasket {

    /**
    * @description Adds products to the basket for a given customer
    * @param inputVars - multiple variables being passed in from the flow in order to process the call
    * @return List<OCAPIData> - OCAPI data that houses all the needed information from adding products to the basket 
    */
    @InvocableMethod
    public static List<OCAPIData> addItemToBasket(List<OCAPIData> inputVars){
        // Make sure the values are set in the donations constants class since we need to run them
        DonationConstants.setVals();

        // List OCAPIData that's being returned by the method
        List<OCAPIData> retVars = new List<OCAPIData>();

        for(OCAPIData ocapi : inputVars){
            Boolean containsOneTimeGift = ocapi.basketContainsOneTimeGift;
            Boolean containsRecurringGift = ocapi.basketContainsRecurringGift;
            // LWC product picker creates a json string of Opp Line Items that will need to be inserted
            // Convert json to Opp Line Items to get data and to be updated later
            // Constructs body of request
            List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
            if(!String.isEmpty(ocapi.newLineItemsJSON)){
                oliList = (List<OpportunityLineItem>) JSON.deserializeStrict(ocapi.newLineItemsJSON, List<OpportunityLineItem>.class);
            }

            if(ocapi.newLineItems != null && ocapi.newLineItems.size() > 0){
                oliList.addAll(ocapi.newLineItems);
            }

            Integer i = 0;
            String jsonBody = '[';
            for(OpportunityLineItem oli : oliList){

                //Check if a One Time Gift or Recurring Gift was added from the basket
                if(oli.SKU__c == DonationConstants.OTG.sku){
                    containsOneTimeGift = true;
                }
                if(oli.SKU__c == DonationConstants.MonthlyTAC.sku || oli.SKU__c == DonationConstants.AnnualTAC.sku){
                    containsRecurringGift = true;
                }

                if(i > 0){
                    jsonBody += ', ';
                }
                //For RG or OTG we need to be able to set the price - waiting on SFCC for solution to setting price
                if(oli.TotalPrice != null){
                    jsonBody += '{' +
                            '"product_id" : "' + oli.SKU__c + '",' +
                            '"quantity" : ' + oli.Quantity + ',' +
                            '"c_customPrice" : ' + oli.TotalPrice +
                            '}';
                }else if(oli.SKU__c.startsWithIgnoreCase('PIL-')){

                    //The Commerce Cloud registration id is the base of the pilgrimage SKU, without the 3 digit insurance code on the end
                    String regSKU = oli.SKU__c.substring(0,oli.SKU__c.length()-4);

                    //Set the insurance type using the last 3 digits from the SKU
                    String insuranceType = '';
                    if(oli.SKU__c.substring(oli.SKU__c.length()-3) == 'TIN'){
                        insuranceType = 'none';
                    }else if(oli.SKU__c.substring(oli.SKU__c.length()-3) == 'TIB'){
                        insuranceType = 'basic';
                    }else{
                        insuranceType = 'premium';
                    }

                    //Add the pilgrimage registration with an insurance option
                    jsonBody += '{' +
                                    '"product_id" : "' + regSKU + '",' +
                                    '"quantity" : ' + oli.Quantity + ',' +
                                    '"option_items" : [{' +
                                        '"option_id" : "pilgrimageService",' +
                                        '"option_value_id":"' + insuranceType + '"' +
                                    '}]' +
                                '}';



                }else{
                    jsonBody += '{"product_id" : "' + oli.SKU__c + '", "quantity" : ' + oli.Quantity + '}';
                }

                i++;
            }

            jsonBody += ']';

            // Construct POST of products selected to basket
            HttpRequest req = OCAPICalloutHandler.setShopEndpoint('/baskets/' + ocapi.basketId + '/items', ocapi.bearerToken);

            HttpResponse res = OCAPICalloutHandler.POSTCallout(req, jsonBody);
            System.debug(res.getBody());
            if(res.getStatusCode() == 200){
                //Update boolean variable if a One Time Gift or Recurring Gift was added from the basket
                ocapi.basketContainsOneTimeGift = containsOneTimeGift;
                ocapi.basketContainsRecurringGift = containsRecurringGift;

                ocapi.basketResponseJSON = res.getBody();

                JSONParse parsedBasket = new JSONParse(res.getBody());
                JSONParse shippingItems = parsedBasket.get('shipping_items');

                if(shippingItems.get('[0].shipment_id').getStringValue() == 'me' &&
                        shippingItems.get('[0].price').getStringValue() != null){
                    ocapi = OCAPIPriceAdjustmentHelper.handleCompProduct(ocapi);
                }
                retVars.add(ocapi);

            } else{
                String message = OCAPICalloutHandler.getErrorMessage(res.getBody());
                ocapi.errorMsg = 'Error: Code ' + res.getStatusCode() +'\nMessage: '+  message;
                retVars.add(ocapi);
            }
        }

        return retVars;
    }
}