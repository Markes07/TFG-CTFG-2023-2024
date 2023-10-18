@IsTest
private class TFG_RequiredFieldsFormControllerTest {
    @IsTest
    static void testInsertClaim() {
        // Obtener Record Type Reclamación Abierta
        Id recordTypeClaimCase = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Caso_Reclamacion_Abierta').getRecordTypeId();
        // Crear un caso de ejemplo para insertar
        Case caseToInsert = new Case();
        caseToInsert.Subject = 'Test Case';
        
        // Llamar al método insertClaim para insertar el caso
        Test.startTest();
        Id insertedCaseId = TFG_RequiredFieldsFormController.insertClaim(caseToInsert);
        Test.stopTest();
        
        // Verificar que se haya insertado correctamente
        Case insertedCase = [SELECT Id, RecordTypeId, Status FROM Case WHERE Id = :insertedCaseId];
        System.assertEquals(recordTypeClaimCase, insertedCase.RecordTypeId);
        System.assertEquals('Recibida', insertedCase.Status);
    }
}