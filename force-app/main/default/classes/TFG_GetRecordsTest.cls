@IsTest
private class TFG_GetRecordsTest {
    @IsTest
    static void testGetResults() {
        // Crear una cuenta de ejemplo
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        
        // Llamar al método getResults para buscar la cuenta insertada
        List<TFG_GetRecords.SObjectResult> results = TFG_GetRecords.getResults('Name', 'Test');
        
        // Verificar que se encuentre el resultado esperado
        System.assertEquals(1, results.size());
        TFG_GetRecords.SObjectResult result = results[0];
        System.assertEquals('Test Account', result.Name);
        System.assertEquals(testAccount.Id, result.Id);
    }
}