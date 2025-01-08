import ballerina/io;
import ballerina/oauth2;
import ballerina/http;
import ballerinax/hubspot.crm.commerce.quotes as quotes;

configurable string & readonly clientId = ?;
configurable string & readonly clientSecret = ?;
configurable string & readonly refreshToken = ?;

quotes:OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

final string serviceUrl = "https://api.hubapi.com/crm/v3/objects/quotes";

final quotes:Client storeClient = check new Client(config = {auth}, serviceUrl = serviceUrl);

public function main() returns error? {
    
    quotes:OAuth2RefreshTokenGrantConfig auth = {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    };

    final string serviceUrl = "https://api.hubapi.com/crm/v3/objects/quotes";

    final quotes:Client storeClient = check new Client(config = {auth}, serviceUrl = serviceUrl);

    string quoteId = "0";

    // Add new sales quote
    quotes:SimplePublicObjectInputForCreate payload = {
        associations: [],
        properties: {
            "hs_title": "Premium Subscription Quote",
            "hs_expiration_date": "2025-02-28",
            "hs_currency": "USD",
            "hs_total_amount": "1500.00",
            "hs_quote_terms": "Payment must be completed within 30 days of acceptance.",
            "hs_payment_schedule": "50% upfront, 50% upon completion",
            "hs_quote_status": "draft",
            "hs_delivery_start_date": "2025-03-01",
            "hs_delivery_end_date": "2025-06-30",
            "hs_deal_id": "123456",  
            "hs_sender_name": "John Doe",
            "hs_sender_email": "john.doe@company.com"
        }
    };    
    var createdNewQuote = check storeClient->/.post(payload);
    if(createdNewQuote is quotes:SimplePublicObject ){
        io:println(createdNewQuote);
    }else{
        io:println("New quote creation failed."); 
    }
    

    // Get all existing sales quotes
    quotes:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging|error allExistingQuotes = check storeClient->/.get();
    io:println(allExistingQuotes); 

    // Get one sales quote by ID
    quotes:SimplePublicObjectWithAssociations|error quote = check storeClient->/[quoteId].get();
    io:println(quote);

    // Archive one sales quote by ID
    http:Response|error response = check storeClient->/[quoteId].delete(); 
    io:println(response);

    // Update one sales quote by ID
    quotes:SimplePublicObjectInput modifyPayload = {
        properties: {
            "hs_title": "Premium Subscription Quote",
            "hs_expiration_date": "2025-02-28",
            "hs_currency": "USD",
            "hs_total_amount": "2000.00",
            "hs_quote_terms": "Payment must be completed within 30 days of acceptance.",
            "hs_payment_schedule": "50% upfront, 50% upon completion",
            "hs_quote_status": "draft",
            "hs_delivery_start_date": "2025-03-01",
            "hs_delivery_end_date": "2025-06-30",
            "hs_deal_id": "123456",  
            "hs_sender_name": "John Doe",
            "hs_sender_email": "john.doe@company.com"
        }
    };
    quotes:SimplePublicObject|error modifiedQuote = check storeClient->/[quoteId].patch(payload);
    io:println(modifiedQuote); 

}
