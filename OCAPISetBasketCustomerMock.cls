/**
 * @author  Susan Durand
 * @date    12/19/2019
 * @description This class is the mock data for the OCAPISetBasketCustomer Api callout
 */

@IsTest
public with sharing class OCAPISetBasketCustomerMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String body;

    public OCAPISetBasketCustomerMock(Integer code){
        this.code = code;
        if(code==200){
            this.status = 'OK';
            this.body = '{' +
                            '"_v":"19.8",'+
                            '"_type":"basket",'+
                            '"_resource_state":"77abb7f14d0c7402676cad3d7263c44463cdcf1ca625fdf77646bedcf5de768b",'+
                            '"_flash":['+
                                '{'+
                                    '"_type":"flash",'+
                                    '"type":"ProductItemsRequired",'+
                                    '"message":"Product items are required.",'+
                                    '"path":"$.product_items"'+
                                '},'+
                                '{'+
                                    '"_type":"flash",'+
                                    '"type":"PaymentMethodRequired",'+
                                    '"message":"No payment method ID was specified. Please provide a valid payment method ID.",'+
                                    '"path":"$.payment_instruments[0].payment_method_id"'+
                                '},'+
                                '{'+
                                    '"_type":"flash",'+
                                    '"type":"BillingAddressRequired",'+
                                    '"message":"No billing address was specified. Please provide a valid billing address.",'+
                                    '"path":"$.billing_address"'+
                                '},'+
                                '{'+
                                    '"_type":"flash",'+
                                    '"type":"ShippingAddressRequired",'+
                                    '"message":"No shipping address was specified. Please provide a valid shipping address.",'+
                                    '"path":"$.shipments[0].shipping_address",'+
                                    '"details":{'+
                                        '"shipmentId":"me"'+
                                    '}'+
                                '},'+
                                '{'+
                                    '"_type":"flash",'+
                                    '"type":"ShippingMethodRequired",'+
                                    '"message":"No shipping method ID was specified. Please provide a valid shipping method ID.",'+
                                    '"path":"$.shipments[0].shipping_method",'+
                                    '"details":{'+
                                        '"shipmentId":"me"'+
                                    '}'+
                                '}'+
                            '],'+
                            '"adjusted_merchandize_total_tax":0.00,'+
                            '"adjusted_shipping_total_tax":0.00,'+
                            '"agent_basket":true,'+
                            '"basket_id":"d881e46f0edbbe02cf4bf0e9d2",'+
                            '"channel_type":"callcenter",'+
                            '"creation_date":"2019-12-19T21:22:20.522Z",'+
                            '"currency":"USD",'+
                            '"customer_info":{'+
                                '"_type":"customer_info",'+
                                '"customer_id":"abEAApkdCbq1JJ0SmVIt9fSe1w",'+
                                '"customer_no":"00014501",'+
                                '"email":"sdemail6@noemail.com"'+
                            '},'+
                            '"last_modified":"2019-12-19T21:22:20.629Z",'+
                            '"merchandize_total_tax":0.00,'+
                            '"notes":{'+
                                '"_type":"simple_link",'+
                                '"link":"https://dev05-na01-dynamiccatholicinstitute.demandware.net/s/DCI/dw/shop/v19_8/baskets/d881e46f0edbbe02cf4bf0e9d2/notes?client_id=5290d0c0-c881-4c02-ae90-53c94e69b8cf"'+
                            '},'+
                            '"order_total":0.00,'+
                            '"product_sub_total":0.00,'+
                            '"product_total":0.00,'+
                            '"shipments":['+
                                '{'+
                                    '"_type":"shipment",'+
                                    '"adjusted_merchandize_total_tax":0.00,'+
                                    '"adjusted_shipping_total_tax":0.00,'+
                                    '"gift":false,'+
                                    '"merchandize_total_tax":0.00,'+
                                    '"product_sub_total":0.00,'+
                                    '"product_total":0.00,'+
                                    '"shipment_id":"me",'+
                                    '"shipment_total":0.00,'+
                                    '"shipping_status":"not_shipped",'+
                                    '"shipping_total":0.00,'+
                                    '"shipping_total_tax":0.00,'+
                                    '"tax_total":0.00'+
                                '}'+
                            '],'+
                            '"shipping_items":['+
                                '{'+
                                    '"_type":"shipping_item",'+
                                    '"adjusted_tax":0.00,'+
                                    '"base_price":0.00,'+
                                    '"item_id":"52090226ae097e7d9ecf2fc862",'+
                                    '"item_text":"Shipping",'+
                                    '"price":0.00,'+
                                    '"price_after_item_discount":0.00,'+
                                    '"shipment_id":"me",'+
                                    '"tax":0.00,'+
                                    '"tax_basis":0.00,'+
                                    '"tax_class_id":"CustomRate",'+
                                    '"tax_rate":0.0'+
                                '}'+
                            '],'+
                            '"shipping_total":0.00,'+
                            '"shipping_total_tax":0.00,'+
                            '"taxation":"net",'+
                            '"tax_total":0.00'+
                        '}';
        }else{
            this.status = 'Bad Request';
            this.body = '{'+
                            '"_v":"19.8",'+
                            '"fault":{'+
                                '"arguments":{'+
                                    '"body":"{\\"customer_no\\":\\"00012508\\"\\"email\\":\\"sdemail5@noemail.com\\"}"'+
                                '},'+
                                '"type":"BodyDecodingException",'+
                                '"message":"An error occurred while decoding the request, the body was {\\"customer_no\\":\\"00012508\\"\\"email\\":\\"sdemail5@noemail.com\\"}."'+
                            '}'+
                        '}';
        }
    }

    public HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setBody(this.body);
        res.setHeader('Content-Type','application/json');
        res.setStatus(this.status);
        res.setStatusCode(this.code);
        return res;
    }

}