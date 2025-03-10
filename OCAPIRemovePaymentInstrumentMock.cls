/**
 * Name: Susan Durand
 * Date: 08/20/2019
 * Description: This class is the mock data for the OCAPIRemovePaymentInstrumentFromBasket Api callout
 */

@IsTest
public with sharing class OCAPIRemovePaymentInstrumentMock implements HttpCalloutMock{
    protected Integer code;
    protected String status;
    protected String body;


    /**
     * @description: Constructor method to set values for either a successful or failed mock api callout
     * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
     */
    public OCAPIRemovePaymentInstrumentMock(Integer code){
        this.code = code;
        if(code==200){
            this.status = 'OK';
            this.body = '{"_v":"20.8","_type":"basket","_resource_state":"5374b12d9ecb272813bb695b61dec373bd10897d3501d3c881d9a6a8e2bd5879","_flash":[{"_type":"flash","type":"PaymentMethodRequired","message":"No payment method ID was specified. Please provide a valid payment method ID.","path":"$.payment_instruments[0].payment_method_id"}],"adjusted_merchandize_total_tax":0.00,"adjusted_shipping_total_tax":0.00,"agent_basket":true,"basket_id":"05f9969c0d7834b35389428b32","billing_address":{"_type":"order_address","address1":"5081 Olympic Blvd","city":"Erlanger","company_name":"null","country_code":"US","first_name":"Susan","full_name":"Susan Durand","id":"e014b2e9ef1a264d6c4b249eba","last_name":"Durand","postal_code":"41018-3164","state_code":"KY","c_validateAddress":true},"channel_type":"callcenter","creation_date":"2020-08-20T19:06:47.966Z","currency":"USD","customer_info":{"_type":"customer_info","customer_id":"abNqrdgLmbqREiqjriq46qFWGq","customer_no":"00005501","email":"testsd@noemail.com"},"last_modified":"2020-08-20T19:07:49.562Z","merchandize_total_tax":0.00,"notes":{"_type":"simple_link","link":"https://staging.dynamiccatholic.com/s/dci_us/dw/shop/v20_8/baskets/05f9969c0d7834b35389428b32/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"},"order_total":0.00,"product_items":[{"_type":"product_item","adjusted_tax":0.00,"base_price":0.00,"bonus_product_line_item":false,"gift":false,"item_id":"1b0683bf3abc460d7d61c90653","item_text":"1001 Reasons Why It\'s Great to Be Catholic","price":0.00,"price_after_item_discount":0.00,"price_after_order_discount":0.00,"product_id":"GTBC-06-MM-ENG","product_name":"1001 Reasons Why It\'s Great to Be Catholic","quantity":1,"shipment_id":"me","shipping_item_id":"2ffaff597cc568bea32959b3c8","tax":0.00,"tax_basis":0.00,"tax_class_id":null,"tax_rate":0.0}],"product_sub_total":0.00,"product_total":0.00,"shipments":[{"_type":"shipment","adjusted_merchandize_total_tax":0.00,"adjusted_shipping_total_tax":0.00,"gift":false,"merchandize_total_tax":0.00,"product_sub_total":0.00,"product_total":0.00,"shipment_id":"me","shipment_total":0.00,"shipping_address":{"_type":"order_address","address1":"5081 Olympic Blvd","city":"Erlanger","company_name":"null","country_code":"US","first_name":"Susan","full_name":"Susan Durand","id":"e014b2e9ef1a264d6c4b249eba","last_name":"Durand","postal_code":"41018-3164","state_code":"KY","c_validateAddress":true},"shipping_method":{"_type":"shipping_method","description":"Ground shipping in the US","id":"Standard_US","name":"Standard US","c_estimatedArrivalTime":"3-5","c_isVisibleInStorefront":true,"c_storePickupEnabled":false},"shipping_status":"not_shipped","shipping_total":0.00,"shipping_total_tax":0.00,"tax_total":0.00}],"shipping_items":[{"_type":"shipping_item","adjusted_tax":0.00,"base_price":0.00,"item_id":"73bc37f71180f6595cd4e5dbe2","item_text":"Shipping","price":0.00,"price_after_item_discount":0.00,"shipment_id":"me","tax":0.00,"tax_basis":0.00,"tax_class_id":null,"tax_rate":0.0},{"_type":"shipping_item","adjusted_tax":0.00,"base_price":0.00,"item_id":"2ffaff597cc568bea32959b3c8","item_text":"FREE-By-CustomerGroup~Free Shipping for Specific Customers","price":0.00,"price_after_item_discount":0.00,"shipment_id":"me","tax":0.00,"tax_basis":0.00,"tax_class_id":null,"tax_rate":0.0}],"shipping_total":0.00,"shipping_total_tax":0.00,"taxation":"net","tax_total":0.00,"c_ATCustomsDuty":"0","c_ATTax":"0.0","c_ATTaxDetail":"[{\\"lineitemid\\":\\"GTBC-06-MM-ENG\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":0,\\"rate\\":0.06,\\"tax\\":0,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]},{\\"lineitemid\\":\\"me\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":0,\\"rate\\":0.06,\\"tax\\":0,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]},{\\"lineitemid\\":\\"me\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":0,\\"rate\\":0.06,\\"tax\\":0,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]}]"}';
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