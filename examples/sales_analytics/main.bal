import ballerina/http;
import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.commerce.quotes as quotes;

configurable string & readonly clientId = ?;
configurable string & readonly clientSecret = ?;
configurable string & readonly refreshToken = ?;

public function main() returns error? {
    
    quotes:OAuth2RefreshTokenGrantConfig auth = {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER
    };

    final string serviceUrl = "https://api.hubapi.com/crm/v3/objects/quotes";

    final quotes:Client storeClient = check new quotes:Client(config = {auth}, serviceUrl = serviceUrl);

    string quoteId = "0";

    // Add new sales quote
    quotes:SimplePublicObjectInputForCreate payload = {
        associations: [],
        properties: {
            "hs_title": "Premium Subscription Quote",
            "hs_expiration_date": "2025-02-28",
            "hs_currency": "USD"
        }
    };    
    var createdNewQuote = check storeClient->/.post(payload);
    quoteId = createdNewQuote.id;
    io:println(createdNewQuote);
    

    // Get all existing sales quotes
    quotes:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging allExistingQuotes = check storeClient->/.get();
    io:println(allExistingQuotes); 

    // Get one sales quote by ID
    quotes:SimplePublicObjectWithAssociations quote = check storeClient->/[quoteId].get();
    io:println(quote);

    // Update one sales quote by ID
    quotes:SimplePublicObjectInput modifyPayload = {
        properties: {
            "hs_title": "Premium Subscription Quote",
            "hs_expiration_date": "2025-03-31",
            "hs_currency": "USD"
        }
    };
    quotes:SimplePublicObject modifiedQuote = check storeClient->/[quoteId].patch(modifyPayload);
    io:println(modifiedQuote); 

    // Archive one sales quote by ID
    http:Response response = check storeClient->/[quoteId].delete(); 
    io:println(response);

}
