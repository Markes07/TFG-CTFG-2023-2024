@isTest
private class TFG_ClaimClassifierTest {
    
    @isTest
    static void testGetTypesAndSubTypes() {
        // Preparar datos de prueba
        List<Tipo_Reclamacion__mdt> tipoReclamacion = new List<Tipo_Reclamacion__mdt>();
        tipoReclamacion = [SELECT DeveloperName, Descripcion_Tipo_Reclamacion__c, Mensajeria_Tipo_Reclamacion__c
                           FROM Tipo_Reclamacion__mdt
                           WHERE Activo__c = TRUE ORDER BY Descripcion_Tipo_Reclamacion__c ASC LIMIT 1];

        List<Subtipo_Reclamacion__mdt> subtipoReclamacion = new List<Subtipo_Reclamacion__mdt>();
        subtipoReclamacion = [SELECT Descripcion_Subtipo_Reclamacion__c, Mensajeria_Subtipo_Reclamacion__c, DeveloperName, Clase__c
                              FROM	Subtipo_Reclamacion__mdt
                              WHERE	Activo__c = TRUE LIMIT 1];
        
        // Llamar al método de prueba
        Test.startTest();
        Map<String, Object> results = TFG_ClaimClassifier.getTypesAndSubTypes();
        Test.stopTest();
        
        // Verificar el resultado
        Map<String, String> customerTypeMgsByType = (Map<String, String>)results.get('customerTypeMgsByType');
        Map<String, Map<String, String>> customerSubTypeAndMsgByTypeDesc = (Map<String, Map<String, String>>)results.get('customerSubTypeAndMsgByTypeDesc');
        Map<String, String> codeAndCustomerType = (Map<String, String>)results.get('codeAndCustomerType');
        Map<String, String> codeAndCustomerSubType = (Map<String, String>)results.get('codeAndCustomerSubType');
        Map<String, String> classAndCustomerSubType = (Map<String, String>)results.get('classAndCustomerSubType');
        
        System.assertNotEquals(null, customerTypeMgsByType);
        System.assertNotEquals(null, customerSubTypeAndMsgByTypeDesc);
        System.assertNotEquals(null, codeAndCustomerType);
        System.assertNotEquals(null, codeAndCustomerSubType);
        System.assertNotEquals(null, classAndCustomerSubType);
    }
}