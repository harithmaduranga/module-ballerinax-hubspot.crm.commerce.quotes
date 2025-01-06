import ballerina/http;

service /hubspotMockApi on new http:Listener(8080) {

    resource function post /crm/v3/objects/quotes/batch/archive (http:Caller caller, http:Request req) returns error? {
        json response = {"message": "Batch quotes archived successfully."};
        check caller->respond(response);
    }

    resource function post /crm/v3/objects/quotes (http:Caller caller, http:Request req) returns error? {
        json response = {"id": "12345", "message": "Quote created successfully."};
        check caller->respond(response);
    }

    resource function get /crm/v3/objects/quotes (http:Caller caller, http:Request req) returns error? {
        json response = {"results": [{"id": "12345", "name": "Sample Quote 1"}, {"id": "67890", "name": "Sample Quote 2"}]};
        check caller->respond(response);
    }

    resource function delete /crm/v3/objects/quotes/{quoteId} (http:Caller caller, string quoteId) returns error? {
        json response = {"id": quoteId, "message": "Quote archived successfully."};
        check caller->respond(response);
    }

    resource function patch /crm/v3/objects/quotes/{quoteId} (http:Caller caller, string quoteId, http:Request req) returns error? {
        json response = {"id": quoteId, "message": "Quote updated successfully."};
        check caller->respond(response);
    }

    resource function get /crm/v3/objects/quotes/{quoteId} (http:Caller caller, string quoteId) returns error? {
        json response = {"id": quoteId, "name": "Sample Quote", "details": "Mock details for the quote."};
        check caller->respond(response);
    }

    resource function post /crm/v3/objects/quotes/batch/update (http:Caller caller, http:Request req) returns error? {
        json response = {"message": "Batch quotes updated successfully."};
        check caller->respond(response);
    }

    resource function post /crm/v3/objects/quotes/batch/upsert (http:Caller caller, http:Request req) returns error? {
        json response = {"message": "Batch quotes upserted successfully."};
        check caller->respond(response);
    }

    resource function post /crm/v3/objects/quotes/batch/create (http:Caller caller, http:Request req) returns error? {
        json response = {"message": "Batch quotes created successfully."};
        check caller->respond(response);
    }

    resource function post /crm/v3/objects/quotes/search (http:Caller caller, http:Request req) returns error? {
        json response = {"results": [{"id": "12345", "name": "Searched Quote 1"}, {"id": "67890", "name": "Searched Quote 2"}]};
        check caller->respond(response);
    }

    resource function post /crm/v3/objects/quotes/batch/read (http:Caller caller, http:Request req) returns error? {
        json response = {"results": [{"id": "12345", "name": "Read Quote 1"}, {"id": "67890", "name": "Read Quote 2"}]};
        check caller->respond(response);
    }
}
