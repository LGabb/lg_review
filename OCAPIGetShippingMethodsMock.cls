/**
 * Name: Susan Durand
 * Date: 08/20/2019
 * Description: This class is the mock data for the OCAPIGetShippingMethods Api callout
 */

@IsTest
public with sharing class OCAPIGetShippingMethodsMock implements HttpCalloutMock{
    protected Integer code;
    protected String status;
    protected String body;


    /**
     * @description: Constructor method to set values for either a successful or failed mock api callout
     * @param code: Integer - the desired mock api response code, either 200 (success) or 400 (error)
     */
    public OCAPIGetShippingMethodsMock(Integer code){
        this.code = code;
        if(code==200){
            this.status = 'OK';
            this.body = '{"_v":"20.8","_type":"shipping_method_result","applicable_shipping_methods":[{"_type":"shipping_method","description":"Faster than ground shipping in the US","id":"Expedited_US","name":"Expedited US","c_estimatedArrivalTime":"1-2","c_isVisibleInStorefront":true,"c_storePickupEnabled":false},{"_type":"shipping_method","description":"Ground shipping in the US","id":"Standard_US","name":"Standard US","c_estimatedArrivalTime":"3-5","c_isVisibleInStorefront":true,"c_storePickupEnabled":false},{"_type":"shipping_method","description":"For orders with non-inventory items that are not shipped","id":"No_Ship","name":"No Shipping","c_isVisibleInStorefront":false,"c_storePickupEnabled":false}],"default_shipping_method_id":"Standard_US"}';
        }else if(code==400){
            this.status = 'Bad Request';
            this.body = '{"_v":"20.8","fault":{"arguments":{"accessToken":"123abc"},"type":"InvalidAccessTokenException","message":"The request is unauthorized, the access token is invalid."}}';
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