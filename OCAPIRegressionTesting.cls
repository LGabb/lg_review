/**
 * @author  Chris Eager
 * @date    11/8/2019
 * @description This class is used to test multiple scenarios for OCAPI to make sure we capture errors earlier in the process
 *              Processes this class tests:
 *              1. Creating a new customer
 *              2. Creating a new order for that customer
 *              3. Update the customer (email)
 *              4. Update order (to come)
 *              5. Add address to SFCC account and mark as preferred
*/

public with sharing class OCAPIRegressionTesting {
    /*
    * @description: Method handles getting the bearer token and then launching the batch
    */
    public static void startRegressionTest(){
        // get bearer token
        OCAPIData ocapiData = OCAPIAuthentication.processBearerToken()[0];
        if(ocapiData.bearerToken != null){
            // Call the batch class to hadnle the creation
            Database.executeBatch(new OCAPIRegressionTestingBatch(ocapiData.bearerToken), 1);
        }else{
            new CustomException('Error occurred while getting the bearer token.\n' + ocapiData.errorMsg);
        }
    }
}