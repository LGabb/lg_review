/**
 * @author  Chris Eager
 * @date    9/6/2019
 * @description Class that handles the bearer token for OCAPI calls from CRM.
*/

global class OCAPIAuthentication {
    /*
    * @description This method handles the retrieving of a bearer token when processing things in OCAPI
    * @return List<String> - The bearer token
    */
    @InvocableMethod
    public static List<OCAPIData> processBearerToken(){

        // Bearer tokens are stored as custom settings for each user - first step is to return the existing token
        //OCAPI_Bearer_Token__c customSetting = OCAPI_Bearer_Token__c.getInstance();

        //This is the variable to be returned by the method
        OCAPIData returnVar = new OCAPIData();
        // If token does not exist then retrieve a new one
        ReturnedResponse rr = getBearerTokenForUser();
        // KD-1370 JWT Access Tokens - Removed Logic Around Custom Settings - JF 5.30.23
        //Datetime currentTime = Datetime.now();

        Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(rr.jsonString);

        if(rr.msg == 'SUCCESS'){
            // KD-1370 JWT Access Tokens - Removed Logic Around Custom Settings - JF 5.30.23
            // Create/Update custom setting with new information
            //customSetting = (customSetting == null) ? new OCAPI_Bearer_Token__c(SetupOwnerId = UserInfo.getUserId()): customSetting;


            //customSetting.Bearer_Token__c = String.valueOf(responseMap.get('access_token'));
            //Integer expiresSec = Integer.valueOf(responseMap.get('expires_in'));
            //customSetting.Token_Expiration__c = currentTime.addSeconds(expiresSec);

            //customMetadata.Bearer_Token__c = String.valueOf(responseMap.get('access_token'));
            //customMetadata.Token_Expiration__c = currentTime.addSeconds(expiresSec);

            try{
                // KD-1370 JWT Access Tokens - Removed Logic Around Custom Settings - JF 5.30.23
                //upsert customSetting;
                returnVar.bearerToken = String.valueOf(responseMap.get('access_token'));
            }catch (Exception e){
                returnVar.errorMsg = 'Error: Please contact your admin.\nError description: error storing bearer token. ' + e.getMessage();
            }

        }else{
            // Construct error message to be displayed in the flow
            returnVar.errorMsg = rr.msg + ': Please contact your admin.\nError description: ' + String.valueOf(responseMap.get('error_description'));
        }
        return new List<OCAPIData>{returnVar};

    }

    /*
    * This class is used to return the information returned from the API callout to OCAPI for the basket
    */
    public class ReturnedResponse {
        public String msg;
        public String jsonString;

        ReturnedResponse(){}
    }

    /*
    * @description This method gets the bearer token for the user
    * @return ReturnedResponse - this contains a message and the returned JSON
    */
    public static ReturnedResponse getBearerTokenForUser(){
        HttpRequest request = OCAPICalloutHandler.setAuthEndpoint();
        String body = 'grant_type=urn:demandware:params:oauth:grant-type:client-id:dwsid:dwsecuretoken';

        HttpResponse response = OCAPICalloutHandler.POSTCallout(request, body);

        ReturnedResponse rr = new ReturnedResponse();

        if(response.getStatusCode() != 200){
            rr.msg = 'ERROR';
            rr.jsonString = response.getBody();
        }else{
            // Success and do stuff
            rr.msg = 'SUCCESS';
            rr.jsonString = response.getBody();
        }

        return rr;
    }
}