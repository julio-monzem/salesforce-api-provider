const soap = require('soap');
const fs = require('fs');
require('dotenv').config();

const WSDL_PATH = '../docs/wsdl/CustomerSoapService.wsdl';

// Carregar variáveis do .env
const INSTANCE_URL = process.env.INSTANCE_URL; 
const SESSION_ID   = process.env.SESSION_ID;   

if (!INSTANCE_URL || !SESSION_ID) {
    console.error("❌ ERRO: Preencha INSTANCE_URL e SESSION_ID no arquivo .env");
    process.exit(1);
}

async function createSoapClient() {
    const wsdl = fs.readFileSync(WSDL_PATH, 'utf8');

    // Endpoint do serviço SOAP gerado pela sua org
    const ENDPOINT = `${INSTANCE_URL}/services/Soap/class/CustomerSoapService`;

    const client = await soap.createClientAsync(WSDL_PATH, {
        endpoint: ENDPOINT
    });

    // Inserir SessionHeader
    client.addSoapHeader({
        SessionHeader: {
            sessionId: SESSION_ID
        }
    });

    return client;
}

// ------------------------ OPERATIONS ------------------------

async function getCustomer(customerId) {
    const client = await createSoapClient();
    const args = { customerId };
    const response = await client.getCustomerAsync(args);
    console.log("📌 GET CUSTOMER RESULT:");
    console.log(response[0]);
}

async function createCustomer() {
    const client = await createSoapClient();
    const args = {
        dto: {
            Name: "Cliente NodeJS",
            Email: "node@test.com",
            Phone: "9999-9999",
            Status: "Active"
        }
    };
    const response = await client.createCustomerAsync(args);
    console.log("📌 CREATE CUSTOMER ID:");
    console.log(response[0]);
}

async function updateCustomer(customerId) {
    const client = await createSoapClient();
    const args = {
        dto: {
            Id: customerId,
            Email: "atualizado@node.com"
        }
    };
    const response = await client.updateCustomerAsync(args);
    console.log("📌 UPDATE RESULT:");
    console.log(response[0]);
}

async function deleteCustomer(customerId) {
    const client = await createSoapClient();
    const args = { customerId };
    const response = await client.deleteCustomerAsync(args);
    console.log("📌 DELETE RESULT:");
    console.log(response[0]);
}

// ------------------------ RUN COMMANDS ------------------------

(async () => {
    const cmd = process.argv[2];
    const arg = process.argv[3];

    if (cmd === "get") await getCustomer(arg);
    else if (cmd === "create") await createCustomer();
    else if (cmd === "update") await updateCustomer(arg);
    else if (cmd === "delete") await deleteCustomer(arg);
    else {
        console.log(`
Usage:
  node soapClient.js create
  node soapClient.js get <customerId>
  node soapClient.js update <customerId>
  node soapClient.js delete <customerId>
`);
    }
})();
