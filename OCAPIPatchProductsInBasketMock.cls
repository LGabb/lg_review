/**
 * Name: Susan Durand
 * Date: 08/20/2019
 * Description: This class is the mock data for the OCAPICustomerUpdate Api callout
 */

@IsTest
public with sharing class OCAPIPatchProductsInBasketMock implements HttpCalloutMock{
    protected Integer code;
    protected String status;
    protected String body;


    /**
     * @description: Constructor method to set values for either a successful or failed mock api callout
     * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
     */
    public OCAPIPatchProductsInBasketMock(Integer code){
        this.code = code;
        if(code==200){
            this.status = 'OK';
            this.body = '{"_v":"20.8","_type":"basket","_resource_state":"7c9d67eb1a863238fce47fe49bd2ddc7b3431f1caa05228ed49537aef0ffadf9","_flash":[{"_type":"flash","type":"PaymentMethodRequired","message":"No payment method ID was specified. Please provide a valid payment method ID.","path":"$.payment_instruments[0].payment_method_id"},{"_type":"flash","type":"BillingAddressRequired","message":"No billing address was specified. Please provide a valid billing address.","path":"$.billing_address"},{"_type":"flash","type":"OrderTotalNotSet","message":"Order total missing, calculation failed.","path":"$.order_total"},{"_type":"flash","type":"ShippingAddressRequired","message":"No shipping address was specified. Please provide a valid shipping address.","path":"$.shipments[0].shipping_address","details":{"shipmentId":"me"}},{"_type":"flash","type":"ShippingMethodRequired","message":"No shipping method ID was specified. Please provide a valid shipping method ID.","path":"$.shipments[0].shipping_method","details":{"shipmentId":"me"}},{"_type":"flash","type":"ShippingItemAdjustedPriceNotSet","message":"Price missing for shipping item \'\'2cf313f8d4bfe36c14c97e1d74\'\'.","path":"$.shipping_items[0].adjusted_price"}],"adjusted_merchandize_total_tax":null,"adjusted_shipping_total_tax":null,"agent_basket":true,"basket_id":"289fd83197d8010108e1f644b9","channel_type":"callcenter","creation_date":"2020-08-20T18:09:02.281Z","currency":"USD","customer_info":{"_type":"customer_info","customer_id":"abNqrdgLmbqREiqjriq46qFWGq","customer_no":"00005501","email":"testsd@noemail.com"},"last_modified":"2020-08-20T18:09:40.189Z","merchandize_total_tax":null,"notes":{"_type":"simple_link","link":"https://staging.dynamiccatholic.com/s/dci_us/dw/shop/v20_8/baskets/289fd83197d8010108e1f644b9/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"},"order_total":null,"product_items":[{"_type":"product_item","adjusted_tax":null,"base_price":0.00,"bonus_product_line_item":false,"gift":false,"item_id":"7f77b5ec853d77d19e39db6ba5","item_text":"1001 Reasons Why It\'s Great to Be Catholic","price":0.00,"price_after_item_discount":0.00,"price_after_order_discount":0.00,"product_id":"GTBC-06-MM-ENG","product_name":"1001 Reasons Why It\'s Great to Be Catholic","quantity":2,"shipment_id":"me","tax":null,"tax_basis":null,"tax_class_id":null,"tax_rate":null},{"_type":"product_item","adjusted_tax":null,"base_price":0.00,"bonus_product_line_item":false,"gift":false,"item_id":"41235ef9822bafdeaf2cb42a8f","item_text":"13 Powerful Ways to Pray","price":0.00,"price_after_item_discount":0.00,"price_after_order_discount":0.00,"product_id":"13PW-88-MM-ENG","product_name":"13 Powerful Ways to Pray","quantity":3,"shipment_id":"me","tax":null,"tax_basis":null,"tax_class_id":null,"tax_rate":null},{"_type":"product_item","adjusted_tax":null,"base_price":27.95,"bonus_product_line_item":false,"gift":false,"item_id":"4ee3bb33637cfe11f1b6cd7a51","item_text":"Rediscover Catholicism","price":111.80,"price_after_item_discount":111.80,"price_after_order_discount":111.80,"product_id":"RCAT-9-HC-ENG","product_name":"Rediscover Catholicism","quantity":4,"shipment_id":"me","tax":null,"tax_basis":null,"tax_class_id":null,"tax_rate":null},{"_type":"product_item","adjusted_tax":null,"base_price":0.00,"bonus_product_line_item":false,"gift":false,"item_id":"c19b18f4175b689a70abbd0110","item_text":"Rediscover Catholicism","price":0.00,"price_after_item_discount":0.00,"price_after_order_discount":0.00,"product_id":"RCAT-67-MM-ENG","product_name":"Rediscover Catholicism","quantity":5,"shipment_id":"me","tax":null,"tax_basis":null,"tax_class_id":null,"tax_rate":null},{"_type":"product_item","adjusted_tax":null,"base_price":3.00,"bonus_product_line_item":false,"gift":false,"item_id":"dfeb823b72e68f48ac00296e94","item_text":"Redescubre el Catolicismo","price":18.00,"price_after_item_discount":18.00,"price_after_order_discount":18.00,"product_id":"RCAT-20-MM-SPA","product_name":"Redescubre el Catolicismo","quantity":6,"shipment_id":"me","tax":null,"tax_basis":null,"tax_class_id":null,"tax_rate":null},{"_type":"product_item","adjusted_tax":null,"base_price":3.00,"bonus_product_line_item":false,"gift":false,"item_id":"c356704b5bb2fa35ad9aab517b","item_text":"Rediscover Catholicism","price":21.00,"price_after_item_discount":21.00,"price_after_order_discount":21.00,"product_id":"RCAT-81-MM-KOR","product_name":"Rediscover Catholicism","quantity":7,"shipment_id":"me","tax":null,"tax_basis":null,"tax_class_id":null,"tax_rate":null}],"product_sub_total":150.80,"product_total":150.80,"shipments":[{"_type":"shipment","adjusted_merchandize_total_tax":null,"adjusted_shipping_total_tax":null,"gift":false,"merchandize_total_tax":null,"product_sub_total":150.80,"product_total":150.80,"shipment_id":"me","shipment_total":null,"shipping_status":"not_shipped","shipping_total":null,"shipping_total_tax":null,"tax_total":null}],"shipping_items":[{"_type":"shipping_item","adjusted_tax":null,"base_price":null,"item_id":"2cf313f8d4bfe36c14c97e1d74","item_text":"Shipping","price":null,"price_after_item_discount":null,"shipment_id":"me","tax":null,"tax_basis":null,"tax_class_id":null,"tax_rate":null}],"shipping_total":null,"shipping_total_tax":null,"taxation":"net","tax_total":null}';
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