/*
 * Created by jacob.fisher 
 * Created Date 4/20/2020.
 * Description: Mock callout for resetting Customer Password
 */

@IsTest
public with sharing class OCAPIResetCustomerPasswordMock implements HttpCalloutMock{
    protected Integer code;
    protected String status;
    protected String body;

    public OCAPIResetCustomerPasswordMock(Integer code) {
        this.code = code;
        if (code == 204) {
            this.status = 'OK';
            this.body = '{}';
        }else if(code == 400){
            this.status = 'Bad Request';
            this.body = '{"_v":"20.3","fault":{"arguments":{"method":"POST"},"type":"MethodNotAllowedException","message":"Method \'POST\' isn\'t allowed."}}';
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