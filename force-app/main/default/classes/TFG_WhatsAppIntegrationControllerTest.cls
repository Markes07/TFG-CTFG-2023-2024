@isTest
public class TFG_WhatsAppIntegrationControllerTest {

    // Create a mock class for HTTP Callout
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock HTTPResponse
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testSendMessageClaimCreated() {
        // Crear un registro de prueba de Contacto
        Contact contactTest = new Contact(
            Nombre__c = 'Fran',
            Apellidos__c = 'Marqués',
            NIF__c = '75729302P',
            Metodo_contacto__c = 'Teléfono',
            Rol__c = 'Titular del contrato',
            FirstName = 'Fran',
            LastName = 'Prueba',
            Telefono__c = '671481834' // Número de teléfono válido
        );
        insert contactTest;

        // Crear un registro de prueba de Case relacionado con el Contacto
        Id recordTypeClaimCase = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Caso_Reclamacion_Abierta').getRecordTypeId();
        Case caseTest = new Case(
            ContactId = contactTest.Id,
            Status = 'Recibida', // Estado válido para el mensaje de prueba
            RecordTypeId = recordTypeClaimCase // Asigna el Record Type correcto
        );
        insert caseTest;

        // Set up the mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        // Llamar al método de la clase principal que deseas probar
        TFG_WhatsAppIntegrationController.sendMessageClaimCreated(new List<Id>{caseTest.Id});
        Test.stopTest();
    }

    @isTest
    static void testSendMessageClaimUpdated() {
        // Crear un registro de prueba de Contacto
        Contact contactTest = new Contact(
            Nombre__c = 'Fran',
            Apellidos__c = 'Marqués',
            NIF__c = '75729302P',
            Metodo_contacto__c = 'Teléfono',
            Rol__c = 'Titular del contrato',
            FirstName = 'Fran',
            LastName = 'Prueba',
            Telefono__c = '671481834' // Número de teléfono válido
        );
        insert contactTest;

        // Crear registros de prueba de Case relacionado con el Contacto
        Id recordTypeClaimCase = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Caso_Reclamacion_Abierta').getRecordTypeId();
        Id recordTypeClaimCaseClose = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Caso_Reclamacion_Cerrada').getRecordTypeId();
        Case case1 = new Case(
            ContactId = contactTest.Id,
            Status = 'Resolviendo', // Estado válido para el mensaje de prueba
            RecordTypeId = recordTypeClaimCase // Asigna el Record Type correcto
        );
        insert case1;

        Case case2 = new Case(
            ContactId = contactTest.Id,
            Causa__c = 'Procedente',
            Resultado__c = 'Procedente',
            Status = 'Resuelta', // Estado válido para el mensaje de prueba
            RecordTypeId = recordTypeClaimCaseClose // Asigna el Record Type correcto
        );
        insert case2;

        // Set up the mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        // Llamar al método de la clase principal que deseas probar
        TFG_WhatsAppIntegrationController.sendMessageClaimUpdated(new List<Id>{case1.Id});
        TFG_WhatsAppIntegrationController.sendMessageClaimUpdated(new List<Id>{case2.Id});
        Test.stopTest();
    }

    @isTest
    static void testSendMessageClaimUpdatedNull() {
        // Crear un registro de prueba de Contacto
        Contact contactTest = new Contact(
            Nombre__c = 'Fran',
            Apellidos__c = 'Marqués',
            NIF__c = '75729302P',
            Metodo_contacto__c = 'Teléfono',
            Rol__c = 'Titular del contrato',
            FirstName = 'Fran',
            LastName = 'Prueba',
            Telefono__c = null // Número de teléfono válido
        );
        insert contactTest;

        // Crear registro de prueba de Case relacionado con el Contacto (Teléfono null)
        Id recordTypeClaimCase = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Caso_Reclamacion_Abierta').getRecordTypeId();
        Case caseInsert = new Case(
            ContactId = contactTest.Id,
            Status = 'Resolviendo', // Estado válido para el mensaje de prueba
            RecordTypeId = recordTypeClaimCase // Asigna el Record Type correcto
        );
        insert caseInsert;

        // Set up the mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        // Llamar al método de la clase principal que deseas probar
        TFG_WhatsAppIntegrationController.sendMessageClaimUpdated(new List<Id>{caseInsert.Id});
        Test.stopTest();
    }
}