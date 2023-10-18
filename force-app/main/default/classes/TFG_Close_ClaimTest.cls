@IsTest
private class TFG_Close_ClaimTest {
    @IsTest
    static void testGetCauseAndResults() {
        // Llama al método getCauseAndResults para obtener los resultados
        Test.startTest();
        Map<String, List<TFG_Close_Claim.Result>> results = TFG_Close_Claim.getCauseAndResults(null);
        Test.stopTest();

        // Verifica que los resultados sean correctos
        System.assertNotEquals(null, results.get('listCausa'));
        System.assertNotEquals(null, results.get('listResultado'));
    }

    @IsTest
    static void testCloseAdmin() {
        // Crea un caso ficticio
        Case caso = new Case();
        caso.Subject = 'Asunto del caso';
        caso.Status = 'Recibida';
        insert caso;

        // Define los parámetros para cerrar el caso
        String selectedCause = 'Procedente';
        String selectedResult = 'Procedente';
        String comments = 'Comentario de cierre';
        String recordId = caso.Id;

        // Llama al método closeSaveClaim como administrador del sistema
        Test.startTest();
        String result = TFG_Close_Claim.closeSaveClaim(selectedCause, selectedResult, comments, recordId);
        Test.stopTest();

        // Verifica que el resultado sea "OK"
        System.assertEquals('OK', result);

        // Verifica que el caso se haya cerrado correctamente
        Case casoActualizado = [SELECT Id, Status, Resultado__c, Causa__c, Comentario_de_Cierre__c FROM Case WHERE Id = :recordId];
        System.assertEquals('Resuelta', casoActualizado.Status);
        System.assertEquals(selectedResult, casoActualizado.Resultado__c);
        System.assertEquals(selectedResult, casoActualizado.Causa__c);
        System.assertEquals(comments, casoActualizado.Comentario_de_Cierre__c);
    }

    @IsTest
    static void testCloseAgent() {
        // Obtener un usuario Agent
        User currentUser = [SELECT ProfileId FROM User WHERE Id = '00509000000EwwoAAC' LIMIT 1];

        // Crea un caso ficticio asignado a una cola
        Case caso = new Case();
        caso.Subject = 'Asunto del caso';
        caso.Status = 'Abierta';
        caso.OwnerId = '00G09000004uToKEAU';
        insert caso;

        // Define los parámetros para cerrar el caso
        String selectedCause = 'Causa Test 2';
        String selectedResult = 'Resultado Test 2';
        String comments = 'Comentario de cierre 2';
        String recordId = caso.Id;

        // Inicia sesión como el otro usuario
        System.runAs(currentUser) {
            // Llama al método closeSaveClaim como otro usuario
            Test.startTest();
            String result = TFG_Close_Claim.closeSaveClaim(selectedCause, selectedResult, comments, recordId);
            Test.stopTest();

            // Verifica que el resultado sea "KO"
            System.assertEquals('KO', result);

            // Verifica que el caso no se haya cerrado ni modificado
            Case casoActualizado = [SELECT Id, Status, Resultado__c, Causa__c, Comentario_de_Cierre__c FROM Case WHERE Id = :recordId];
            System.assertNotEquals('Resuelta', casoActualizado.Status);
            System.assertNotEquals(selectedResult, casoActualizado.Resultado__c);
            System.assertNotEquals(selectedResult, casoActualizado.Causa__c);
            System.assertNotEquals(comments, casoActualizado.Comentario_de_Cierre__c);
        }
    }
}