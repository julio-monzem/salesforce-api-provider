@RestResource(urlMapping='/v1/customers/*')
global with sharing class CustomerRestService {
    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        String id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if (id == 'v1' || id == 'customers' || id == '') {
            List<Customer__c> listC = [SELECT Id, Name, Email__c, Phone__c, Status__c FROM Customer__c LIMIT 200];
            RestContext.response.statusCode = 200;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(listC));
            return;
        }
        try {
            Customer__c c = [SELECT Id, Name, Email__c, Phone__c, Status__c FROM Customer__c WHERE Id = :id LIMIT 1];
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(c));
            RestContext.response.statusCode = 200;
        } catch (Exception e) {
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(new Map<String,String>{ 'error' => 'Not found' }));
        }
    }

    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        String body = req.requestBody.toString();
        Map<String,Object> payload = (Map<String,Object>) JSON.deserializeUntyped(body);
        Customer__c c = new Customer__c(
            Name = (String) payload.get('Name'),
            Email__c = (String) payload.get('Email'),
            Phone__c = (String) payload.get('Phone'),
            Status__c = (String) payload.get('Status')
        );
        insert c;
        RestContext.response.statusCode = 201;
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(c));
    }

    @HttpPut
    global static void doPut() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String id = getRecordIdFromUrl(req);

        if (String.isBlank(id)) {
            sendBadRequest(res, 'Missing Customer Id');
            return;
        }

        try {
            Customer__c existing = [
                SELECT Id, Name, Email__c, Phone__c, Status__c
                FROM Customer__c WHERE Id = :id LIMIT 1
            ];

            Map<String, Object> body = parseBody(req);

            if (body.containsKey('Name'))      existing.Name      = (String) body.get('Name');
            if (body.containsKey('Email'))     existing.Email__c  = (String) body.get('Email');
            if (body.containsKey('Phone'))     existing.Phone__c  = (String) body.get('Phone');
            if (body.containsKey('Status'))    existing.Status__c = (String) body.get('Status');

            update existing;

            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(existing));
        }
        catch (QueryException qe) {
            sendNotFound(res, 'Customer not found');
        }
        catch (Exception e) {
            sendBadRequest(res, e.getMessage());
        }
    }

    @HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String id = getRecordIdFromUrl(req);

        if (String.isBlank(id)) {
            sendBadRequest(res, 'Missing Customer Id');
            return;
        }

        try {
            Customer__c c = [
                SELECT Id FROM Customer__c WHERE Id = :id LIMIT 1
            ];
            delete c;

            res.statusCode = 204;
            res.responseBody = Blob.valueOf('');
        }
        catch (QueryException qe) {
            sendNotFound(res, 'Customer not found');
        }
        catch (Exception e) {
            sendBadRequest(res, e.getMessage());
        }
    }

    private static String getRecordIdFromUrl(RestRequest req) {
        String full = req.requestURI;
        List<String> parts = full.split('/');
        String last = parts.isEmpty() ? '' : parts[parts.size()-1];
        return (last == 'customers' || last == 'v1') ? '' : last;
    }

    private static Map<String, Object> parseBody(RestRequest req) {
        return (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
    }

    private static void sendBadRequest(RestResponse res, String msg) {
        res.statusCode = 400;
        res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{'error' => msg}));
    }

    private static void sendNotFound(RestResponse res, String msg) {
        res.statusCode = 404;
        res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, String>{'error' => msg}));
    }
    
}