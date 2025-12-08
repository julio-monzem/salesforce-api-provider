# Salesforce API Provider – Apex REST + OAuth 2.0
A complete Salesforce integration project exposing REST and SOAP APIs, including external consumption using Postman (REST) and Node.js (SOAP).

This project is designed as a portfolio-quality example for demonstrating Salesforce integration skills.

## 1. Deploying the Package to a Salesforce Dev Org

Prerequisites
Salesforce CLI (sf)
A Developer Org with API access

Authenticated org:
sf org login web --alias devOrg

Project Structure (metadata)
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