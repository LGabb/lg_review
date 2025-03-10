/**
 * Created by jacob.fisher 
 * Created Date 8/6/2020.
 * Description:
 */

@IsTest
public with sharing class OCAPIAddNoteToOrderMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String body;

    /**
    * @description: Constructor method to set values for either a successful or failed mock api callout
    * @param code: Integer - the desired mock api response code, either 200 (success) or 404 (error)
    */
    public OCAPIAddNoteToOrderMock(Integer code){
        this.code = code;
        if(code == 200){
            this.status = 'OK';
            this.body = '{"_v":"20.4","_type":"order","_resource_state":"301cb4ea985c3da30ccda6c617795151fa5cafe63be303fc2f8f0b2700658deb","adjusted_merchandize_total_tax":1.80,"adjusted_shipping_total_tax":0.75,"billing_address":{"_type":"order_address","address1":"128 Basswood Cir","city":"Ft Wright","company_name":"null","country_code":"US","first_name":"Jacob","full_name":"Jacob Fisher","id":"fb9550fd55fee4e1180c380af1","last_name":"Fisher","postal_code":"41011-3711","state_code":"KY","c_validateAddress":true},"channel_type":"callcenter","confirmation_status":"confirmed","created_by":"jacob.fisher@dynamiccatholic.com","creation_date":"2020-08-06T20:19:11.917Z","currency":"USD","customer_info":{"_type":"customer_info","customer_id":"bc3LnGHYudl4zlI7cra6VW9Cej","customer_name":"Jacob Fisher28a","customer_no":"00020005","email":"jafisher28b@noemail.com"},"customer_name":"Jacob Fisher28a","export_status":"ready","last_modified":"2020-08-06T20:19:56.487Z","merchandize_total_tax":1.80,"notes":{"_type":"simple_link","link":"https://development.dynamiccatholic.com/s/dci_us/dw/shop/v20_4/orders/00008509/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"},"order_no":"00008509","order_token":"uorzPKyrErsebkAQLjKBBgVsPKMNplLR-1cKRJYP65Y","order_total":45.05,"payment_instruments":[{"_type":"order_payment_instrument","amount":45.05,"payment_card":{"_type":"payment_card","card_type":"Visa","credit_card_expired":true,"credit_card_token":"A84D84EB1D195BAEE05341588E0A95A0","expiration_month":10,"expiration_year":21},"payment_instrument_id":"fcb0392adf5e91136070a53182","payment_method_id":"CREDIT_CARD"}],"payment_status":"not_paid","product_items":[{"_type":"product_item","adjusted_tax":1.80,"base_price":3.00,"bonus_product_line_item":false,"gift":false,"item_id":"fd50615bfe326ff06b42389b99","item_text":"Rediscover the Saints","price":30.00,"price_after_item_discount":30.00,"price_after_order_discount":30.00,"product_id":"RSAI-NFR-MM-ENG","product_name":"Rediscover the Saints","quantity":10,"shipment_id":"me","shipping_item_id":"791621a1ae9f4c8229b2557142","tax":1.80,"tax_basis":30.00,"tax_class_id":null,"tax_rate":0.060000000000000005}],"product_sub_total":30.00,"product_total":30.00,"shipments":[{"_type":"shipment","adjusted_merchandize_total_tax":1.80,"adjusted_shipping_total_tax":0.75,"gift":false,"merchandize_total_tax":1.80,"product_sub_total":30.00,"product_total":30.00,"shipment_id":"me","shipment_no":"00042009","shipment_total":45.05,"shipping_address":{"_type":"order_address","address1":"128 Basswood Cir","city":"Ft Wright","company_name":"null","country_code":"US","first_name":"Jacob","full_name":"Jacob Fisher","id":"886c66e83f95677e17406e4acc","last_name":"Fisher","postal_code":"41011-3711","state_code":"KY","c_validateAddress":true},"shipping_method":{"_type":"shipping_method","description":"Ground shipping in the US","id":"Standard_US","name":"Standard","price":0.00,"c_estimatedArrivalTime":"3-5","c_isVisibleInStorefront":true,"c_storePickupEnabled":false},"shipping_status":"not_shipped","shipping_total":12.50,"shipping_total_tax":0.75,"tax_total":2.55}],"shipping_items":[{"_type":"shipping_item","adjusted_tax":0.00,"base_price":12.50,"item_id":"791621a1ae9f4c8229b2557142","item_text":"UNASGN-US-STD~Unassigned - US, Standard","price":12.50,"price_after_item_discount":0.00,"shipment_id":"me","tax":0.00,"tax_basis":0.00,"tax_class_id":null,"tax_rate":0.0},{"_type":"shipping_item","adjusted_tax":0.75,"base_price":12.50,"item_id":"528b27e898fbcb57f673d4ac63","item_text":"Shipping","price":12.50,"price_after_item_discount":12.50,"shipment_id":"me","tax":0.75,"tax_basis":12.50,"tax_class_id":null,"tax_rate":0.06}],"shipping_status":"not_shipped","shipping_total":12.50,"shipping_total_tax":0.75,"site_id":"dci_us","status":"new","taxation":"net","tax_total":2.55,"c_ATCustomsDuty":"0","c_ATTax":"2.55","c_ATTaxDetail":"[{\\"lineitemid\\":\\"RSAI-NFR-MM-ENG\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":30,\\"rate\\":0.06,\\"tax\\":1.8,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]},{\\"lineitemid\\":\\"me\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":0,\\"rate\\":0.06,\\"tax\\":0,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]},{\\"lineitemid\\":\\"me\\",\\"shipmentid\\":\\"me\\",\\"taxes\\":[{\\"jurisdictiontype\\":\\"State\\",\\"jurisdiction\\":\\"KENTUCKY\\",\\"exempt\\":0,\\"nontaxable\\":0,\\"taxable\\":12.5,\\"rate\\":0.06,\\"tax\\":0.75,\\"taxName\\":\\"KY STATE TAX\\",\\"taxSubTypeId\\":\\"S\\",\\"taxType\\":\\"Sales\\"}]}]","c_orderType":"ocapi-credit"}';
        }else if(code == 404){
            //You get this error if it cant find the order number that was passed in.
            this.status = 'Bad Request';
            this.body = '{"_v":"20.4","fault":{"arguments":{"orderNumber":"aaaaaaaaaaaaaaaa"},"type":"OrderNotFoundException","message":"No order with number \'aaaaaaaaaaaaaaaa\' was found."}}';
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
        res.setStatus(this.status);
        res.setStatusCode(this.code);
        return res;
    }

}