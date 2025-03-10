/**
 * Name: Susan Durand
 * Date: 08/20/2019
 * Description: This class is the mock data for the OCAPICalloutHandler Api callout
 */

@IsTest
public with sharing class OCAPICalloutHandlerMock implements HttpCalloutMock{
    protected Integer code;
    protected String status;
    protected String body;


    /**
     * @description: Constructor method to set values for either a successful or failed mock api callout
     * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
     */
    public OCAPICalloutHandlerMock(Integer code){
        this.code = code;
        if(code==200){
            this.status = 'OK';
            this.body = '{"_v":"20.8","_type":"customer","_resource_state":"bacfbfdae45bb42262189fa16a59edc46cf852a02762e7069dbe59484b7ce94a","auth_type":"registered","creation_date":"2020-08-13T15:58:28.000Z","customer_id":"abNqrdgLmbqREiqjriq46qFWGq","customer_no":"00005501","email":"testsd@noemail.com","enabled":true,"first_name":"TestFirst","last_modified":"2020-08-20T14:51:17.045Z","last_name":"TestLast","login":"testsd@noemail.com","phone_home":"1111111111","c_inParishGroup":false}';
        }else if(code==400){
            this.status = 'Bad Request';
            this.body = '{"_v":"20.8","fault":{"arguments":{"email":"testErrorEmail"},"type":"InvalidEmailException","message":"The profile email address \'testErrorEmail\' isn\'t valid."}}';
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