/**
 * @author  Susan Durand
 * @date    08/14/2020
 * @description This class is the mock data for the OCAPISetShippingMethod Api callout
 */

@IsTest
public with sharing class OCAPISetShippingMethodMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String body;


    /**
     * @description: Constructor method to set values for either a successful or failed mock api callout
     * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
     */
    public OCAPISetShippingMethodMock(Integer code){
        this.code = code;
        if(code==200){
            this.status = 'OK';
            this.body = '{"_v":"20.4","_type":"basket","_resource_state":"d48b34804cad931589edbc9cf22208b430bf717621eb5822b1f67cf396b97ef5","_flash":[{"_type":"flash","type":"PaymentMethodRequired","message":"No payment method ID was specified. Please provide a valid payment method ID.","path":"$.payment_instruments[0].payment_method_id"}],"adjusted_merchandize_total_tax":1.08,"adjusted_shipping_total_tax":0.07,"agent_basket":true,"basket_id":"b850df75c3ef8e30799e148afd","billing_address":{"_type":"order_address","address1":"12 Main St","city":"Elsmere","company_name":"null","country_code":"US","first_name":"Susan","full_name":"Susan Durand","id":"cb6c5590fc17f6fb75f8c2bfb0","last_name":"Durand","postal_code":"41018","state_code":"KY","c_validateAddress":true},"channel_type":"callcenter","creation_date":"2020-08-14T17:54:10.365Z","currency":"USD","customer_info":{"_type":"customer_info","customer_id":"acNa87V9soQRuucNa2PClF1nRA","customer_no":"00036503","email":"skipship1@noemail.com"},"last_modified":"2020-08-14T17:55:20.688Z","merchandize_total_tax":1.08,"notes":{"_type":"simple_link","link":"https://development.dynamiccatholic.com/s/dci_us/dw/shop/v20_4/baskets/b850df75c3ef8e30799e148afd/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"},"order_total":20.35,"product_items":[{"_type":"product_item","adjusted_tax":1.08,"base_price":17.95,"bonus_product_line_item":false,"gift":false,"item_id":"ce691dc1b83c735bd829e3b7da","item_text":"1001 Reasons Why It\'s Great to Be Catholic","price":17.95,"price_after_item_discount":17.95,"price_after_order_discount":17.95,"product_id":"GTBC-06-MM-ENG","product_name":"1001 Reasons Why It\'s Great to Be Catholic","quantity":1,"shipment_id":"me","shipping_item_id":"62fc8e189b1fb7abb9e9e92453","tax":1.08,"tax_basis":17.95,"tax_class_id":null,"tax_rate":0.06016713091922006}],"product_sub_total":17.95,"product_total":17.95,"shipments":[{"_type":"shipment","adjusted_merchandize_total_tax":1.08,"adjusted_shipping_total_tax":0.07,"gift":false,"merchandize_total_tax":1.08,"product_sub_total":17.95,"product_total":17.95,"shipment_id":"me","shipment_total":20.35,"shipping_address":{"_type":"order_address","address1":"12 Main St","city":"Elsmere","company_name":"null","country_code":"US","first_name":"Susan","full_name":"Susan Durand","id":"cb6c5590fc17f6fb75f8c2bfb0","last_name":"Durand","postal_code":"41018","state_code":"KY","c_validateAddress":true},"shipping_method":{"_type":"shipping_method","description":"Ground shipping in the US","id":"Standard_US","name":"Standard","price":0.00,"c_estimatedArrivalTime":"3-5","c_isVisibleInStorefront":true,"c_storePickupEnabled":false},"shipping_status":"not_shipped","shipping_total":1.25,"shipping_total_tax":0.07,"tax_total":1.15}],"shipping_items":[{"_type":"shipping_item","adjusted_tax":0.07,"base_price":1.25,"item_id":"c594b911cbbe3b99ad4751087e","item_text":"Shipping","price":1.25,"price_after_item_discount":1.25,"shipment_id":"me","tax":0.07,"tax_basis":1.25,"tax_class_id":null,"tax_rate":0.05600000000000001},{"_type":"shipping_item","adjusted_tax":0.00,"base_price":1.25,"item_id":"62fc8e189b1fb7abb9e9e92453","item_text":"UNASGN-US-STD~Unassigned - US, Standard","price":1.25,"price_after_item_discount":0.00,"shipment_id":"me","tax":0.00,"tax_basis":0.00,"tax_class_id":null,"tax_rate":0.0}],"shipping_total":1.25,"shipping_total_tax":0.07,"taxation":"net","tax_total":1.15,"c_ATCustomsDuty":"0","c_ATTax":"1.15","c_ATTaxDetail":"[{\\"lineitemid\\":\\"GTBC-06-MM-ENG\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":17.95,\\"rate\\":0.06,\\"tax\\":1.08,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]},{\\"lineitemid\\":\\"me\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":0,\\"rate\\":0.06,\\"tax\\":0,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]},{\\"lineitemid\\":\\"me\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":1.25,\\"rate\\":0.06,\\"tax\\":0.07,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]}]"}';
        }else if(code==400){
            this.status = 'Bad Request';
            this.body = '{"_v":"20.4","fault":{"arguments":{"shippingMethodId":"NotRealShippingMethod"},"type":"InvalidShippingMethodIdException","message":"The shipping method with ID \'NotRealShippingMethod\' is unknown or can\'t be applied to the basket."}}';
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