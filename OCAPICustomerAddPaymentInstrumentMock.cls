/**
 * @author  Susan Durand
 * @date    05/05/2020
 * @description This class is the mock data for the OCAPICustomerAddPaymentInstrument Api callout
 */

@IsTest
public with sharing class OCAPICustomerAddPaymentInstrumentMock implements HttpCalloutMock{
    protected Integer code;
    protected String status;
    protected String body;

    /**
    * @description: Constructor method to set values for either a successful or failed mock api callout
    * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
    */
    public OCAPICustomerAddPaymentInstrumentMock(Integer code){
        this.code = code;
        if(code == 200){
            this.status = 'OK';
            this.body = '{"_v":"20.3","_type":"customer_payment_instrument","creation_date":"2020-05-05T20:28:09.243Z","last_modified":"2020-05-05T20:28:09.245Z","payment_bank_account":{"_type":"payment_bank_account"},"payment_card":{"_type":"payment_card","card_type":"Visa","credit_card_expired":false,"expiration_month":12,"expiration_year":2021,"holder":"Susan Durand","masked_number":"1111","number_last_digits":"1111"},"payment_instrument_id":"cf4f9c3149eb8aed05b9f2c075"}';
        }else if(code == 400){
            this.status = 'Bad Request';
            this.body = '{"_v":"20.4","fault":{"type":"InvalidVersionException","message":"The version is missing or malformed in the request URL. Please provide a valid version like \'v16_1\'."}}';
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