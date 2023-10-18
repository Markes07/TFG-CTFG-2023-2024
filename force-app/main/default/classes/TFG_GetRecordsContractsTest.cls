@IsTest(SeeAllData=true)
private class TFG_GetRecordsContractsTest {
    @IsTest
    static void testFetchRecord() {
        // Obtener un contrato
        Contract c = [SELECT id, ContractNumber, StartDate, EndDate FROM Contract LIMIT 1];
        
        // Llamar al método fetchRecord para buscar el contrato
        List<sObject> result = TFG_GetRecordsContracts.fetchRecord(c.ContractNumber, 'ContractNumber, StartDate, EndDate', null, null, null);
        
        // Verificar que se obtengan los resultados esperados
        System.assertEquals(1, result.size());
        sObject resultContract = result[0];
        System.assertEquals(c.ContractNumber, resultContract.get('ContractNumber'));
        System.assertEquals(c.StartDate, resultContract.get('StartDate'));
        System.assertEquals(c.EndDate, resultContract.get('EndDate'));
    }
    
    @IsTest
    static void testFetchRecordbyId() {
        // Crear una cuenta de ejemplo para obtener el Id
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        
        // Obtener un contrato
        Contract c = [SELECT id, ContractNumber, StartDate, EndDate, AccountId FROM Contract LIMIT 1];
        
        // Llamar al método fetchRecordbyId para buscar el contrato por Id de cuenta
        sObject result = TFG_GetRecordsContracts.fetchRecordbyId(c.AccountId, 'ContractNumber, StartDate, EndDate');
        
        // Verificar que se obtenga el contrato esperado
        System.assertNotEquals(null, result);
        System.assertEquals(c.Id, result.get('Id'));
        System.assertEquals(c.ContractNumber, result.get('ContractNumber'));
    }
}