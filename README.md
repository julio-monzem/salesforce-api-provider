# Salesforce API Provider – Apex REST + OAuth 2.0

Plataforma: Salesforce Developer Edition
Tecnologias: Apex, REST API, OAuth 2.0, Postman, SFDX
Objetivo: Implementar uma API REST completa no Salesforce, utilizando OAuth 2.0 para autenticação, com objeto customizado, testes Apex, permission set e documentação.

## 📌 Visão Geral

Este projeto demonstra como construir uma API REST corporativa no Salesforce, seguindo boas práticas e arquitetura escalável:

CRUD completo usando Apex REST

Autenticação via OAuth 2.0 (Authorization Code Flow / Web Flow)

Objeto customizado versionado via metadata

Connected App versionada via metadata

Testes Apex robustos

Permission Set dedicado

Testes via Postman/cURL

O objetivo é servir como projeto de portfólio, mostrando domínio de:

Integrações Salesforce

Desenvolvimento Apex

OAuth

Documentação técnica

Arquitetura de APIs

## 🚀 Funcionalidades
🔹 API REST com CRUD completo:
Método	Rota	Ação
GET	/v1/customers	Listar
GET	/v1/customers/{id}	Buscar
POST	/v1/customers	Criar
PUT	/v1/customers/{id}	Atualizar
DELETE	/v1/customers/{id}	Excluir
🔹 Segurança:

OAuth 2.0

Connected App

Permission Set ApiProvider

Configuração por metadata

🔹 Qualidade:

Testes Apex completos

Código limpo e documentado

Padrões profissionais de API

## 🏗 Estrutura de Pastas (SFDX)
force-app/
 └── main/
      └── default/
           ├── classes/
           │    ├── CustomerRestService.cls
           │    └── CustomerRestServiceTest.cls
           ├── connectedApps/
           │    └── ApiProviderApp.connectedApp-meta.xml
           ├── objects/
           │    └── Customer__c/
           └── permissionsets/
                └── ApiProvider.permissionset-meta.xml

## 🛠 Pré-Requisitos
Ferramentas

Developer Edition (FREE) → https://developer.salesforce.com/signup

VS Code

Salesforce CLI (sf ou sfdx)

Postman

GitHub (para versionamento)

Configurar o Dev Org na CLI

Faça login:

sfdx auth:web:login -a dev-api-provider


Agora sua org está autenticada e pronta para receber deploy.

## 🔧 Instalação & Deploy
1️⃣ Clone o repositório
git clone https://github.com/<usuario>/<repo>.git
cd <repo>

2️⃣ Deploy do metadata para sua Dev Org
sfdx force:source:deploy -p force-app -u dev-api-provider

3️⃣ Abrir a org
sfdx force:org:open -u dev-api-provider

## 🧩 Configuração na Dev Org

Após o deploy, configure:

✔ 1. Ativar a Connected App

Ir para:

Setup → App Manager → API Provider App → View

Copiar:

Consumer Key

Consumer Secret

✔ 2. Liberar a Connected App para seu usuário

Setup → App Manager → API Provider App → Manage → Profiles

Adicionar:

System Administrator
(ou o perfil desejado)

✔ 3. Atribuir o Permission Set
sfdx force:user:permset:assign -n ApiProvider -u dev-api-provider

## 🔐 Autenticação OAuth (Postman)

Use o Authorization Code Flow, recomendado para Salesforce.

🔹 No Postman:

Authorization → tipo OAuth 2.0

Clique Get New Access Token

Preencha:

Campo	Valor
Grant Type	Authorization Code
Callback URL	https://localhost/callback

Auth URL	https://login.salesforce.com/services/oauth2/authorize

Access Token URL	https://login.salesforce.com/services/oauth2/token

Client ID	(consumer key)
Client Secret	(consumer secret)
Scope	api
Client Authentication	Send client credentials in body

Clique Request Token

Faça login na Dev Org

Clique Allow

Clique Use Token

## 🧪 Testes da API — cURL
🔵 GET (listar)
curl -H "Authorization: Bearer <TOKEN>" \
  https://<INSTANCE_URL>/services/apexrest/v1/customers

🔵 GET (por id)
curl -H "Authorization: Bearer <TOKEN>" \
  https://<INSTANCE_URL>/services/apexrest/v1/customers/<ID>

🔵 POST
curl -X POST -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{ "Name": "Cliente API", "Email": "api@ex.com", "Status":"Active" }' \
  https://<INSTANCE_URL>/services/apexrest/v1/customers

🔵 PUT
curl -X PUT -H "Authorization: Bearer <TOKEN>" \
  -H "Content-Type: application/json" \
  -d '{ "Email": "novo@ex.com" }' \
  https://<INSTANCE_URL>/services/apexrest/v1/customers/<ID>

🔵 DELETE
curl -X DELETE -H "Authorization: Bearer <TOKEN>" \
  https://<INSTANCE_URL>/services/apexrest/v1/customers/<ID>

## 🧪 Testes Apex

Rodar:

sfdx force:apex:test:run -r human -u dev-api-provider


A classe de testes cobre:

GET list

GET id válido

GET id inválido

POST

PUT

DELETE

Erros de payload

Erros de not found
