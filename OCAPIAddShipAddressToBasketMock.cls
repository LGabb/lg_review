/**
 * @author  Susan Durand
 * @date    05/21/2020
 * @description This class is the mock data for the OCAPIAddShipAddressToBasket Api callout
 */

public with sharing class OCAPIAddShipAddressToBasketMock implements HttpCalloutMock{
    protected Integer code;
    protected String status;
    protected String body;

    /**
    * @description: Constructor method to set values for either a successful or failed mock api callout
    * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
    */
    public OCAPIAddShipAddressToBasketMock(Integer code){
        this.code = code;
        if(code == 200){
            this.status = 'OK';
            this.body = '{"_v":"20.4","_type":"basket","_resource_state":"404e0835e93baf20c8b80254b72eeb4e7ce1f86d84bd5fd5d000db1631acfd6e","_flash":[{"_type":"flash","type":"PaymentMethodRequired","message":"No payment method ID was specified. Please provide a valid payment method ID.","path":"$.payment_instruments[0].payment_method_id"},{"_type":"flash","type":"OrderTotalNotSet","message":"Order total missing, calculation failed.","path":"$.order_total"},{"_type":"flash","type":"ShippingMethodRequired","message":"No shipping method ID was specified. Please provide a valid shipping method ID.","path":"$.shipments[0].shipping_method","details":{"shipmentId":"me"}},{"_type":"flash","type":"ShippingItemAdjustedPriceNotSet","message":"Price missing for shipping item \'\'089e779e624e5ee3ad0d68a2e7\'\'.","path":"$.shipping_items[0].adjusted_price"}],"adjusted_merchandize_total_tax":0.00,"adjusted_shipping_total_tax":null,"agent_basket":true,"basket_id":"c5bc31cb94ab7db35fb1792b74","billing_address":{"_type":"order_address","address1":"128 Basswood Cir","city":"Ft Wright","country_code":"US","first_name":"Jacob","full_name":"Jacob Fisher","id":"4bf659e3d557ff140faa5c97d0","last_name":"Fisher","phone":"1234567890","postal_code":"41011-3711","state_code":"KY","c_validateAddress":true},"channel_type":"callcenter","creation_date":"2022-07-19T15:12:13.646Z","currency":"USD","customer_info":{"_type":"customer_info","customer_id":"bdEb3AQPusldHm1nramTGe2bOr","customer_no":"00053012","email":"abertolinhg@answers.com"},"last_modified":"2022-07-19T15:18:12.154Z","merchandize_total_tax":0.00,"notes":{"_type":"simple_link","link":"https://development.dynamiccatholic.com/s/dci_us/dw/shop/v20_4/baskets/c5bc31cb94ab7db35fb1792b74/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"},"order_total":null,"product_items":[{"_type":"product_item","adjusted_tax":0.00,"base_price":0.00,"bonus_product_line_item":false,"gift":false,"item_id":"6efcdb109b3b8be17d86610106","item_text":"1001 Reasons Why Its Great to Be Catholic","price":0.00,"price_after_item_discount":0.00,"price_after_order_discount":0.00,"product_id":"GTBC-06-MM-ENG","product_name":"1001 Reasons Why Its Great to Be Catholic","quantity":1,"shipment_id":"me","tax":0.00,"tax_basis":0.00,"tax_class_id":null,"tax_rate":0.0,"c_customPrice":"0.0"}],"product_sub_total":0.00,"product_total":0.00,"shipments":[{"_type":"shipment","adjusted_merchandize_total_tax":0.00,"adjusted_shipping_total_tax":null,"gift":false,"merchandize_total_tax":0.00,"product_sub_total":0.00,"product_total":0.00,"shipment_id":"me","shipment_total":null,"shipping_address":{"_type":"order_address","address1":"128 Basswood Cir","city":"Ft Wright","country_code":"US","first_name":"Jacob","full_name":"Jacob Fisher4","id":"b82e695bca548e2b2cba07c78a","last_name":"Fisher4","phone":"null","postal_code":"41011-3711","state_code":"KY","c_validateAddress":true},"shipping_status":"not_shipped","shipping_total":null,"shipping_total_tax":null,"tax_total":null}],"shipping_items":[{"_type":"shipping_item","adjusted_tax":null,"base_price":null,"item_id":"089e779e624e5ee3ad0d68a2e7","item_text":"Shipping","price":null,"price_after_item_discount":null,"shipment_id":"me","tax":null,"tax_basis":null,"tax_class_id":null,"tax_rate":0.0}],"shipping_total":null,"shipping_total_tax":null,"taxation":"net","tax_total":null}';
        }else if(code == 400){
            this.status = 'Bad Request';
            this.body = '{"_v":"20.3","fault":{"arguments":{"accessToken":"12345"},"type":"InvalidAccessTokenException","message":"The request is unauthorized, the access token is invalid."}}';
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
        res.setHeader('Contect-Type','application/json');
        res.setStatus(this.status);
        res.setStatusCode(this.code);
        return res;
    }
}