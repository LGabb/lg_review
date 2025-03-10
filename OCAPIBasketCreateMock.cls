/**
 * @author Susan Durand
 * @date 02/11/2020
 * @description: This class is the mock data for the OCAPIBasjetCreate api callout
 */

@IsTest
public with sharing class OCAPIBasketCreateMock implements HttpCalloutMock{
    protected Integer code;
    protected String status;
    protected String body;

    /**
     * @description: Constructor method to set values for either a successful or failed mock api callout
     * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
    */
    public OCAPIBasketCreateMock(Integer code) {
        this.code = code;
        if(code == 200){
            this.status = 'OK';
            //Response when basket is successfully created
            this.body = '{"_v":"19.8","_type":"basket","_resource_state":"cc13754375fb7b8fc224cadcad98d41c93b456b96edcfa2c681f965fdd0a5566","_flash":[{"_type":"flash","type":"ProductItemsRequired","message":"Product items are required.","path":"$.product_items"},{"_type":"flash","type":"PaymentMethodRequired","message":"No payment method ID was specified. Please provide a valid payment method ID.","path":"$.payment_instruments[0].payment_method_id"},{"_type":"flash","type":"BillingAddressRequired","message":"No billing address was specified. Please provide a valid billing address.","path":"$.billing_address"},{"_type":"flash","type":"ShippingAddressRequired","message":"No shipping address was specified. Please provide a valid shipping address.","path":"$.shipments[0].shipping_address","details":{"shipmentId":"me"}},{"_type":"flash","type":"ShippingMethodRequired","message":"No shipping method ID was specified. Please provide a valid shipping method ID.","path":"$.shipments[0].shipping_method","details":{"shipmentId":"me"}}],"adjusted_merchandize_total_tax":0.00,"adjusted_shipping_total_tax":0.00,"agent_basket":true,"basket_id":"06054edb004c633b5b602b908a","channel_type":"callcenter","creation_date":"2020-02-11T15:21:42.743Z","currency":"USD","customer_info":{"_type":"customer_info","customer_id":"ab4IxtNaNmkkrr69tZuzlk6wz6","email":""},"last_modified":"2020-02-11T15:21:42.752Z","merchandize_total_tax":0.00,"notes":{"_type":"simple_link","link":"https://dev05-na01-dynamiccatholicinstitute.demandware.net/s/DCI/dw/shop/v19_8/baskets/06054edb004c633b5b602b908a/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"},"order_total":0.00,"product_sub_total":0.00,"product_total":0.00,"shipments":[{"_type":"shipment","adjusted_merchandize_total_tax":0.00,"adjusted_shipping_total_tax":0.00,"gift":false,"merchandize_total_tax":0.00,"product_sub_total":0.00,"product_total":0.00,"shipment_id":"me","shipment_total":0.00,"shipping_status":"not_shipped","shipping_total":0.00,"shipping_total_tax":0.00,"tax_total":0.00}],"shipping_items":[{"_type":"shipping_item","adjusted_tax":0.00,"base_price":0.00,"item_id":"4079807db943f8aa95c506214e","item_text":"Shipping","price":0.00,"price_after_item_discount":0.00,"shipment_id":"me","tax":0.00,"tax_basis":0.00,"tax_class_id":"CustomRate","tax_rate":0.0}],"shipping_total":0.00,"shipping_total_tax":0.00,"taxation":"net","tax_total":0.00}';

        }else if(code == 400){
            this.status = 'Bad Request';
            //Added bad basket id to callout body to get this error
            this.body = '{"_v":"19.8","fault":{"arguments":{"body":"{\\"basket_id\\"=\\"abc123\\"}"},"type":"BodyDecodingException","message":"An error occurred while decoding the request, the body was \'{\\"basket_id\\"=\\"abc123\\"}\'."}}';
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
        res.setHeader('Content-Type', 'application/json');
        res.setStatus(this.status);
        res.setStatusCode(this.code);
        return res;
    }
}