import ballerina/test;
import ballerina/http;
import ballerina/io;


final string serviceUrl = "http://localhost:9090/crm/v3/objects/quotes";

final Client mockClient = check new Client(config, serviceUrl = serviceUrl);

// Test function for creating a quote
@test:Config{}
function testCreateNewQuote() returns error? {
    SimplePublicObjectInputForCreate payload = {
        associations: [],
        properties: {
            "hs_title": "Test Quote", 
            "hs_expiration_date": "2025-01-31"
        }
    };

    // Call the Quotes API to create a new quote
    SimplePublicObject response = check hubspotClient->/.post(payload);

    // Set test id
    testQuoteId = response.id;

    // Validate the response
    test:assertTrue(response.id != "");
      
}
