/**
 * @author  Chris Eager
 * @date    11/8/2019
 * @description This class does a regression test of different scenarios for different callout that we do in SF.
 *              This will serve as a way for us to make sure updates to Commerce Cloud will not break the OCAPI Integration
 *                  from a backend perspective
*/

global class OCAPIRegressionTestingBatch implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts{
    // bearer token so we can process the requests
    global String bearerToken;

    /*
   * @description: This method passes the bearer token to the batch class
   * @param bearerToken - token passed in from initial class so we can do the callouts
   */
    global OCAPIRegressionTestingBatch(String bearerToken){
        this.bearerToken = bearerToken;
    }

    /*
   * @description: This method starts the batch class
   * @param bc
   * @return Database.QueryLocator
   */
    global Database.QueryLocator start(Database.BatchableContext bc){
        String runningUser = UserInfo.getUserId();
        return Database.getQueryLocator('SELECT Id FROM User WHERE Id = \'' + runningUser + '\'');
    }

    /*
   * @description: This method processes the batch class
   * @param bc
   * @param scope - returned from query
   */
    global void execute(Database.BatchableContext bc, List<SObject> scope){
        Integer randomNum = Crypto.getRandomInteger();
        if(randomNum < 0){
            randomNum = randomNum * -1;
        }

        // Create order for new customer
        OCAPIData ocapi = new OCAPIData();
        ocapi.bearerToken = bearerToken;
        // Create new customer
        Web_Profile__c wp = new Web_Profile__c();
        wp.First_Name__c = 'CRM Regression';
        wp.Last_Name__c = 'CRM Regression' + randomNum;
        wp.Email__c = 'crmregressiontest' + randomNum + '@dynamiccatholic.com';
        ocapi.profile = wp;

        processOrderNewCustomer(ocapi);

        // Create order for existing customer
        OCAPIData ocapiExisting = new OCAPIData();
        ocapiExisting.profile = ocapi.profile;
        ocapiExisting.bearerToken = ocapi.bearerToken;

        processOrderExistingCustomer(ocapiExisting);

        updateCustomer(ocapi);

    }

    /*
   * @description: This method runs on finish on the batch class
   * @param bc
   */
    global void finish(Database.BatchableContext bc){
        // Might need to call another batch at some point
    }

    /*
   * @description: This method runs logic to create a new customer and order for that customer
   * @param ocapi - data used to track all the updates throughout the process
   */
    private static void processOrderNewCustomer(OCAPIData ocapi){
        ocapi = OCAPICustomerCreation.createCustomer(new List<OCAPIData>{ocapi})[0];
        checkForError(ocapi);

        if(ocapi.profile.Customer_Num__c == null){
            throw new CustomException('Error: customer num was not set on web profile.');
        }

        basketInit(ocapi);

        // add products to basket
        addProducts(ocapi);


        setBilling(ocapi, true);

        // get shipping method
        ocapi = OCAPIGetShippingMethods.getShippingMethods(new List<OCAPIData>{ocapi})[0];
        checkForError(ocapi);

        if(ocapi.availableShippingMethods == null){
            throw new CustomException('Error: shipping methods not set');
        }

        setShipMethod(ocapi);

        // set payment -- can do a payment method at some point
        ocapi.cardType = 'Visa';
        ocapi.paymentToken = '123abc456def';
        ocapi.totalAmount = '15.76';
        ocapi.paymentMethod = 'CREDIT_CARD';

        ocapi = OCAPIAddPaymentInstrument.addPaymentInstrument(new List<OCAPIData>{ocapi})[0];
        checkForError(ocapi);

        placeOrder(ocapi);
    }

    /*
   * @description: This method creates an order for an existing customer
   * @param ocapiExisting - data used to track changes throughout the process
   */
    private static void processOrderExistingCustomer(OCAPIData ocapiExisting){
        // Add customer to basket and create a new basket
        basketInit(ocapiExisting);

        // Add products to basket
        addProducts(ocapiExisting);

        // Add billing address
        setBilling(ocapiExisting, false);

        // Add shipping address
        setShipping(ocapiExisting);

        setShipMethod(ocapiExisting);

        // set payment -- can do a payment method at some point
        ocapiExisting.cardType = 'Visa';
        ocapiExisting.paymentToken = '123abc456def';
        ocapiExisting.totalAmount = '15.76';
        ocapiExisting.paymentMethod = 'CREDIT_CARD';

        ocapiExisting = OCAPIAddPaymentInstrument.addPaymentInstrument(new List<OCAPIData>{ocapiExisting})[0];
        checkForError(ocapiExisting);

        placeOrder(ocapiExisting);
    }

    /*
   * @description: This method checks to see if there was an error returned
   * @param ocapi - data used to track changes throughout the process
   */
    private static void checkForError(OCAPIData ocapi){
        if(!String.isBlank(ocapi.errorMsg)){
            throw new CustomException('Error trying to perform the regression test.\n' + ocapi.errorMsg);
        }
    }

    /*
   * @description: This method creates a new basket and adds the customer to the basket
   * @param ocapiExisting - data used to track changes throughout the process
   */
    private static void basketInit(OCAPIData ocapi){
        // create basket
        ocapi = OCAPIBasketCreate.createBasket(new List<OCAPIData>{ocapi})[0];
        checkForError(ocapi);

        if(ocapi.basketId == null || ocapi.shipmentId == null){
            throw new CustomException('Error: basket id or shipping id was not set when it was expected.');
        }

        // add customer to basket
        ocapi = OCAPISetBasketCustomer.setBasketCustomer(new List<OCAPIData>{ocapi})[0];
        checkForError(ocapi);

    }

    /*
   * @description: This method adds products to the basket
   * @param ocapiExisting - data used to track changes throughout the process
   * TODO: update to make the PricebookEntry query not look at a particular Master Product
   */
    private static void addProducts(OCAPIData ocapi){
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        Integer i = 1;
        for(PricebookEntry pbe : [SELECT Id, ProductCode FROM PricebookEntry WHERE IsActive = TRUE AND Product2.Master_Product__c = '01tR0000005Zu5dIAC' LIMIT 3]){
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.SKU__c = pbe.ProductCode;
            oli.Quantity = i;
            oliList.add(oli);
            i++;
        }

        ocapi.lineItemJSON = JSON.serialize(oliList);
        ocapi = OCAPIAddItemToBasket.addItemToBasket(new List<OCAPIData>{ocapi})[0];
        checkForError(ocapi);

        for(OpportunityLineItem oli : ocapi.lineItems){
            if(oli.TotalPrice == null || oli.Quantity == null || oli.Tax_Amount__c == null){
                throw new CustomException('Error: expected OLI to have price, quantity, and tax amount filled in.');
            }
        }
    }

    /*
   * @description: This method sets the billing address on the basket
   * @param ocapiExisting - data used to track changes throughout the process
   * @param sameAsShip - identifies if the billing address is the same as the shipping
   */
    private static void setBilling(OCAPIData ocapi, Boolean sameAsShip){
        // set address (billing same as shipping)
        ocapi.sameBillAndShipAddress = sameAsShip;
        ocapi.BillingAddress.First_Name__c = ocapi.profile.First_Name__c;
        ocapi.BillingAddress.Last_Name__c = ocapi.profile.Last_Name__c;
        ocapi.BillingAddress.Address_1__c = '5081 Olympic Blvd';
        ocapi.BillingAddress.Address_2__c = 'Peahen Suite';
        ocapi.BillingAddress.City__c = 'Erlanger';
        ocapi.BillingAddress.State__c = 'KY';
        ocapi.BillingAddress.ZIP_Code__c = '41018';
        ocapi.BillingAddress.Country__c = 'US';

        ocapi = OCAPIAddBillAddressToBasket.addBillAddressToBasket(new List<OCAPIData>{ocapi})[0];
        checkForError(ocapi);
    }

    /*
   * @description: This method adds the shipping address to the basket
   * @param ocapiExisting - data used to track changes throughout the process
   */
    private static void setShipping(OCAPIData ocapi){
        ocapi.ShippingAddress.First_Name__c = ocapi.profile.First_Name__c;
        ocapi.ShippingAddress.Last_Name__c = ocapi.profile.Last_Name__c;
        ocapi.ShippingAddress.Address_1__c = '13280 Chapman Ave';
        ocapi.ShippingAddress.Address_2__c = 'Tower of Hope - 9th Floor';
        ocapi.ShippingAddress.City__c = 'Garden Grove';
        ocapi.ShippingAddress.State__c = 'CA';
        ocapi.ShippingAddress.ZIP_Code__c = '982840';
        ocapi.ShippingAddress.Country__c = 'US';

        ocapi = OCAPIAddShipAddressToBasket.addShipAddressToBasket(new List<OCAPIData>{ocapi})[0];
        checkForError(ocapi);
    }

    /*
   * @description: This method sets the shipping method for the basket and defaults it to ground
   * @param ocapiExisting - data used to track changes throughout the process
   */
    private static void setShipMethod(OCAPIData ocapi){
        Shipping_Method__mdt sm = [SELECT SFCC_Id__c FROM Shipping_Method__mdt WHERE Enabled__c = TRUE AND DeveloperName = 'Ground'];
        ocapi.shippingMethodId = sm.SFCC_Id__c;

        ocapi = OCAPISetShippingMethod.setShippingMethod(new List<OCAPIData>{ocapi})[0];
        checkForError(ocapi);
    }

    /*
   * @description: This method handles placing the order in SFCC
   * @param ocapiExisting - data used to track changes throughout the process
   */
    private static void placeOrder(OCAPIData ocapi){
        ocapi = OCAPIPlaceOrder.placeOrder(new List<OCAPIData>{ocapi})[0];
        checkForError(ocapi);

        if(String.isBlank(ocapi.orderNumber) || String.isBlank(ocapi.orderResponseJSON)){
            throw new CustomException('Error: When placing the order, the order number or order JSON was not returned like expected.');
        }
    }

    /*
   * @description: This method updates the customer's email address in SFCC
   * @param ocapiExisting - data used to track changes throughout the process
   */
    private static void updateCustomer(OCAPIData ocapi){
        ocapi.profile.Email__c = 'updated' + ocapi.profile.Email__c;
        ocapi = OCAPICustomerUpdate.updateCustomer(new List<OCAPIData>{ocapi})[0];
        checkForError(ocapi);
    }

    //TODO: Create update to payment instrument but will wait for Payment Profile build
}