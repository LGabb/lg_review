/**
 * @author  Susan Durand
 * @date    10/28/2019
 * @description This class is the mock data for the OCAPICustomerCreation Api callout
 */

@IsTest
public with sharing class OCAPICustomerCreationMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String body;


    /**
     * @description: Constructor method to set values for either a successful or failed mock api callout
     * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
     */
    public OCAPICustomerCreationMock(Integer code){
        this.code = code;
        if(code==200){
            this.status = 'OK';
            this.body = '{' +
                            '"_v":"19.8",' +
                            '"_type":"customer",' +
                            '"_resource_state":"acdde609d60825c56446ef1fe554e3bcad9b5efac2151799294c47f14226cf7b",' +
                            '"auth_type":"registered",' +
                            '"creation_date":"2019-10-29T13:03:11.160Z",' +
                            '"customer_id":"abFyPc4IVBHQmfPfePYk7oozvu",' +
                            '"customer_no":"00005502",' +
                            '"email":"rmaccorley8@wordpress.com",' +
                            '"enabled":true,' +
                            '"first_name":"Riobard",' +
                            '"last_modified":"2019-10-29T13:03:11.161Z",' +
                            '"last_name":"MacCorley",' +
                            '"login":"rmaccorley8@wordpress.com"' +
                        '}';
        }else if(code==400){
                this.status = 'Bad Request';
                this.body = '{' +
                                '"_v":"19.8",' +
                                '"fault":{"' +
                                    'type":"LoginAlreadyInUseException",' +
                                    '"message":"The login is already in use."' +
                                '}' +
                            '}';
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