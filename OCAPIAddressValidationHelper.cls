/**
 * @author Chris Eager
 * @date 4/6/2020
 * @description This class is used to handle the response from OCAPI that return the address JSON and makes it avaliable in the flow
 */

public with sharing class OCAPIAddressValidationHelper {

    /**
    * @description: This method parses an error returned from Avalara after validating and address and retunrs
     *                  the error message and suggested address
    * @param jsonInput - JSON error returned from Avalara
    * @return List<Result>: List of invocable Result objects
    */
    @InvocableMethod
    public static List<Result> tempMethod(List<Input> jsonInput){

        //List of Result objects to return
        List<Result> returnResults = new List<Result>();

        //Because this is an InvocableMethod, loop through input List
        for(input i : jsonInput){

            Result r = new Result();
            if(i.jsonResponse != null && i.jsonResponse != ''){

                //Parse the JSON error
                JSONParse addressParse = new JSONParse(i.jsonResponse);

                //Get the error message to be returned
                String avaError = addressParse.get('fault.arguments.statusMessage').toStringPretty();
                r.validationMessage = avaError;

                //Check if there is a suggested Validated Address in the error message
                if(addressParse.get('fault.arguments.statusDetails').toStringPretty().contains('"Avalara Validated Address"')){
                    //If there is an address, add it to Results to be returned to the flow
                    AvalaraAddress address = AvalaraAddress.parse(addressParse.get('fault.arguments.statusDetails.Avalara Validated Address').toStringPretty());
                    r.avalaraAddresses = address;
                }
            }
            returnResults.add(r);
        }
        return returnResults;
    }

    public class Input{
        //The JSON error returned from Avalara
        @InvocableVariable
        public String jsonResponse;
    }

    public class Result{
        //The specific error from Avalara
        @InvocableVariable
        public String validationMessage;

        //The suggested address from Avalara
        @InvocableVariable
        public AvalaraAddress avalaraAddresses;
    }
}