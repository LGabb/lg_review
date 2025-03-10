/**
 * @author  Susan Durand
 * @date    02/11/2020
 * @description This class is the mock data for the OCAPIAddItemToBasket Api callout
 */

@IsTest
public with sharing class OCAPIAddItemToBasketMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String body;

    /**
    * @description: Constructor method to set values for either a successful or failed mock api callout
    * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
    */
    public OCAPIAddItemToBasketMock(Integer code){
        this.code = code;
        if(code == 200){
            this.status = 'OK';
            this.body = '{"_v":"19.8","_type":"basket","_resource_state":"c11cb86e3f579891db7ea54938cb11b301b8d270aa168079c3ccaa232172161f","_flash":[{"_type":"flash","type":"PaymentMethodRequired","message":"No payment method ID was specified. Please provide a valid payment method ID.","path":"$.payment_instruments[0].payment_method_id"},{"_type":"flash","type":"BillingAddressRequired","message":"No billing address was specified. Please provide a valid billing address.","path":"$.billing_address"},{"_type":"flash","type":"OrderTotalNotSet","message":"Order total missing, calculation failed.","path":"$.order_total"},{"_type":"flash","type":"ShippingAddressRequired","message":"No shipping address was specified. Please provide a valid shipping address.","path":"$.shipments[0].shipping_address","details":{"shipmentId":"me"}},{"_type":"flash","type":"ShippingMethodRequired","message":"No shipping method ID was specified. Please provide a valid shipping method ID.","path":"$.shipments[0].shipping_method","details":{"shipmentId":"me"}},{"_type":"flash","type":"ShippingItemAdjustedPriceNotSet","message":"Price missing for shipping item \'\'37c1e5a51e43df1aa3c1828a10\'\'.","path":"$.shipping_items[0].adjusted_price"}],"adjusted_merchandize_total_tax":0.00,"adjusted_shipping_total_tax":null,"agent_basket":true,"basket_id":"12843f8491a133741d83e18cc8","channel_type":"callcenter","creation_date":"2020-02-14T19:50:16.357Z","currency":"USD","customer_info":{"_type":"customer_info","customer_id":"ab7vIjnX6jGoagSUrfn9uI53Hg","customer_no":"00012507","email":"sdemail4@noemail.com"},"last_modified":"2020-02-14T19:50:24.402Z","merchandize_total_tax":0.00,"notes":{"_type":"simple_link","link":"https://dev05-na01-dynamiccatholicinstitute.demandware.net/s/DCI/dw/shop/v19_8/baskets/12843f8491a133741d83e18cc8/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"},"order_total":null,"product_items":[{"_type":"product_item","adjusted_tax":0.00,"base_price":50.00,"bonus_product_line_item":false,"gift":false,"item_id":"a2e3b405d026ca1a08cc896314","item_text":"Donation One Time Gift","price":50.00,"price_after_item_discount":50.00,"price_after_order_discount":50.00,"product_id":"DON-USA-OTG","product_name":"Donation One Time Gift","quantity":1,"shipment_id":"me","tax":0.00,"tax_basis":50.00,"tax_class_id":"exempt","tax_rate":0.0}],"product_sub_total":50.00,"product_total":50.00,"shipments":[{"_type":"shipment","adjusted_merchandize_total_tax":0.00,"adjusted_shipping_total_tax":null,"gift":false,"merchandize_total_tax":0.00,"product_sub_total":50.00,"product_total":50.00,"shipment_id":"me","shipment_total":null,"shipping_status":"not_shipped","shipping_total":null,"shipping_total_tax":null,"tax_total":null}],"shipping_items":[{"_type":"shipping_item","adjusted_tax":null,"base_price":null,"item_id":"37c1e5a51e43df1aa3c1828a10","item_text":"Shipping","price":null,"price_after_item_discount":null,"shipment_id":"me","tax":null,"tax_basis":null,"tax_class_id":null,"tax_rate":0.05}],"shipping_total":null,"shipping_total_tax":null,"taxation":"net","tax_total":null}';
        }else if(code == 400){
            //You get this error if the product id does not match an available product in SFCC
            this.status = 'Bad Request';
            this.body = '{"_v":"19.8","fault":{"arguments":{"productId":"One-Time Donation"},"type":"InvalidProductItemException","message":"Product \'One-Time Donation\' is unknown, offline or not assigned to the site catalog."}}';
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