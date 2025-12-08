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

