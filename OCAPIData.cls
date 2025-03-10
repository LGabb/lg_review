/**
 * Name: Susan Durand
 * Date: 09-24-2019
 * Description: Apex data type to make passing information through OCAPI flows and API callouts easier.
 */


public class OCAPIData {
    public OCAPIData(){}

    @InvocableVariable
    public Web_Profile__c profile;

    @InvocableVariable
    public String bearerToken;

    @InvocableVariable
    public String errorMsg;

    @InvocableVariable
    public Boolean isHookStatusException;

    //Used to get Avalara Address Error
    @InvocableVariable
    public String fullErrorResponse;

    //Used to indicate if Avalara should validate address or not
    @InvocableVariable
    public boolean validateAddress;

    @InvocableVariable
    public Opportunity opp;

    @InvocableVariable
    public List<OpportunityLineItem> lineItems;

    @InvocableVariable
    public List<OpportunityLineItem> newLineItems;

    @InvocableVariable
    public String newLineItemsJSON;

    // Needed to be able to pass products selected from LWC to controller to add them to the basket
    @InvocableVariable
    public String lineItemJSON;

    @InvocableVariable
    public String productsToDelete;

    @InvocableVariable
    public String productsToUpdate;

    //This id is needed if the shipping information needs to be updated.  Probably has to be a list<String>
    @InvocableVariable
    public String shipmentId;

    //The Shipping Address associated with a basket
    @InvocableVariable
    public Web_Profile_Address__c shippingAddress;

    @InvocableVariable
    public Boolean sameBillAndShipAddress;

    //The billing address associated with a basket
    @InvocableVariable
    public Web_Profile_Address__c billingAddress;

    @InvocableVariable
    public String basketId;

    @InvocableVariable
    public String paymentToken;

    @InvocableVariable
    public String paymentMethod;

    @InvocableVariable
    public String cardType;

    @InvocableVariable
    public String totalAmount;

    @InvocableVariable
    public String customerPaymentInstrumentId;

    @InvocableVariable
    public String creditCardExpirationMonth;

    @InvocableVariable
    public String creditCardExpirationYear;

    @InvocableVariable
    public String creditCardLastFour;

    @InvocableVariable
    public String creditCardName;

    @InvocableVariable
    public String basketResponseJSON;

    //String formatted to display info in flow
    @InvocableVariable
    public List<String> availableShippingMethods;

    //String of ids used with above list of shipping methods to set the picklist value in the flow
    @InvocableVariable
    public List<String> availableShippingIds;

    @InvocableVariable
    public String shippingMethodId;

    @InvocableVariable
    public String paymentInstrumentId;

    @InvocableVariable
    public String paymentMethodId;

    //Order Information when the order is made from the basket
    @InvocableVariable
    public String orderResponseJSON;

    @InvocableVariable
    public String orderNumber;

    @InvocableVariable
    public Boolean basketContainsOneTimeGift;

    @InvocableVariable
    public Boolean basketContainsRecurringGift;

    //CustomerAddress

    @InvocableVariable
    public String customerAddressResponseJSON;

    //Address used for any creation, update, or delete of address saved to Web Profile
    @InvocableVariable
    public Web_Profile_Address__c customerAddress;

    @InvocableVariable
    public String noteText;

    @InvocableVariable
    public String noteSubject;

    @InvocableVariable
    public String noteId;

    //payment method/token

    //promotions

    @InvocableVariable
    public String couponCode;

    @InvocableVariable
    public String couponCodeID;

    @InvocableVariable
    public String tempCountry;

    @InvocableVariable
    public String tempState;

    //Customer Groups

    @InvocableVariable
    public Boolean parishCustomerGroup;

    @InvocableVariable
    public Boolean bookstoreCustomerGroup;

}