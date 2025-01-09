import ballerina/http;
import ballerina/oauth2;
import ballerina/test;

final string mockServiceUrl = "http://localhost:9090/crm/v3/objects/quotes";

final Client mockClient = check new Client(config = {auth: {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER 
}}, serviceUrl = mockServiceUrl);

// Test function for creating a quote
@test:Config{}
function testCreateAQuote() returns error? {
    SimplePublicObjectInputForCreate payload = {
        associations: [],
        properties: {
            "hs_title": "Test Quote 2", 
            "hs_expiration_date": "2025-01-31"
        }
    };

    SimplePublicObject response = check mockClient->/.post(payload);

    test:assertEquals(response.properties, payload.properties, "New quote creation failed.");     
}

// Test function to get a quote bu ID
@test:Config{}
function testGetAQuoteById() returns error? {
    SimplePublicObjectWithAssociations response = check mockClient->/["0"].get();

    test:assertEquals(response, {
            id: "0",
            properties: {
                "hs_title": "Test Quote 0", 
                "hs_expiration_date": "2025-01-31"
            },
            createdAt: "2025-01-08", 
            updatedAt: "2025-01-15"
        }, "Reading this quote is failed.");
}

// Test function to archive a quote by ID 
@test:Config{}
function testArchiveAQuoteById() returns error?{

    http:Response response = check mockClient->/["0"].delete(); 

    test:assertTrue(response.statusCode == 204);
}

// Test function to update a quote
@test:Config{}
function testUpdateAQuoteById() returns error? {
    SimplePublicObjectInput payload = {
        properties: {
            "hs_title": "Test Quote 1", 
            "hs_expiration_date": "2025-01-31"
        }
    };

    // Call the Quotes API to update the quote
    SimplePublicObject response = check mockClient->/["1"].patch(payload);

    test:assertEquals(response, {
            id: "1",
            properties: {
                "hs_title": "Test Quote 1", 
                "hs_expiration_date": "2025-01-31"
            },
            createdAt: "2025-01-08", 
            updatedAt: "2025-01-15"
        }, "Quote update failed.");
}

// Test function to upsert a quote
@test:Config{}
function testUpsertAQuote() returns error? {
    BatchInputSimplePublicObjectBatchInputUpsert payload = {
        inputs: [
            {
                id: "1",
                properties: {
                    "hs_title": "Test Quote 1", 
                    "hs_expiration_date": "2025-01-31"
                }
            },
            {
                id: "2",
                properties: {
                    "hs_title": "Test Quote 2", 
                    "hs_expiration_date": "2025-03-31"
                }
            }
        ]
    };

    BatchResponseSimplePublicUpsertObject response = check mockClient->/batch/upsert.post(payload = payload);

    test:assertEquals(response, {
            completedAt: "2025-01-10",
            startedAt: "2025-01-08",
            requestedAt: "2025-01-08",
            results:[
                {
                    id: "1",
                    properties: {
                        "hs_title": "Test Quote 1", 
                        "hs_expiration_date": "2025-01-31"
                    },
                    'new: true,
                    createdAt: "2025-01-08", 
                    updatedAt: "2025-01-15"
                },
                {
                    id: "2",
                    properties: {
                        "hs_title": "Test Quote 2", 
                        "hs_expiration_date": "2025-01-31"
                    },
                    'new: true,
                    createdAt: "2025-01-08", 
                    updatedAt: "2025-01-15"
                }
            ],
            status: "COMPLETE"
        }, "Quote upsert failed.");
}

// Test function to upsert a quote
@test:Config{}
function testSearchAQuote() returns error? {
    // PublicObjectSearchRequest payload = {
    //     properties: ["hs_title", "hs_expiration_date"]
    // };

    PublicObjectSearchRequest payload = {
    filterGroups: [
        {
            filters: [
                {
                    propertyName: "hs_title",
                    operator: "EQ",
                    value: "Test Quote 1"
                }
            ]
        }
    ],
    properties: ["hs_title", "hs_expiration_date"]
};

    CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check mockClient->/search.post(payload = payload);

    SimplePublicObject ob1 = {
                    id: "1",
                    properties: {
                        "hs_title": "Test Quote 1", 
                        "hs_expiration_date": "2025-01-31"
                    },
                    createdAt: "2025-01-08", 
                    updatedAt: "2025-01-15"
                };
    SimplePublicObject ob2 = {
                    id: "2",
                    properties: {
                        "hs_title": "Test Quote 2", 
                        "hs_expiration_date": "2025-01-31"
                    },
                    createdAt: "2025-01-08", 
                    updatedAt: "2025-01-15"
                };

    test:assertEquals(response, {
            total: 1500,
            results: [ob1, ob2] 
        }, "Quote search failed."); 
}

