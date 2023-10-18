@isTest
private class TFG_Case_HandlerTest {
    
    @isTest
    static void testBeforeInsert() {
        // Preparar datos de prueba
        List<Case> newCases = new List<Case>();
        Case case1 = new Case(Clase__c = 'Reclamación');
        Case case2 = new Case(Clase__c = 'Petición');
        newCases.add(case1);
        newCases.add(case2);
        
        // Llamar al método de prueba
        Test.startTest();
        TFG_Case_Handler handler = new TFG_Case_Handler();
        handler.beforeInsert(newCases);
        Test.stopTest();
        
        // Verificar el resultado
        System.assertEquals('00G09000004uToKEAU', case1.OwnerId);
        System.assertEquals('00G09000004uToPEAU', case2.OwnerId);
    }
    
    @isTest
    static void testBeforeUpdate() {
        // Preparar datos de prueba
        Map<Id, Case> oldCases = new Map<Id, Case>();
        Map<Id, Case> newCases = new Map<Id, Case>();
        Case case1 = new Case(Id = '5000900000lxhOsAAI', Clase__c = 'Reclamación');
        Case case2 = new Case(Id = '5000900000lxfetAAA', Clase__c = 'Petición');
        oldCases.put(case1.Id, case1);
        oldCases.put(case2.Id, case2);
        newCases.put(case1.Id, case1);
        newCases.put(case2.Id, case2);
        
        // Llamar al método de prueba
        Test.startTest();
        TFG_Case_Handler handler = new TFG_Case_Handler();
        handler.beforeUpdate(oldCases, newCases);
        Test.stopTest();
        
        // Verificar el resultado
        System.assertEquals('00G09000004uToKEAU', case1.OwnerId);
        System.assertEquals('00G09000004uToPEAU', case2.OwnerId);
    }
    
    @isTest
    static void testBeforeDelete() {
        // Preparar datos de prueba
        List<Case> oldCases = new List<Case>();
        Case case1 = new Case();
        Case case2 = new Case();
        oldCases.add(case1);
        oldCases.add(case2);
        
        // Llamar al método de prueba
        Test.startTest();
        TFG_Case_Handler handler = new TFG_Case_Handler();
        handler.beforeDelete(oldCases, new Map<Id, Case>());
        Test.stopTest();
        
        // Verificar que no se produzcan errores
    }
    
    @isTest
    static void testAfterInsert() {
        // Preparar datos de prueba
        Id recordTypeClaimCase = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Caso_Reclamacion_Abierta').getRecordTypeId();
        List<Case> newCases = new List<Case>();
        Case case1 = new Case(Status = 'Recibida', Causa__c = 'Procedente', Resultado__c = 'Procedente', RecordTypeId = recordTypeClaimCase, ContactId = '0030900001tH2anAAC');
        newCases.add(case1);
        insert case1;
        
        // Llamar al método de prueba
        Test.startTest();
        TFG_Case_Handler handler = new TFG_Case_Handler();
        handler.afterInsert(newCases);
        Test.stopTest();
        
        // Verificar que no se produzcan errores
    }
    
    @isTest
    static void testAfterUpdate() {
        // Preparar datos de prueba
        List<Case> oldCases = new List<Case>();
        List<Case> newCases = new List<Case>();
        Case case1 = new Case(Id = '5000900000lxhOsAAI');
        Case case2 = new Case(Id = '5000900000lxfetAAA');
        oldCases.add(case1);
        newCases.add(case2);
        
        // Llamar al método de prueba
        Test.startTest();
        TFG_Case_Handler handler = new TFG_Case_Handler();
        handler.afterUpdate(oldCases, newCases);
        Test.stopTest();
        
        // Verificar que no se produzcan errores
    }
    
    @isTest
    static void testAfterDelete() {
        // Preparar datos de prueba
        Map<Id, Case> oldCases = new Map<Id, Case>();
        Case case1 = new Case();
        Case case2 = new Case();
        oldCases.put(case1.Id, case1);
        oldCases.put(case2.Id, case2);
        
        // Llamar al método de prueba
        Test.startTest();
        TFG_Case_Handler handler = new TFG_Case_Handler();
        handler.afterDelete(oldCases);
        Test.stopTest();
        
        // Verificar que no se produzcan errores
    }
    
    @isTest
    static void testAfterUndelete() {
        // Preparar datos de prueba
        List<Case> newCases = new List<Case>();
        Case case1 = new Case();
        Case case2 = new Case();
        newCases.add(case1);
        newCases.add(case2);
        
        // Llamar al método de prueba
        Test.startTest();
        TFG_Case_Handler handler = new TFG_Case_Handler();
        handler.afterUndelete(newCases, new Map<Id, Case>());
        Test.stopTest();
    }
}