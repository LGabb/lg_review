/**
 * @author  Chris Eager
 * @date    9/9/2019
 * @description This class handles all methods and error handling associated with OCAPI requests
 *              8/19/2024 - KD-1849 Updated to use new Named Credentials - Susan Durand
*/

public with sharing class OCAPICalloutHandler {
    /**
    * @description This method is used to get the bearer token and Authenticate into SFCC. It leverages the setEndpoint
        method to get the bearer token to be used later on
    * @return HttpRequest - this can be used to make the POST call for the Authentication
    */
    public static HttpRequest setAuthEndpoint(){
        return setEndpoint('Auth', null, null);
    }

    /**
    * @description This method is used for SHOP api callouts
    * @param urlResource - resource used for the api call
    * @param bearerToken - bearer token for the user for the callout - passed from flow
    * @return HttpRequest - this can be used to make the POST call for the SHOP api callouts
    */
    public static HttpRequest setShopEndpoint(String urlResource, String bearerToken){
        return setEndpoint('Shop', urlResource, bearerToken);
    }

    /**
    * @description This method is used for DATA api callouts
    * @param urlResource - resource used for the api call
    * @param bearerToken - bearer token for the user for the callout - passed from flow
    * @return HttpRequest - this can be used to make the POST call for the DATA api callouts
    */
    public static HttpRequest setDataEndpoint(String urlResource, String bearerToken){
        return setEndpoint('Data', urlResource, bearerToken);
    }

    /**
    * @description This method sets the endpoint for the request based on the named credential
    * @param callType - What type of request it is. - Auth, Shop, Data
    * @param urlResource - Resource we want to call from
    * @param bearerToken - Bearer token generated from Auth callout. This will come from the flow.
    * @return HttpRequest - this is used to get the bearer token for future callouts
    */
    public static HttpRequest setEndpoint(String callType, String urlResource, String bearerToken){
        // Client Id gets placed on the end of every callout - so need to get it form the custom setting
        String clientId = SFCC_Integration_Creds__c.getOrgDefaults().Client_Id__c;

        if(clientId != null){
            HttpRequest req = new HttpRequest();
            // Handles Auth to get bearer token
            if(callType == 'Auth'){
                req.setEndpoint('callout:OCAPI_Auth/oauth2/access_token?client_id=' + clientId);
                req.setHeader('Content-Type','application/x-www-form-urlencoded');
                return req;
            }

            // Handles Shop and Data - these will not need an auth since it can be constructed in the header
            if(callType == 'Shop'){
                //8/19/24 - Updated the Named Credential from OCAPI_Shop to OCAPI_DCI_Shop
                req.setEndpoint('callout:OCAPI_DCI_Shop' + urlResource + (urlResource.contains('?') ? '&' : '?') + 'client_id=' + clientId);
            }else if(callType == 'Data'){

            }

            req.setHeader('Authorization', 'Bearer ' + bearerToken);
            req.setHeader('Content-Type', 'application/json');

            return req;
        }

        // Handle error if the client Id is not found -- Most likely from an org refresh
        throw new CustomException('Error: No Client Id was found for custom setting SFCC Integration Creds.\n' +
                'Please update the Client Id field with the correct Client Id from Commerce Cloud.');
    }

    /**
    *   @description This method processes a Post call for OCAPI
    *   @param request - this is the request with the authorization and content-type already set
    *   @param body - this is the body string that will be set in the request
    *   @return HttpResponse
    */
    public static HttpResponse POSTCallout(HttpRequest request, String body) {
        Http http = new Http();
        request.setTimeout(31000);
        request.setMethod('POST');

        if(body != null) {
            request.setBody(body);
        }

        // Handle sending request and any errors that might come up
        HttpResponse response = http.send(request);

        //Send error to salesforce of what went wrong with the call out.
        if((response.getStatusCode() < 200) || (response.getStatusCode() >= 300)){
            ErrorHandling.SendError(request,response);
        }

        return response;
    }

    /**
    *   @description This method processes a Get call for OCAPI
    *   @param request - this is the request with the authorization and content-type already
    *   @param body - this is the body string that should be set in the request
    *   @return HttpResponse
    */
    public static HttpResponse GETCallout(HttpRequest request, String body) {
        Http http = new Http();

        request.setMethod('GET');

        if(body != null) {
            request.setBody(body);
        }

        // Handle sending request and any errors that might come up
        HttpResponse response = http.send(request);

        //Send error to salesforce of what went wrong with the call out.
        if((response.getStatusCode() < 200) || (response.getStatusCode() >= 300)) {
            ErrorHandling.SendError(request, response);
        }

        return response;
    }

    /**
    *   @description This method processes a Patch call for OCAPI
    *   @param request - this is the request with the authorization and content-type already
    *   @param body - this is the body string that should be set in the request
    *   @return HttpResponse
    */
    public static HttpResponse PATCHRequest(HttpRequest request, String body) {
        Http http = new Http();

        request.setMethod('POST');
        request.setHeader('x-dw-http-method-override','PATCH');

        if(body != null) {
            request.setBody(body);
        }

        // Handle sending request and any errors that might come up
        HttpResponse response = http.send(request);

        //Send error to salesforce of what went wrong with the call out.
        if((response.getStatusCode() < 200) || (response.getStatusCode() >= 300)) {
            ErrorHandling.SendError(request, response);
        }

        return response;
    }

    /**
*   @description This method processes a Put call for OCAPI
*   @param request - this is the request with the authorization and content-type already
*   @param body - this is the body string that should be set in the request
*   @return HttpResponse
*/
    public static HttpResponse PUTRequest(HttpRequest request, String body) {
        Http http = new Http();

        request.setMethod('PUT');

        if(body != null) {
            request.setBody(body);
        }

        // Handle sending request and any errors that might come up
        HttpResponse response = http.send(request);

        //Send error to salesforce of what went wrong with the call out.
        if((response.getStatusCode() < 200) || (response.getStatusCode() >= 300)) {
            ErrorHandling.SendError(request, response);
        }

        return response;
    }

    /**
    *   @description This method processes a Delete call for OCAPI
    *   @param request - this is the request with the authorization and content-type already
    *   @param body - this is the body string that should be set in the request
    *   @return HttpResponse
    */
    public static HttpResponse DELETECallout(HttpRequest request, String body) {
        Http http = new Http();

        request.setMethod('DELETE');

        if(body != null) {
            request.setBody(body);
        }

        // Handle sending request and any errors that might come up
        HttpResponse response = http.send(request);

        //Send error to salesforce of what went wrong with the call out.
        if((response.getStatusCode() < 200) || (response.getStatusCode() >= 300)) {
            ErrorHandling.SendError(request, response);
        }

        return response;
    }

    /**
    *   @description This method gets the error message from an OCAPI fault message
    *   @param resBody - this is the response body
    *   @return String - this is the error message that must be created
    */
    public static String getErrorMessage(String resBody){
        Map<String, Object> o = (Map<String, Object>) JSON.deserializeUntyped(resBody);
        Map<String, Object> f = (Map<String, Object>) o.get('fault');
        String errMsg = String.valueOf(f.get('message'));
        return errMsg;
    }

    /**
    *   @description This method checks if the error is the result of HookStatusException
    *   @param resBody - this is the response body
    *   @return String - this is true if the error was from a Hook
    */
    public static Boolean checkHookStatusException(String resBody){
        JSONParse errorMessage = new JSONParse(resBody);
        Boolean isHookStatusException = errorMessage.get('fault.type').toStringPretty() == '"HookStatusException"';
        return isHookStatusException;
    }
}