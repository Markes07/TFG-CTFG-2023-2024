@isTest
private class TFG_AtencionAlClienteTest {
    
    @isTest
    static void testGetClient() {
        // Preparar datos de prueba
        Account account = new Account(Name = 'Test Account', ContactoTitular__c = '0030900001tH2anAAC');
        insert account;
        
        // Llamar al método de prueba
        Test.startTest();
        Account result = TFG_AtencionAlCliente.getClient(account.Id);
        Test.stopTest();
        
        // Verificar el resultado
        System.assertEquals(account.Id, result.Id);
        System.assertEquals(account.Name, result.Name);
        System.assertEquals(account.ContactoTitular__c, result.ContactoTitular__c);
    }
    
    @isTest
    static void testGetContracts() {
        // Preparar datos de prueba
        Account account = new Account(Name = 'Test Account');
        insert account;
        Contract contract1 = new Contract(AccountId = account.Id);
        Contract contract2 = new Contract(AccountId = account.Id);
        insert new List<Contract>{ contract1, contract2 };
        
        // Llamar al método de prueba
        Test.startTest();
        Integer result = TFG_AtencionAlCliente.getContracts(account.Id);
        Test.stopTest();
        
        // Verificar el resultado
        System.assertEquals(2, result);
    }
    
    @isTest
    static void testCaseAssign() {
        // Preparar datos de prueba
        Case testCase = new Case();
        insert testCase;
        
        // Llamar al método de prueba
        Test.startTest();
        TFG_AtencionAlCliente.caseAssign(new List<String>{ testCase.Id });
        Test.stopTest();
        
        // Verificar el resultado
        Case updatedCase = [SELECT Id, OwnerId FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(true, updatedCase.OwnerId != null);
    }
}