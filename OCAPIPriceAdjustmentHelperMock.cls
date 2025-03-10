/**
 * Name: Susan Durand
 * Date: 08/20/2019
 * Description: This class is the mock data for the OCAPICustomerUpdate Api callout
 */

@IsTest
public with sharing class OCAPIPriceAdjustmentHelperMock implements HttpCalloutMock{
    protected Integer code;
    protected String status;
    protected String body;


    /**
     * @description: Constructor method to set values for either a successful or failed mock api callout
     * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
     */
    public OCAPIPriceAdjustmentHelperMock(Integer code){
        this.code = code;
        if(code==200){
            this.status = 'OK';
            this.body = '{"_v":"20.8","_type":"basket","_resource_state":"a0cba7b5924a58b52fe9da073e5e27d696744f3aa436268d76829d855f61411a","_flash":[{"_type":"flash","type":"PaymentMethodRequired","message":"No payment method ID was specified. Please provide a valid payment method ID.","path":"$.payment_instruments[0].payment_method_id"}],"adjusted_merchandize_total_tax":2.70,"adjusted_shipping_total_tax":0.90,"agent_basket":true,"basket_id":"49b45fab716702e3ff67c60fd8","billing_address":{"_type":"order_address","address1":"5081 Olympic Blvd","city":"Erlanger","company_name":"null","country_code":"US","first_name":"Chris","full_name":"Chris Eager","id":"e3bd9a40fcd11c308c568e9ee1","last_name":"Eager","postal_code":"41018-3164","state_code":"KY","c_validateAddress":true},"channel_type":"callcenter","creation_date":"2020-08-25T13:35:49.213Z","currency":"USD","customer_info":{"_type":"customer_info","customer_id":"abZJLErYjnQD5Ky4qX8mYee6cs","customer_no":"00006501","email":"chris.eager@dynamiccatholicnoemail.com"},"last_modified":"2020-08-25T13:36:15.247Z","merchandize_total_tax":2.70,"notes":{"_type":"simple_link","link":"https://staging.dynamiccatholic.com/s/dci_us/dw/shop/v20_8/baskets/49b45fab716702e3ff67c60fd8/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"},"order_total":63.60,"product_items":[{"_type":"product_item","adjusted_tax":2.70,"base_price":3.00,"bonus_product_line_item":false,"gift":false,"item_id":"7a57989dd1b3990bb55b77ff59","item_text":"Vuelve a Descubrir a Jesús","price":45.00,"price_after_item_discount":45.00,"price_after_order_discount":45.00,"product_id":"RJES-45-MM-SPA","product_name":"Vuelve a Descubrir a Jesús","quantity":15,"shipment_id":"me","shipping_item_id":"ce52f38e69cd5d1979f0c8de23","tax":2.70,"tax_basis":45.00,"tax_class_id":null,"tax_rate":0.060000000000000005},{"_type":"product_item","adjusted_tax":0.00,"base_price":0.00,"bonus_product_line_item":false,"gift":false,"item_id":"7c9d04e9c5b648bc749b6e6af0","item_text":"Rediscover Jesus","price":0.00,"price_after_item_discount":0.00,"price_after_order_discount":0.00,"product_id":"RJES-20-MM-ENG","product_name":"Rediscover Jesus","quantity":12,"shipment_id":"me","shipping_item_id":"04d8065ebf963fd242e4ff2940","tax":0.00,"tax_basis":0.00,"tax_class_id":null,"tax_rate":0.0,"c_customPrice":"0.0"}],"product_sub_total":45.00,"product_total":45.00,"shipments":[{"_type":"shipment","adjusted_merchandize_total_tax":2.70,"adjusted_shipping_total_tax":0.90,"gift":false,"merchandize_total_tax":2.70,"product_sub_total":45.00,"product_total":45.00,"shipment_id":"me","shipment_total":63.60,"shipping_address":{"_type":"order_address","address1":"5081 Olympic Blvd","city":"Erlanger","company_name":"null","country_code":"US","first_name":"Chris","full_name":"Chris Eager","id":"e3bd9a40fcd11c308c568e9ee1","last_name":"Eager","postal_code":"41018-3164","state_code":"KY","c_validateAddress":true},"shipping_method":{"_type":"shipping_method","description":"Ground shipping in the US","id":"Standard_US","name":"Standard US","price":0.00,"c_estimatedArrivalTime":"3-5","c_isVisibleInStorefront":true,"c_storePickupEnabled":false},"shipping_status":"not_shipped","shipping_total":15.00,"shipping_total_tax":0.90,"tax_total":3.60}],"shipping_items":[{"_type":"shipping_item","adjusted_tax":0.90,"base_price":27.00,"item_id":"7ad07639ebe81d2c3c28ca082c","item_text":"Shipping","price":27.00,"price_adjustments":[{"_type":"price_adjustment","applied_discount":{"_type":"discount","amount":12.00,"type":"amount"},"created_by":"chris.eager@dynamiccatholic.com","creation_date":"2020-08-25T13:36:14.847Z","custom":true,"item_text":"Ocapi Storefront Price Adjustment ProductId:RJES-20-MM-ENG","last_modified":"2020-08-25T13:36:15.247Z","manual":true,"price":-12.00,"price_adjustment_id":"b7bb3cb3a9dddd8af0bbf98360","promotion_id":"dw.manual1","reason_code":"PRICE_MATCH"}],"price_after_item_discount":15.00,"shipment_id":"me","tax":0.90,"tax_basis":15.00,"tax_class_id":null,"tax_rate":0.060000000000000005},{"_type":"shipping_item","adjusted_tax":0.00,"base_price":15.00,"item_id":"ce52f38e69cd5d1979f0c8de23","item_text":"PBP-US~Parish Book Program - US","price":15.00,"price_after_item_discount":0.00,"shipment_id":"me","tax":0.00,"tax_basis":0.00,"tax_class_id":null,"tax_rate":0.0},{"_type":"shipping_item","adjusted_tax":0.00,"base_price":12.00,"item_id":"04d8065ebf963fd242e4ff2940","item_text":"PBP-US~Parish Book Program - US","price":12.00,"price_after_item_discount":0.00,"shipment_id":"me","tax":0.00,"tax_basis":0.00,"tax_class_id":null,"tax_rate":0.0}],"shipping_total":15.00,"shipping_total_tax":0.90,"taxation":"net","tax_total":3.60,"c_ATCustomsDuty":"0","c_ATTax":"3.6","c_ATTaxDetail":"[{\\"lineitemid\\":\\"RJES-45-MM-SPA\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":45,\\"rate\\":0.06,\\"tax\\":2.7,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]},{\\"lineitemid\\":\\"me\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":0,\\"rate\\":0.06,\\"tax\\":0,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]},{\\"lineitemid\\":\\"RJES-20-MM-ENG\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":0,\\"rate\\":0.06,\\"tax\\":0,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]},{\\"lineitemid\\":\\"me\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":0,\\"rate\\":0.06,\\"tax\\":0,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]},{\\"lineitemid\\":\\"me\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":15,\\"rate\\":0.06,\\"tax\\":0.9,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]}]"}';
        }else if(code==400){
            this.status = 'Bad Request';
            this.body = '{"_v":"20.8","fault":{"arguments":{"email":"testErrorEmail"},"type":"InvalidEmailException","message":"The profile email address \'testErrorEmail\' isn\'t valid."}}';
        }
    }

    /**
     * @description: This method returns a mock api callout response
     * @param req: HttpRequest - the Http Request callout from the test code
     * @return HttpResponse - returns the mock api callout response, with values set in the constructor method
     */
    public HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setBody(this.body);
        res.setHeader('Content-Type','application/json');
        res.setStatus(this.status);
        res.setStatusCode(this.code);
        return res;
    }

}