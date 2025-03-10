/**
 * Name: Susan Durand
 * Date: 08/20/2019
 * Description: This class is the mock data for the OCAPIDeleteProductFromBasket Api callout
 */

@IsTest
public with sharing class OCAPIDeleteProductFromBasketMock implements HttpCalloutMock{
    protected Integer code;
    protected String status;
    protected String body;


    /**
     * @description: Constructor method to set values for either a successful or failed mock api callout
     * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
     */
    public OCAPIDeleteProductFromBasketMock(Integer code){
        this.code = code;
        if(code==200){
            this.status = 'OK';
            this.body = '{"_v":"20.8","_type":"basket","_resource_state":"d662d5f40c1f8333a43f7f9e32dbf6fae765c6b7e71c14902e4c44636fc0111d","_flash":[{"_type":"flash","type":"PaymentMethodRequired","message":"No payment method ID was specified. Please provide a valid payment method ID.","path":"$.payment_instruments[0].payment_method_id"},{"_type":"flash","type":"BillingAddressRequired","message":"No billing address was specified. Please provide a valid billing address.","path":"$.billing_address"},{"_type":"flash","type":"OrderTotalNotSet","message":"Order total missing, calculation failed.","path":"$.order_total"},{"_type":"flash","type":"ShippingAddressRequired","message":"No shipping address was specified. Please provide a valid shipping address.","path":"$.shipments[0].shipping_address","details":{"shipmentId":"me"}},{"_type":"flash","type":"ShippingMethodRequired","message":"No shipping method ID was specified. Please provide a valid shipping method ID.","path":"$.shipments[0].shipping_method","details":{"shipmentId":"me"}},{"_type":"flash","type":"ShippingItemAdjustedPriceNotSet","message":"Price missing for shipping item \'\'f410aa1e7591890f181302afaa\'\'.","path":"$.shipping_items[0].adjusted_price"}],"adjusted_merchandize_total_tax":null,"adjusted_shipping_total_tax":null,"agent_basket":true,"basket_id":"4e83e044759322a1139a805b4f","channel_type":"callcenter","creation_date":"2020-08-20T17:06:56.601Z","currency":"USD","customer_info":{"_type":"customer_info","customer_id":"abNqrdgLmbqREiqjriq46qFWGq","customer_no":"00005501","email":"testsd@noemail.com"},"last_modified":"2020-08-20T17:07:16.573Z","merchandize_total_tax":null,"notes":{"_type":"simple_link","link":"https://staging.dynamiccatholic.com/s/dci_us/dw/shop/v20_8/baskets/4e83e044759322a1139a805b4f/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"},"order_total":null,"product_items":[{"_type":"product_item","adjusted_tax":null,"base_price":0.00,"bonus_product_line_item":false,"gift":false,"item_id":"bd74fddee81a613a36d2453dd7","item_text":"13 Powerful Ways to Pray","price":0.00,"price_after_item_discount":0.00,"price_after_order_discount":0.00,"product_id":"13PW-88-MM-ENG","product_name":"13 Powerful Ways to Pray","quantity":1,"shipment_id":"me","tax":null,"tax_basis":null,"tax_class_id":null,"tax_rate":null}],"product_sub_total":0.00,"product_total":0.00,"shipments":[{"_type":"shipment","adjusted_merchandize_total_tax":null,"adjusted_shipping_total_tax":null,"gift":false,"merchandize_total_tax":null,"product_sub_total":0.00,"product_total":0.00,"shipment_id":"me","shipment_total":null,"shipping_status":"not_shipped","shipping_total":null,"shipping_total_tax":null,"tax_total":null}],"shipping_items":[{"_type":"shipping_item","adjusted_tax":null,"base_price":null,"item_id":"f410aa1e7591890f181302afaa","item_text":"Shipping","price":null,"price_after_item_discount":null,"shipment_id":"me","tax":null,"tax_basis":null,"tax_class_id":null,"tax_rate":null}],"shipping_total":null,"shipping_total_tax":null,"taxation":"net","tax_total":null}';
        }else if(code==400){
            this.status = 'Bad Request';
            this.body = '{"_v":"20.8","fault":{"arguments":{"accessToken":"123abc"},"type":"InvalidAccessTokenException","message":"The request is unauthorized, the access token is invalid."}}';
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