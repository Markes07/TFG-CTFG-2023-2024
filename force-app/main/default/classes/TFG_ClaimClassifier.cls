/*
  * @ComponentName	TFG_ClaimClassifier
  * @description	Controller component from step2 in the claim classifier
  * @author			FJMG
  * @email			fran19943@gmail.com
  * @version		V0.1
  * @dateCreated	2023/06/10
  * @lastChange		
*/

public with sharing class TFG_ClaimClassifier {
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getTypesAndSubTypes() {
        Map<String, Object> results = new Map<String, Object>();
        Map<String, String> customerTypeMgsByType = new Map<String, String>();
        Map<String, Map<String, String>> customerSubTypeAndMsgByTypeDesc = new Map<String, Map<String, String>>();
        Map<String, String> codeAndCustomerType = new Map<String,String>();
        Map<String, String> codeAndCustomerSubType = new Map<String,String>();
        Map<String, String> classAndCustomerSubType = new Map<String,String>();

        List<Tipo_Reclamacion__mdt> customerTypes = new List<Tipo_Reclamacion__mdt>();
        if(Schema.sObjectType.Tipo_Reclamacion__mdt.isAccessible()){
            customerTypes = [SELECT
                            DeveloperName,
                            Descripcion_Tipo_Reclamacion__c,
                            Mensajeria_Tipo_Reclamacion__c,
                                (SELECT Descripcion_Subtipo_Reclamacion__c, 
                                Mensajeria_Subtipo_Reclamacion__c,
                                DeveloperName,
                                Clase__c
                                FROM	Subtipo_Reclamacion__r
                                WHERE	Activo__c = TRUE)
                            FROM Tipo_Reclamacion__mdt
                            WHERE Activo__c = TRUE ORDER BY Descripcion_Tipo_Reclamacion__c ASC]; 
        }
        
        for (Tipo_Reclamacion__mdt customerType : customerTypes) {
            Map<String, String> subTypes = new Map<String, String>(); 
            for (Subtipo_Reclamacion__mdt subType : customerType.Subtipo_Reclamacion__r) {
                subTypes.put(subType.Descripcion_Subtipo_Reclamacion__c , subType.Mensajeria_Subtipo_Reclamacion__c);
                codeAndCustomerSubType.put(subType.Descripcion_Subtipo_Reclamacion__c, subType.DeveloperName);
                classAndCustomerSubType.put(subType.Descripcion_Subtipo_Reclamacion__c, subType.Clase__c);       
            }
            customerTypeMgsByType.put(customerType.Descripcion_Tipo_Reclamacion__c, customerType.Mensajeria_Tipo_Reclamacion__c);
            customerSubTypeAndMsgByTypeDesc.put(customerType.Descripcion_Tipo_Reclamacion__c, subTypes);
            codeAndCustomerType.put(customerType.Descripcion_Tipo_Reclamacion__c,customerType.DeveloperName);
        }
        
        results.put('customerTypeMgsByType', customerTypeMgsByType);
        results.put('customerSubTypeAndMsgByTypeDesc', customerSubTypeAndMsgByTypeDesc); 
        results.put('codeAndCustomerType', codeAndCustomerType);
        results.put('codeAndCustomerSubType', codeAndCustomerSubType); 
        results.put('classAndCustomerSubType', classAndCustomerSubType);      
        
        return results;
    }
}