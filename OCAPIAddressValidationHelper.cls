/**
 * @author Chris Eager
 * @date 4/6/2020
 * @description Handles OCAPI responses for address validation, parsing them into a generic format for Flow.
 */
public with sharing class OCAPIAddressValidationHelper {
    @InvocableMethod(label='Parse Address Validation Response')
    public static List<Result> parseValidationResponse(List<Input> jsonInput) {
        List<Result> returnResults = new List<Result>();
        AddressValidationProvider__mdt providerConfig = getActiveProviderConfig();
        if (providerConfig == null) {
            throw new ValidationException('No active address validation provider configured.');
        }
        Map<String, String> fieldMappings = (Map<String, String>) JSON.deserialize(providerConfig.FieldMappings__c, Map<String, String>.class);

        for (Input i : jsonInput) {
            Result r = new Result();
            if (String.isNotBlank(i.jsonResponse)) {
                try {
                    JSONParse addressParse = new JSONParse(i.jsonResponse);
                    // Fix 1: Use getStringValue() instead of chained get()
                    r.validationMessage = addressParse.get('fault.arguments.statusMessage').getStringValue();
                    // Fix 2: Use get() and toStringPretty() for validated address
                    JSONParse validatedAddressParse = addressParse.get(providerConfig.ValidatedAddressKey__c);
                    if (validatedAddressParse != null) {
                        String validatedAddressJson = validatedAddressParse.toStringPretty();
                        Map<String, Object> providerAddress = (Map<String, Object>) JSON.deserializeUntyped(validatedAddressJson);
                        ValidatedAddress addr = new ValidatedAddress();
                        for (String providerField : providerAddress.keySet()) {
                            String genericField = fieldMappings.get(providerField);
                            if (genericField != null) {
                                String value = String.valueOf(providerAddress.get(providerField));
                                if (genericField == 'line1') addr.line1 = value;
                                else if (genericField == 'line2') addr.line2 = value;
                                else if (genericField == 'city') addr.city = value;
                                else if (genericField == 'state') addr.state = value;
                                else if (genericField == 'postalCode') addr.postalCode = value;
                                else if (genericField == 'country') addr.country = value;
                            }
                        }
                        if (providerAddress.containsKey('zip') && fieldMappings.containsKey('zip')) {
                            String zip = (String) providerAddress.get('zip');
                            String zip4 = providerAddress.containsKey('zip4') ? (String) providerAddress.get('zip4') : '';
                            addr.postalCode = zip + (String.isNotBlank(zip4) ? '-' + zip4 : '');
                        }
                        if (providerAddress.containsKey('latitude')) {
                            addr.latitude = providerAddress.get('latitude') instanceof Decimal ? 
                                            (Decimal) providerAddress.get('latitude') : 
                                            Decimal.valueOf(String.valueOf(providerAddress.get('latitude')));
                        }
                        if (providerAddress.containsKey('longitude')) {
                            addr.longitude = providerAddress.get('longitude') instanceof Decimal ? 
                                             (Decimal) providerAddress.get('longitude') : 
                                             Decimal.valueOf(String.valueOf(providerAddress.get('longitude')));
                        }
                        r.validatedAddress = addr;
                    }
                } catch (Exception e) {
                    r.validationMessage = 'Error parsing address validation response: ' + e.getMessage();
                }
            }
            returnResults.add(r);
        }
        return returnResults;
    }

    private static AddressValidationProvider__mdt getActiveProviderConfig() {
        return [SELECT ValidatedAddressKey__c, FieldMappings__c 
                FROM AddressValidationProvider__mdt 
                WHERE Active__c = true 
                LIMIT 1];
    }

    public class Input {
        @InvocableVariable(label='JSON Response')
        public String jsonResponse;
    }

    public class Result {
        @InvocableVariable(label='Validation Message')
        public String validationMessage;
        @InvocableVariable(label='Validated Address')
        public ValidatedAddress validatedAddress;
    }

    public class ValidationException extends Exception {}
}