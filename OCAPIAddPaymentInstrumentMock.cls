/**
 * @author  Susan Durand
 * @date    02/13/2020
 * @description This class is the mock data for the OCAPIAddPaymentInstrument Api callout
 */

@IsTest
public with sharing class OCAPIAddPaymentInstrumentMock implements HttpCalloutMock{
    protected Integer code;
    protected String status;
    protected String body;

    /**
    * @description: Constructor method to set values for either a successful or failed mock api callout
    * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
    */
    public OCAPIAddPaymentInstrumentMock(Integer code){
        this.code = code;
        if(code == 200){
            this.status = 'OK';
            this.body = '{"_v":"19.8","_type":"basket","_resource_state":"af3d7fab13d9621aea7d3c3afb8d872a0c6071580ab18aa3c236c4ae63112d8f","_flash":[{"_type":"flash","type":"ProductItemsRequired","message":"Product items are required.","path":"$.product_items"}],"adjusted_merchandize_total_tax":0.00,"adjusted_shipping_total_tax":0.00,"agent_basket":true,"basket_id":"1c6a7da982b3a7014b8c119cc8","billing_address":{"_type":"order_address","address1":"42nd St","city":"Erlanger","country_code":"US","first_name":"First","full_name":"First Last","id":"a004eb2cd5acb13c3097793377","last_name":"Last","postal_code":"41017","state_code":"AZ"},"channel_type":"callcenter","creation_date":"2020-02-13T15:26:40.333Z","currency":"USD","customer_info":{"_type":"customer_info","customer_id":"ab92BrE0AGFHhf4K0YZWOq309X","customer_no":"00009004","email":"sdemail1@noemail.com"},"last_modified":"2020-02-13T15:27:08.087Z","merchandize_total_tax":0.00,"notes":{"_type":"simple_link","link":"https://dev05-na01-dynamiccatholicinstitute.demandware.net/s/DCI/dw/shop/v19_8/baskets/1c6a7da982b3a7014b8c119cc8/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"},"order_total":0.00,"payment_instruments":[{"_type":"order_payment_instrument","amount":0.0,"payment_card":{"_type":"payment_card","card_type":"Visa","credit_card_expired":false},"payment_instrument_id":"82e4f4b0313c319b98ee7d9aec","payment_method_id":"CREDIT_CARD"}],"product_sub_total":0.00,"product_total":0.00,"shipments":[{"_type":"shipment","adjusted_merchandize_total_tax":0.00,"adjusted_shipping_total_tax":0.00,"gift":false,"merchandize_total_tax":0.00,"product_sub_total":0.00,"product_total":0.00,"shipment_id":"me","shipment_total":0.00,"shipping_address":{"_type":"order_address","address1":"42nd St","city":"Erlanger","country_code":"US","first_name":"First","full_name":"First Last","id":"a004eb2cd5acb13c3097793377","last_name":"Last","postal_code":"41017","state_code":"AZ"},"shipping_method":{"_type":"shipping_method","description":"Order will be received between 2 - 10 days","id":"999","name":"UPS Mail Innovations","price":2.00,"c_storePickupEnabled":false},"shipping_status":"not_shipped","shipping_total":0.00,"shipping_total_tax":0.00,"tax_total":0.00}],"shipping_items":[{"_type":"shipping_item","adjusted_tax":0.00,"base_price":0.00,"item_id":"6d7ce1663c96aa8f16dea83f00","item_text":"Shipping","price":0.00,"price_after_item_discount":0.00,"shipment_id":"me","tax":0.00,"tax_basis":0.00,"tax_class_id":"CustomRate","tax_rate":0.0}],"shipping_total":0.00,"shipping_total_tax":0.00,"taxation":"net","tax_total":0.00}';
        }else if(code == 400){
            this.status = 'Bad Request';
            this.body = '{"_v":"19.8","fault":{"arguments":{"parameter":"Body"},"type":"NullConstraintViolationException","message":"The null value constraint for parameter \'Body\' was violated. Null isn\'t allowed. Please provide a value."}}';
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