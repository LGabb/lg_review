/**
 * Created by jacob.fisher 
 * Created Date 12/12/2019.
 * Description:  Mock Data for OCAPIAuthentication test class.
 */

@IsTest
public with sharing class OCAPIAuthenticationMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String body;

    /*
    * @description: Constructor method to set values for either a successful or failed mock api callout
    * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
    */

    public OCAPIAuthenticationMock(Integer code) {
        this.code = code;
        if (code == 200) {
            this.status = 'OK';
            this.body = '{' +
                            '"expires_in":1799,' +
                            '"token_type":"Bearer",' +
                            '"access_token":"5294ed7a-18dd-4ce7-ab9e-3ecda4c54f28"' +
                        '}';
        }else if(code == 400){
            this.status = 'Bad Request';
            this.body = '{' +
                            '"error":"invalid_request",' +
                            '"error_description":"Required query parameter '+ 'grant_type' + 'missing."'+
                        '}';
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