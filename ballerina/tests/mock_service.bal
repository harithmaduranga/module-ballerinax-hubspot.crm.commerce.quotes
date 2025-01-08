import ballerina/http;
import ballerina/log;

listener http:Listener httpListener = new(9090);

http:Service mockService = service object {
    
    // Archive
    resource function delete crm/v3/objects/quotes/[string quoteId]() returns http:Response|error {
        http:Response response = new();
        response.statusCode = http:STATUS_NO_CONTENT;
        response.setPayload("Successfully deleted");
        return response;
    }

    // Read
    resource function get crm/v3/objects/quotes/[string quoteId](string[]? properties, string[]? propertiesWithHistory, string[]? associations, string? idProperty, boolean archived = false) returns SimplePublicObjectWithAssociations|error {
        return {
            id: "0",
            properties: {
                "hs_title": "Test Quote 0", 
                "hs_expiration_date": "2025-01-31"
            },
            createdAt: "2025-01-08", 
            updatedAt: "2025-01-15"
        };
    }

    // Update
    resource function patch crm/v3/objects/quotes/[string quoteId](string? idProperty, @http:Payload SimplePublicObjectInput payload) returns SimplePublicObject|error {
        return {
            id: "1",
            properties: {
                "hs_title": "Test Quote 1", 
                "hs_expiration_date": "2025-01-31"
            },
            createdAt: "2025-01-08", 
            updatedAt: "2025-01-15"
        }; 
    }

    // Create
    resource function post crm/v3/objects/quotes(@http:Payload SimplePublicObjectInputForCreate payload) returns SimplePublicObject|error {
        return {
            id: "2",
            properties: {
                "hs_title": "Test Quote 2", 
                "hs_expiration_date": "2025-01-31"
            },
            createdAt: "2025-01-08", 
            updatedAt: "2025-01-15"
        }; 
    }
    
};

function init() returns error?{
    log:printInfo("Initializing mock service");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}