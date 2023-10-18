@IsTest
private class TFG_InitialClaimRegistrationTest {
    @IsTest
    static void testGetInitialData() {
        // Crear una cuenta de ejemplo para obtener el Id
        Account testAccount = new Account();
        testAccount.Name = 'Test Initial';
        insert testAccount;
        
        // Crear contactos de ejemplo relacionados con la cuenta
        Contact contact1 = new Contact();
        contact1.FirstName = 'A';
        contact1.LastName = 'B';
        contact1.AccountId = testAccount.Id;
        contact1.NIF__c = '12345678A';
        contact1.Metodo_contacto__c = 'Email';
        contact1.Email = 'prueba@example.com';
        contact1.Telefono__c = '950220405';
        contact1.Rol__c = 'Titular del contrato';
        contact1.Direccion__c = 'Calle Falsa 123';
        contact1.Nombre__c = 'A';
        contact1.Apellidos__c = 'B';

        
        Contact contact2 = new Contact();
        contact2.FirstName = 'C';
        contact2.LastName = 'D';
        contact2.AccountId = testAccount.Id;
        contact2.NIF__c = '87654321A';
        contact2.Metodo_contacto__c = 'Teléfono';
        contact2.Email = 'prueba2@example.com';
        contact2.Telefono__c = '987654321';
        contact2.Rol__c = 'Autorizado';
        contact2.Direccion__c = '456 Elm St';
        contact2.Nombre__c = 'C';
        contact2.Apellidos__c = 'D';
        
        insert new List<Contact>{ contact1, contact2 };
        
        // Llamar al método getInitialData para obtener los datos iniciales
        Map<String, Object> initialData = TFG_InitialClaimRegistration.getInitialData(testAccount.Id);
        
        // Verificar los datos obtenidos
        List<Contact> contacts = (List<Contact>) initialData.get('contacts');
        System.assertEquals(2, contacts.size());
        
        Contact resultContact1 = contacts[0];
        System.assertEquals('A', resultContact1.FirstName);
        System.assertEquals('B', resultContact1.LastName);
        System.assertEquals('A', resultContact1.Nombre__c);
        System.assertEquals('B', resultContact1.Apellidos__c);
        System.assertEquals('12345678A', resultContact1.NIF__c);
        System.assertEquals('Email', resultContact1.Metodo_contacto__c);
        System.assertEquals('prueba@example.com', resultContact1.Email);
        System.assertEquals('950220405', resultContact1.Telefono__c);
        System.assertEquals('Titular del contrato', resultContact1.Rol__c);
        System.assertEquals('Calle Falsa 123', resultContact1.Direccion__c);
        
        Contact resultContact2 = contacts[1];
        System.assertEquals('C', resultContact2.FirstName);
        System.assertEquals('D', resultContact2.LastName);
        System.assertEquals('C', resultContact2.Nombre__c);
        System.assertEquals('D', resultContact2.Apellidos__c);
        System.assertEquals('87654321A', resultContact2.NIF__c);
        System.assertEquals('Teléfono', resultContact2.Metodo_contacto__c);
        System.assertEquals('prueba2@example.com', resultContact2.Email);
        System.assertEquals('987654321', resultContact2.Telefono__c);
        System.assertEquals('Autorizado', resultContact2.Rol__c);
        System.assertEquals('456 Elm St', resultContact2.Direccion__c);
    }
}