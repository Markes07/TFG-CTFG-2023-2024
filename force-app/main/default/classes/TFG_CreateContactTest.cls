@IsTest
private class TFG_CreateContactTest {
    @IsTest
    static void testCreateContact() {
        // Crear una cuenta de ejemplo para relacionar al contacto
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        
        // Crear un contacto de ejemplo para insertar
        Contact contactToInsert = new Contact();
        contactToInsert.FirstName = 'Test';
        contactToInsert.LastName = 'Fran';
        contactToInsert.AccountId = testAccount.Id;
        contactToInsert.Rol__c = 'Titular del contrato';
        contactToInsert.NIF__c = '75729302P';
        contactToInsert.Metodo_contacto__c = 'SMS';

        
        // Llamar al método de creación de contacto
        Id insertedContactId = TFG_CreateContact.createContact(contactToInsert);
        
        // Verificar que se haya insertado correctamente
        Contact insertedContact = [SELECT Id, FirstName, LastName, AccountId, Rol__c, NIF__c, Metodo_contacto__c FROM Contact WHERE Id = :insertedContactId];
        System.assertEquals('Test', insertedContact.FirstName);
        System.assertEquals('Fran', insertedContact.LastName);
        
        // Verificar que la cuenta y el contacto estén correctamente relacionados
        Account updatedAccount = [SELECT Id, Name, ContactoTitular__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(insertedContactId, updatedAccount.ContactoTitular__c);
        System.assertEquals('Test Fran', updatedAccount.Name);
    }
}