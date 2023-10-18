public with sharing class TFG_Case_Handler implements CaseHandler {

    public void beforeInsert(List<Case> newItems) {
        // We need to change the owner of the case to asign it to a Queue based of field "Clase"
        Set<String> queueNames = new Set<String>();
        Map<String, Id> queueNameToIdMap = new Map<String, Id>();
        
        for (Case newCase : newItems) {
            if (newCase.Clase__c == 'Reclamación') {
                queueNames.add('Reclamaciones');
            } else if (newCase.Clase__c == 'Petición') {
                queueNames.add('Peticiones');
            }
        }
        
        for (Group queue : [SELECT Id, Name FROM Group WHERE Name IN :queueNames AND Type = 'Queue']) {
            queueNameToIdMap.put(queue.Name, queue.Id);
        }
        
        for (Case newCase : newItems) {
            if (newCase.Clase__c == 'Reclamación' && queueNameToIdMap.containsKey('Reclamaciones')) {
                newCase.OwnerId = queueNameToIdMap.get('Reclamaciones');
            } else if (newCase.Clase__c == 'Petición' && queueNameToIdMap.containsKey('Peticiones')) {
                newCase.OwnerId = queueNameToIdMap.get('Peticiones');
            }
        }
    }

    public void beforeUpdate(Map<Id, Case> oldItems, Map<Id, Case> newItems) {
        // We need to change the owner of the case to asign it to a Queue based of field "Clase"
        Set<String> queueNames = new Set<String>();
        Map<String, Id> queueNameToIdMap = new Map<String, Id>();
        
        for (Case newCase : newItems.values()) {
            if (newCase.Clase__c == 'Reclamación') {
                queueNames.add('Reclamaciones');
            } else if (newCase.Clase__c == 'Petición') {
                queueNames.add('Peticiones');
            }
        }
        
        for (Group queue : [SELECT Id, Name FROM Group WHERE Name IN :queueNames AND Type = 'Queue']) {
            queueNameToIdMap.put(queue.Name, queue.Id);
        }
        
        for (Case newCase : newItems.values()) {
            if (newCase.Clase__c == 'Reclamación' && queueNameToIdMap.containsKey('Reclamaciones')) {
                newCase.OwnerId = queueNameToIdMap.get('Reclamaciones');
            } else if (newCase.Clase__c == 'Petición' && queueNameToIdMap.containsKey('Peticiones')) {
                newCase.OwnerId = queueNameToIdMap.get('Peticiones');
            }
        }
    }

    public void beforeDelete(List<Case> oldRecordsList, Map<Id, Case> oldItems) {
        // Do nothing
    }

    public void afterInsert(List<Case> newItems) {
        List<Id> Ids = new List<Id>();
        Id casoId = newItems.get(0).Id;
        Ids.add(casoId);
        // Call controller
        TFG_WhatsAppIntegrationController.sendMessageClaimCreated(Ids);
    }

    public void afterUpdate(List<Case> oldItems, List<Case> newItems) {
        Case casoOld = oldItems.get(0);
        Case casoNew = newItems.get(0);
        if(casoOld.status != casoNew.status) {      
            List<Id> Ids = new List<Id>();
            Id casoId = newItems.get(0).Id;
            Ids.add(casoId);
            // Call controller
            TFG_WhatsAppIntegrationController.sendMessageClaimUpdated(Ids);
        }
    }

    public void afterDelete(Map<Id, Case> oldItems) {
        // Do nothing
    }

    public void afterUndelete(List<Case> newRecordsList, Map<Id, Case> newItems) {
        // Do nothing
    }
}