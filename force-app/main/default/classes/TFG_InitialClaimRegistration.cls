/*
  * @ComponentName	TFG_InitialClaimRegistration
  * @description	Component to initialise first window in flow
  * @author			FJMG
  * @email			fran19943@gmail.com
  * @version		V0.1
  * @dateCreated	2023/06/05
  * @lastChange		
*/

public with sharing class TFG_InitialClaimRegistration {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getInitialData(Id recordId) {
        Map<String, Object> result = new Map<String, Object>();
        List<Contact> contacts = [SELECT id, FirstName, LastName, NIF__c, Metodo_contacto__c, Email, Telefono__c, Rol__c, Direccion__c, Nombre__c, Apellidos__c FROM Contact WHERE AccountId = :recordId];
        result.put('contacts', contacts);
        return result;
    }
}