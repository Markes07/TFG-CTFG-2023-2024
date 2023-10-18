/*
  * @ComponentName	TFG_WhatsAppIntegrationController
  * @description	Apex Controller to make the Post Request to the API of WhatsApp
  * @author			FJMG
  * @email			fran19943@gmail.com
  * @version		V0.1
  * @dateCreated	2023/07/17
  * @lastChange		
*/

public with sharing class TFG_WhatsAppIntegrationController {

    @future (callout=true)
    public static void sendMessageClaimCreated(List<Id> Ids) {
        // Token and IdentifierNumber
        String token = System.Label.whatsAppToken;
        String identifierNumber = System.Label.whatsAppIdentifierNumber;

        // Retrieve text for "Recibida"
        Textos_Reclamacion_Abierta__mdt textosMetadataAbierta = [SELECT id, Texto__c FROM Textos_Reclamacion_Abierta__mdt WHERE Estado__c = 'Recibida' LIMIT 1];
        String texto = textosMetadataAbierta.Texto__c;
        Case caso = [SELECT id, contact.Telefono__c, CaseNumber, Status, RecordType.Name, Causa__c, Resultado__c FROM Case WHERE id =: Ids.get(0)];

        // Set the phone number to send the WhatsApp message to
        String whatsAppNumber = '';
        if(!String.isBlank(caso.contact.Telefono__c)) {
            whatsAppNumber = '34' + caso.contact.Telefono__c;
        }
        else {
            whatsAppNumber = null;
        }

        // Check if phone is informed
        if(whatsAppNumber == null) {
            // Not send message
        }
        else {
            //Create structure
            TFG_WhatsAppMessage_Wrapper message = new TFG_WhatsAppMessage_Wrapper();
            TFG_WhatsAppMessage_Wrapper.Text textoWrapper = new TFG_WhatsAppMessage_Wrapper.Text();

            message.messaging_product = 'whatsapp';
            message.recipient_type = 'individual';
            message.to = whatsAppNumber;
            message.type = 'text';
            textoWrapper.preview_url = true;
            textoWrapper.body = 'Su reclamación con número #' + caso.CaseNumber + ' ' + texto;
            message.text = textoWrapper;

            // Initialized HTTP y HTTPRequest
            Http http = new Http();
            HttpRequest req = new HttpRequest();  
            req.setEndpoint('callout:WhatsApp/'+ identifierNumber + '/messages');
            req.setMethod('POST');
    
            // HEADERS
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + token);

            // BODY
            String jsonBody = JSON.serialize(message);
            req.setBody(jsonBody);

            HttpResponse res = http.send(req);
        }
    }
    
    @future (callout=true)
    public static void sendMessageClaimUpdated(List<Id> Ids) {
        // Token and IdentifierNumber
        String token = System.Label.whatsAppToken;
        String identifierNumber = System.Label.whatsAppIdentifierNumber;

        Case caso = [SELECT id, contact.Telefono__c, CaseNumber, Status, RecordType.Name, Causa__c, Resultado__c FROM Case WHERE id =: Ids.get(0)];

        // When the case is updated but is still open
        if(caso.RecordType.Name == 'Caso Reclamación Abierta') {
            // Retrieve text for recordType "Caso Reclamación Abierta" and status of the case
            Textos_Reclamacion_Abierta__mdt textosMetadataAbierta = [SELECT id, Texto__c FROM Textos_Reclamacion_Abierta__mdt WHERE Estado__c =: caso.Status LIMIT 1];
            String texto = textosMetadataAbierta.Texto__c;

            // Set the phone number to send the WhatsApp message to
            String whatsAppNumber = '';
            if(!String.isBlank(caso.contact.Telefono__c)) {
                whatsAppNumber = '34' + caso.contact.Telefono__c;
            }
            else {
                whatsAppNumber = null;
            }

            // Check if phone is informed
            if(whatsAppNumber == null) {
                // Not send message
            }
            else {
                //Create structure
                TFG_WhatsAppMessage_Wrapper message = new TFG_WhatsAppMessage_Wrapper();
                TFG_WhatsAppMessage_Wrapper.Text textoWrapper = new TFG_WhatsAppMessage_Wrapper.Text();

                message.messaging_product = 'whatsapp';
                message.recipient_type = 'individual';
                message.to = whatsAppNumber;
                message.type = 'text';
                textoWrapper.preview_url = true;
                textoWrapper.body = 'Su reclamación con número #' + caso.CaseNumber + ' ' + texto;
                message.text = textoWrapper;

                // Initialized HTTP y HTTPRequest
                Http http = new Http();
                HttpRequest req = new HttpRequest();  
                req.setEndpoint('callout:WhatsApp/'+ identifierNumber + '/messages');
                req.setMethod('POST');
        
                // HEADERS
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Authorization', 'Bearer ' + token);

                // BODY
                String jsonBody = JSON.serialize(message);
                req.setBody(jsonBody);

                HttpResponse res = http.send(req);
            }
        }

        // When the case is closed
        else {
            // Retrieve text for recordType "Caso Reclamación Cerrada" and status of the case
            Textos_Reclamacion_Cerrada__mdt textosMetadataCerrada = [SELECT id, Texto__c FROM Textos_Reclamacion_Cerrada__mdt WHERE Resultado__c  =: caso.Resultado__c LIMIT 1];
            String texto = textosMetadataCerrada.Texto__c;

            // Set the phone number to send the WhatsApp message to
            String whatsAppNumber = '';
            if(!String.isBlank(caso.contact.Telefono__c)) {
                whatsAppNumber = '34' + caso.contact.Telefono__c;
            }
            else {
                whatsAppNumber = null;
            }

            // Check if phone is informed
            if(whatsAppNumber == null) {
                // Not send message
            }
            else {
                //Create structure
                TFG_WhatsAppMessage_Wrapper message = new TFG_WhatsAppMessage_Wrapper();
                TFG_WhatsAppMessage_Wrapper.Text textoWrapper = new TFG_WhatsAppMessage_Wrapper.Text();

                message.messaging_product = 'whatsapp';
                message.recipient_type = 'individual';
                message.to = whatsAppNumber;
                message.type = 'text';
                textoWrapper.preview_url = true;
                textoWrapper.body = 'Su reclamación con número #' + caso.CaseNumber + ' ' + texto + ' "' + caso.Causa__c + '"';
                message.text = textoWrapper;

                // Initialized HTTP y HTTPRequest
                Http http = new Http();
                HttpRequest req = new HttpRequest();  
                req.setEndpoint('callout:WhatsApp/'+ identifierNumber + '/messages');
                req.setMethod('POST');
        
                // HEADERS
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Authorization', 'Bearer ' + token);

                // BODY
                String jsonBody = JSON.serialize(message);
                req.setBody(jsonBody);

                HttpResponse res = http.send(req);
            }
        }
    }
}