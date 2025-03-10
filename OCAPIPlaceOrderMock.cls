/**
 * Created by jacob.fisher 
 * Created Date 8/20/2020.
 * Description:
 */

@IsTest
public with sharing class OCAPIPlaceOrderMock implements HttpCalloutMock {
        protected Integer code;
        protected String status;
        protected String body;

        public OCAPIPlaceOrderMock(Integer code) {
            this.code = code;
            if (code == 200) {
                this.status = 'OK';
                this.body = '{"_v":"20.8","_type":"order","_resource_state":"6136c288a9f60bf0f26fa919fc2dee66b0d7c4cada90001f638cd665a401e30e","adjusted_merchandize_total_tax":1.80,"adjusted_shipping_total_tax":0.60,"billing_address":{"_type":"order_address","address1":"128 Basswood Cir","city":"Ft Wright","company_name":"null","country_code":"US","first_name":"Test","full_name":"Test Test2","id":"af1fa63347d390bfe65f8f36e5","last_name":"Test2","postal_code":"41011-3711","state_code":"KY","c_validateAddress":true},"channel_type":"callcenter","confirmation_status":"confirmed","created_by":"jacob.fisher@dynamiccatholic.com","creation_date":"2020-08-20T21:17:12.817Z","currency":"USD","customer_info":{"_type":"customer_info","customer_id":"abKDaAdALByY4JKpnuSKkT1q9Z","customer_name":"Aida Jimenez","customer_no":"00007002","email":"rjime1416@zaol.com"},"customer_name":"Aida Jimenez","export_status":"ready","last_modified":"2020-08-20T21:17:13.791Z","merchandize_total_tax":1.80,"notes":{"_type":"simple_link","link":"https://staging.dynamiccatholic.com/s/dci_us/dw/shop/v20_8/orders/00001605/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"},"order_no":"00001605","order_token":"4gkjFa2ujJpQweg8im7Nl9GG5yV0eOOPPe5xkvN1oFY","order_total":42.40,"payment_instruments":[{"_type":"order_payment_instrument","amount":42.40,"payment_card":{"_type":"payment_card","card_type":"Visa","credit_card_expired":false,"credit_card_token":"AD557A3F2D581D6CE05341588E0AE11A","expiration_month":10,"expiration_year":2022,"holder":"Aida Jimenez","masked_number":"1111","number_last_digits":"1111"},"payment_instrument_id":"163f2a83f529035b660c7856bf","payment_method_id":"CREDIT_CARD"}],"payment_status":"not_paid","product_items":[{"_type":"product_item","adjusted_tax":1.80,"base_price":3.00,"bonus_product_line_item":false,"gift":false,"item_id":"690e261a4c8ab5bbe9747e5f06","item_text":"Rediscover the Saints","price":30.00,"price_after_item_discount":30.00,"price_after_order_discount":30.00,"product_id":"RSAI-NFR-MM-ENG","product_name":"Rediscover the Saints","quantity":10,"shipment_id":"me","shipping_item_id":"14771addc926ab19d8efbe9824","tax":1.80,"tax_basis":30.00,"tax_class_id":null,"tax_rate":0.060000000000000005}],"product_sub_total":30.00,"product_total":30.00,"shipments":[{"_type":"shipment","adjusted_merchandize_total_tax":1.80,"adjusted_shipping_total_tax":0.60,"gift":false,"merchandize_total_tax":1.80,"product_sub_total":30.00,"product_total":30.00,"shipment_id":"me","shipment_no":"00007005","shipment_total":42.40,"shipping_address":{"_type":"order_address","address1":"128 Basswood Cir","city":"Ft Wright","company_name":"null","country_code":"US","first_name":"Test","full_name":"Test Test2","id":"8e733c6c6acf0298ec1ac63013","last_name":"Test2","postal_code":"41011-3711","state_code":"KY","c_validateAddress":true},"shipping_method":{"_type":"shipping_method","description":"Ground shipping in the US","id":"Standard_US","name":"Standard US","price":0.00,"c_estimatedArrivalTime":"3-5","c_isVisibleInStorefront":true,"c_storePickupEnabled":false},"shipping_status":"not_shipped","shipping_total":10.00,"shipping_total_tax":0.60,"tax_total":2.40}],"shipping_items":[{"_type":"shipping_item","adjusted_tax":0.00,"base_price":10.00,"item_id":"14771addc926ab19d8efbe9824","item_text":"PBP-US~Parish Book Program - US","price":10.00,"price_after_item_discount":0.00,"shipment_id":"me","tax":0.00,"tax_basis":0.00,"tax_class_id":null,"tax_rate":0.0},{"_type":"shipping_item","adjusted_tax":0.60,"base_price":10.00,"item_id":"5e53e594d55a558aafd8159a03","item_text":"Shipping","price":10.00,"price_after_item_discount":10.00,"shipment_id":"me","tax":0.60,"tax_basis":10.00,"tax_class_id":null,"tax_rate":0.06}],"shipping_status":"not_shipped","shipping_total":10.00,"shipping_total_tax":0.60,"site_id":"dci_us","status":"new","taxation":"net","tax_total":2.40}';
            }else if(code == 404){
                this.status = 'Bad Request';
                this.body = '{"_v":"20.8","fault":{"arguments":{"basketId":"null"},"type":"BasketNotFoundException","message":"No basket with ID \'null\' could be found."}}';
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