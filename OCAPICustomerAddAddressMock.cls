/**
 * Created by jacob.fisher 
 * Created Date 8/6/2020.
 * Description: Mock api call for OCAPICustomerAddAddress
 */

@IsTest
public with sharing class OCAPICustomerAddAddressMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String body;

    /**
    * @description: Constructor method to set values for either a successful or failed mock api callout
    * @param code: Integer - the desired mock api response code, either 200 (success) or 404 (error)
    */
    public OCAPICustomerAddAddressMock(Integer code){
        this.code = code;
        if(code == 200){
            this.status = 'OK';
            this.body = '{"_v":"20.4","_type":"customer_address","_resource_state":"ed4a3513451dae746a5b7da60e042c51e7080ad9ac47f916cb477809d3956351","address1":"128 Basswood Cir","address_id":"thest8","city":"Ft Wright","company_name":"null","country_code":"US","creation_date":"2020-08-06T21:10:15.496Z","first_name":"Jacob","full_name":"Jacob Fisher","last_modified":"2020-08-06T21:10:15.497Z","last_name":"Fisher","phone":"1234567890","postal_code":"41011","preferred":false,"state_code":"KY"}';
        }else if(code == 404){
            //You get this error if it cant find the customer number that was passed in.
            this.status = 'Bad Request';
            this.body = '{"_v":"20.4","fault":{"arguments":{"customerId":"111111111111"},"type":"CustomerNotFoundException","message":"No customer with ID \'111111111111\' could be found."}}';
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