/**
 * Created by jacob.fisher 
 * Created Date 1/13/2020.
 * Description: Mock api data for deleting a coupon from the basket.
 */

@IsTest
public with sharing class OCAPIDeleteCouponFromBasketMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String body;

    /*
    * @description: Constructor method to set values for either a successful or failed mock api callout
    * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
    */

    public OCAPIDeleteCouponFromBasketMock(Integer code) {
        this.code = code;
        if (code == 200) {
            this.status = 'OK';
            this.body = '{"_v":"19.8","_type":"basket","_resource_state":"11c25685e00eb5b8830ef87c6c20ded315dffec73f0d8b4e67cf7aa464cb2556","adjusted_merchandize_total_tax":2.75,"adjusted_shipping_total_tax":0.00,"agent_basket":true,"basket_id":"768865e3bd563cf2f991d393b6","billing_address":{"_type":"order_address","address1":"123 test","city":"Washington","country_code":"US","first_name":"Jacob","full_name":"Jacob Fisher","id":"bece837a7b244a92a5f7e9a4a2","last_name":"Fisher","postal_code":"52353","state_code":"IA"},"channel_type":"callcenter","creation_date":"2020-01-13T13:04:03.489Z","currency":"USD","customer_info":{"_type":"customer_info","customer_id":"adrbWGIocvM3GkytUYanzUkENc","customer_no":"00015501","email":"testjf@noemail.com"},"last_modified":"2020-01-13T13:05:48.846Z","merchandize_total_tax":2.75,"notes":{"_type":"simple_link","link":"https://dev05-na01-dynamiccatholicinstitute.demandware.net/s/DCI/dw/shop/v19_8/baskets/768865e3bd563cf2f991d393b6/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"},"order_total":57.75,"payment_instruments":[{"_type":"order_payment_instrument","amount":0.0,"payment_card":{"_type":"payment_card","card_type":"Visa","credit_card_expired":false},"payment_instrument_id":"ee76a2271a2fe584724a1c2c54","payment_method_id":"CREDIT_CARD"}],"product_items":[{"_type":"product_item","adjusted_tax":2.75,"base_price":55.00,"bonus_product_line_item":false,"gift":false,"item_id":"464da994a05d1f62a4e68246e7","item_text":"Product Line Item","price":55.00,"price_after_item_discount":55.00,"price_after_order_discount":55.00,"product_id":"One-Time Donation","quantity":1,"shipment_id":"me","tax":2.75,"tax_basis":55.00,"tax_class_id":null,"tax_rate":0.05}],"product_sub_total":55.00,"product_total":55.00,"shipments":[{"_type":"shipment","adjusted_merchandize_total_tax":2.75,"adjusted_shipping_total_tax":0.00,"gift":false,"merchandize_total_tax":2.75,"product_sub_total":55.00,"product_total":55.00,"shipment_id":"me","shipment_total":57.75,"shipping_address":{"_type":"order_address","address1":"123 test","city":"Washington","country_code":"US","first_name":"Jacob","full_name":"Jacob Fisher","id":"bece837a7b244a92a5f7e9a4a2","last_name":"Fisher","postal_code":"52353","state_code":"IA"},"shipping_method":{"_type":"shipping_method","description":"Order will be received between 2 - 10 days","id":"999","name":"UPS Mail Innovations","price":0.00,"c_storePickupEnabled":false},"shipping_status":"not_shipped","shipping_total":0.00,"shipping_total_tax":0.00,"tax_total":2.75}],"shipping_items":[{"_type":"shipping_item","adjusted_tax":0.00,"base_price":0.00,"item_id":"c5abb557f38124697aabecca70","item_text":"Shipping","price":0.00,"price_after_item_discount":0.00,"shipment_id":"me","tax":0.00,"tax_basis":0.00,"tax_class_id":null,"tax_rate":0.05}],"shipping_total":0.00,"shipping_total_tax":0.00,"taxation":"net","tax_total":2.75}';

        }else if(code == 400) {
            this.status = 'Bad Request';
            this.body = '{' +
                            '"_v":"19.8",' +
                            '"fault":{' +
                                '"arguments":{' +
                                    '"couponItemId":"4bac96a7e53387352a3c815e93"' +
                                '},' +
                                '"type":"CouponItemNotFoundException",' +
                                '"message":"The coupon item ID \'4bac96a7e53387352a3c815e93\' couldn\'t be found."' +
                            '}' +
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