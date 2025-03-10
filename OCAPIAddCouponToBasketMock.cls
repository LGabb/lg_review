/**
 * Created by jacob.fisher 
 * Created Date 1/6/2020.
 * Description: Mock api data to add a coupon to a basket.
 */

@IsTest
public with sharing class OCAPIAddCouponToBasketMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String body;

    /*
    * @description: Constructor method to set values for either a successful or failed mock api callout
    * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
    */

    public OCAPIAddCouponToBasketMock(Integer code) {
        this.code = code;
        if (code == 200) {
            this.status = 'OK';
            this.body = '{"_v":"19.8","_type":"basket","_resource_state":"68ad04043204534c8dae11436c3ccf0eb41c7a5d445b532288a008bf3ceac645","_flash":[{"_type":"flash","type":"PaymentMethodRequired","message":"No payment method ID was specified. Please provide a valid payment method ID.","path":"$.payment_instruments[0].payment_method_id"},{"_type":"flash","type":"BillingAddressRequired","message":"No billing address was specified. Please provide a valid billing address.","path":"$.billing_address"},{"_type":"flash","type":"OrderTotalNotSet","message":"Order total missing, calculation failed.","path":"$.order_total"},{"_type":"flash","type":"ShippingAddressRequired","message":"No shipping address was specified. Please provide a valid shipping address.","path":"$.shipments[0].shipping_address","details":{"shipmentId":"me"}},{"_type":"flash","type":"ShippingMethodRequired","message":"No shipping method ID was specified. Please provide a valid shipping method ID.","path":"$.shipments[0].shipping_method","details":{"shipmentId":"me"}},{"_type":"flash","type":"ShippingItemAdjustedPriceNotSet","message":"Price missing for shipping item \'\'4b30206663392f8a2b4c5ad3b3\'\'.","path":"$.shipping_items[0].adjusted_price"}],"adjusted_merchandize_total_tax":2.65,"adjusted_shipping_total_tax":null,"agent_basket":true,"basket_id":"7de004e0e99162820f15bcefa5","channel_type":"callcenter","coupon_items":[{"_type":"coupon_item","code":"Test","coupon_item_id":"89caf431b5fd78ae8f2b82f741","status_code":"applied","valid":true}],"creation_date":"2020-01-10T19:17:03.659Z","currency":"USD","customer_info":{"_type":"customer_info","customer_id":"ac2DpFs51p5s0flEriPaMOtAtZ","customer_no":"00015502","email":"Test8457@noemail.com"},"last_modified":"2020-01-10T19:31:34.268Z","merchandize_total_tax":2.75,"notes":{"_type":"simple_link","link":"https://dev05-na01-dynamiccatholicinstitute.demandware.net/s/DCI/dw/shop/v19_8/baskets/7de004e0e99162820f15bcefa5/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"},"order_total":null,"product_items":[{"_type":"product_item","adjusted_tax":0.00,"base_price":0.00,"bonus_product_line_item":false,"gift":false,"item_id":"d369db32d156f7ee98aa226cc8","item_text":"Product Line Item","price":0.00,"price_after_item_discount":0.00,"price_after_order_discount":0.00,"product_id":"The Four Signs of a Dynamic Catholic-ENG-PB","quantity":10,"shipment_id":"me","tax":0.00,"tax_basis":0.00,"tax_class_id":null,"tax_rate":0.05},{"_type":"product_item","adjusted_tax":2.65,"base_price":55.00,"bonus_product_line_item":false,"gift":false,"item_id":"58f723c332b76c41a2695affab","item_text":"Product Line Item","price":55.00,"price_adjustments":[{"_type":"price_adjustment","applied_discount":{"_type":"discount","amount":2.0,"type":"amount"},"coupon_code":"Test","creation_date":"2020-01-10T19:31:34.252Z","custom":false,"item_text":"Overall Discount CRM Test","last_modified":"2020-01-10T19:31:34.268Z","manual":false,"price":-2.00,"price_adjustment_id":"e9141b8f0931cc995127926a2c","promotion_id":"$2-Off-CRM","promotion_link":"https://dev05-na01-dynamiccatholicinstitute.demandware.net/s/DCI/dw/shop/v19_8/promotions/$2-Off-CRM?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"}],"price_after_item_discount":53.00,"price_after_order_discount":53.00,"product_id":"One-Time Donation","quantity":1,"shipment_id":"me","tax":2.75,"tax_basis":55.00,"tax_class_id":null,"tax_rate":0.05}],"product_sub_total":53.00,"product_total":53.00,"shipments":[{"_type":"shipment","adjusted_merchandize_total_tax":2.65,"adjusted_shipping_total_tax":null,"gift":false,"merchandize_total_tax":2.75,"product_sub_total":53.00,"product_total":53.00,"shipment_id":"me","shipment_total":null,"shipping_status":"not_shipped","shipping_total":null,"shipping_total_tax":null,"tax_total":null}],"shipping_items":[{"_type":"shipping_item","adjusted_tax":null,"base_price":null,"item_id":"4b30206663392f8a2b4c5ad3b3","item_text":"Shipping","price":null,"price_after_item_discount":null,"shipment_id":"me","tax":null,"tax_basis":null,"tax_class_id":null,"tax_rate":0.05}],"shipping_total":null,"shipping_total_tax":null,"taxation":"net","tax_total":null}';

    }else if(code == 400){
            this.status = 'Bad Request';
            this.body = '{'+
                            '"_v":"19.8",'+
                            '"fault":{'+
                                '"arguments":{'+
                                        '"couponCode":"abc123"'+
                                '},'+
                            '"type":"InvalidCouponCodeException",'+
                            '"message":"Coupon code \'abc123\' is invalid."'+
                            '}'+
                        '}';
        }
    }

    /*
     * @description: This method returns a mock api callout response
     * @param req: HttpRequest - the Http Request callout from the test code
     * @return HttpResponse - returns the mock api callout response, with values set in the constructor method
     */
    public HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setBody(this.body);
        res.setStatus(this.status);
        res.setStatusCode(this.code);
        return res;
    }
}