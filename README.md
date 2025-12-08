# Salesforce API Provider
A complete Salesforce integration project exposing REST and SOAP APIs, including external consumption using Postman (REST) and Node.js (SOAP).

This project is designed as a portfolio-quality example for demonstrating Salesforce integration skills.

## 1. Deploying the Package to a Salesforce Dev Org

### Prerequisites
Salesforce CLI (sf)

A Developer Org with API access

Authenticated org:

``sf org login web --alias devOrg``

Project Structure (metadata)
```
force-app/
└── main/
	└── default/
		├── classes/
		│    ├── CustomerRestService.cls
		│    ├── CustomerRestServiceTest.cls
		│    ├── CustomerSoapService.cls
		│    ├── CustomerSoapServiceTest.cls
		│    └── CustomerSoapDTO.cls
		├── connectedApps/
		│    └── ApiProviderApp.connectedApp-meta.xml
		├── objects/
		│    └── Customer__c/
		└── permissionsets/
			└── ApiProvider.permissionset-meta.xml
```
The project includes a complete package.xml file inside the /manifest folder.

You may deploy using it:

``sf deploy metadata --manifest manifest/package.xml --target-org devOrg``

This option ensures you deploy exactly the components defined in the package, making the process simpler and more controlled.

Then assign the permission set:

``sf org assign permset --name ApiProvider --target-org devOrg``

## 2. REST API — Usage & Postman Testing

The project exposes a REST API under:

/services/apexrest/v1/customers

### Available REST Endpoints
GET /customers

Retrieve all customers.

GET /customers/{id}

Retrieve a customer by Salesforce ID.

POST /customers

Creates a new customer.

Body example:
```
{
  "Name": "API User",
  "Email": "api@example.com",
  "Phone": "1234-5678",
  "Status": "Active"
}
```

PUT /customers/{id}

Updates a customer.

DELETE /customers/{id}

Deletes a customer.

### Testing the REST API with Postman

Import the Postman Collection:

``/postman/Salesforce_API_Provider.postman_collection.json``


Set environment variable:

``instance_url = yourOrgInstanceURL``


Authenticate with OAuth.

Test each endpoint directly.

## 3. SOAP API — Explanation & Node.js Client Testing

### Generating the WSDL

Salesforce automatically generates the WSDL for the Apex class:

Setup → Apex Classes → CustomerSoapService → Generate WSDL

Save it as:

`docs/wsdl/CustomerSoapService.wsdl`

### Node.js SOAP Client
Located in:

``external-client-node/``

Install dependencies
`npm install`

Create a .env file
```
INSTANCE_URL=https://yourInstance.salesforce.com
SESSION_ID=yourSessionId
```

### Running SOAP Commands
Create
`node soapClient.js create`

Get
`node soapClient.js get 001XXXXXXXXXXXX`

Update
`node soapClient.js update 001XXXXXXXXXXXX`

Delete
`node soapClient.js delete 001XXXXXXXXXXXX`

## 4 Project Demonstrations

This project showcases:

REST + SOAP Apex services

OAuth 2.0 authentication

Metadata package deployment

Postman and Node.js consumption

External integration patterns

Organized project structure
