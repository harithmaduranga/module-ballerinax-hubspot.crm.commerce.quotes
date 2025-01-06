import ballerina/test;
import ballerina/oauth2;
import ballerina/http;
import ballerina/io;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};
<<<<<<< HEAD

final string serviceUrl = "https://api.hubapi.com";

final Client hubspotClient = check new Client(config = {auth}, serviceUrl = serviceUrl);

string testQuoteId = ""; 
=======
>>>>>>> dab83a53ac73c6ceababddc17b99dd66d30cf117

final string serviceUrl = "https://api.hubapi.com";

<<<<<<< HEAD
// Test function for creating a quote
@test:Config{}
function testCreateNewQuote() returns error? {
    SimplePublicObjectInputForCreate payload = {
        associations: [],
        properties: {
            name: "Test Quote",
            dealId: "123456", 
            totalAmount: "1000.00",
            expirationDate: "2025-01-31", 
            paymentTerms: "Net 30" 
        }
    };

    // Call the Quotes API to create a new quote
    SimplePublicObject|error response = check hubspotClient->/crm/v3/objects/quotes.post(payload);

    // Validate the response
    test:assertTrue(response == payload, 
        msg = "Quote in response does not match the expected quote."); 
}

// Test for retrieving all quotes
@test:Config{}
function testGetAllQuotes() returns error? {

    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging|error response = check hubspotClient->/crm/v3/objects/quotes;

    // Validate the response contains a list of quotes
    if(response is CollectionResponseSimplePublicObjectWithAssociationsForwardPaging){
        test:assertTrue(response.results.length() >= 0, 
            msg = "No quotes found in the response."); 
    }else {
        io:println(response);
    }
}

// Test function for retrieving a quote
@test:Config{}
function testGetOneQuote() returns error? {

    SimplePublicObjectWithAssociations|error response = check hubspotClient->/crm/v3/objects/quotes/[testQuoteId];

    // Validate the response
    if(response is SimplePublicObjectWithAssociations){
        test:assertTrue(response.id == testQuoteId, 
            msg = "Retrieved quote ID does not match the expected ID.");
    }else{
        io:println(response);
    }

@test:Config{}
function testArchiveOneQuote() {

    http:Response|error response = hubspotClient->/crm/v3/objects/quotes/[testQuoteId].delete(); 

    // Validate the response
    if(response is SimplePublicObjectWithAssociations){
        test:assertTrue(response.id == testQuoteId, 
            msg = "Retrieved quote ID does not match the expected ID.");
    }else{
        io:println(response);
    }

}


// Test function for updating a quote
@test:Config{}
function testUpdateOneQuote() returns error? {
    SimplePublicObjectInput payload = {
        properties: {
            name: "Test Quote",
            dealId: "123456", 
            totalAmount: "1000.00",
            expirationDate: "2025-01-31", 
            paymentTerms: "Net 30" 
        }
    };

    // Call the Quotes API to create a new quote
    SimplePublicObject|error response = check hubspotClient->/crm/v3/objects/quotes/[testQuoteId].patch(payload);

    // Validate the response
    test:assertTrue(response == payload, 
        msg = "Quote in response does not match the expected quote."); 
}

=======
final Client hubspotClient = check new Client(config = {auth}, serviceUrl = serviceUrl);

string testQuoteId = ""; 

// Represents the payload for creating a quote
type QuoteCreateRequest record {|
    string name;
    string dealId;
    decimal totalAmount;
    string expirationDate;
    string paymentTerms;
|};

// Represents the response structure for quote creation
type QuoteCreateResponse record {|
    string id;
    string name;
    string dealId;
    decimal totalAmount;
    string expirationDate;
    string paymentTerms;
|};

// Test function for creating a quote
@test:Config{}
function testCreateAQuote() returns error? {
    QuoteCreateRequest payload = {
        name: "Test Quote",
        dealId: "123456", // Replace with an actual deal ID
        totalAmount: 1000.00,
        expirationDate: "2025-01-31", // Example expiration date
        paymentTerms: "Net 30" // Example payment terms
    };

    // Call the Quotes API to create a new quote
    string endpoint = "/crm/v3/objects/quotes";
    QuoteCreateResponse|error response = check hubspotClient->post(endpoint, payload);
    //QuoteCreateResponse|error response = check hubspotClient->/crm/v3/objects/quotes.post(payload);
    testQuoteId = response.id;

    // Validate the response
    test:assertTrue(response.name == "Test Quote", 
        msg = "Quote name in response does not match the expected name.");
}

// Test for retrieving all quotes
@test:Config{}
function testGetAllQuotes() returns error? {
    string endpoint = "/crm/v3/objects/quotes";
    record {| QuoteCreateResponse[] quotes; |}|error response = check hubspotClient->get(endpoint);

    // Validate the response contains a list of quotes
    test:assertTrue(response.quotes.length() >= 0, 
        msg = "No quotes found in the response."); 
}
>>>>>>> dab83a53ac73c6ceababddc17b99dd66d30cf117
