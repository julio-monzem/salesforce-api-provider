global class CustomerSoapService {

    // GET por Id
    webservice static CustomerSoapDTO getCustomer(String customerId) {
        Customer__c c = [
            SELECT Id, Name, Email__c, Phone__c, Status__c 
            FROM Customer__c 
            WHERE Id = :customerId
            LIMIT 1
        ];

        // Monta o DTO diretamente
        CustomerSoapDTO dto = new CustomerSoapDTO();
        dto.Id     = c.Id;
        dto.Name   = c.Name;
        dto.Email  = c.Email__c;
        dto.Phone  = c.Phone__c;
        dto.Status = c.Status__c;
        return dto;
    }

    // CREATE
    webservice static String createCustomer(CustomerSoapDTO dto) {
        Customer__c c = new Customer__c(
            Name      = dto.Name,
            Email__c  = dto.Email,
            Phone__c  = dto.Phone,
            Status__c = dto.Status
        );
        insert c;
        return c.Id;
    }

    // UPDATE
    webservice static void updateCustomer(CustomerSoapDTO dto) {
        if (String.isBlank(dto.Id)) {
            throw new CalloutException('Id is required for update');
        }

        Customer__c c = [
            SELECT Id, Name, Email__c, Phone__c, Status__c 
            FROM Customer__c 
            WHERE Id = :dto.Id
            LIMIT 1
        ];

        if (dto.Name   != null) c.Name      = dto.Name;
        if (dto.Email  != null) c.Email__c  = dto.Email;
        if (dto.Phone  != null) c.Phone__c  = dto.Phone;
        if (dto.Status != null) c.Status__c = dto.Status;

        update c;
    }

    // DELETE
    webservice static void deleteCustomer(String customerId) {
        Customer__c c = [
            SELECT Id 
            FROM Customer__c 
            WHERE Id = :customerId
            LIMIT 1
        ];
        delete c;
    }
}