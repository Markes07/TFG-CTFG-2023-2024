/*
  * @ComponentName	TFG_CreateContact
  * @description	Component to create a new Contact
  * @author			FJMG
  * @email			fran19943@gmail.com
  * @version		V0.1
  * @dateCreated	2023/05/13
  * @lastChange		
*/

public with sharing class TFG_CreateContact {
    @AuraEnabled
    public static Id createContact(Contact contactInserted) {
        Contact newContact = new Contact();
        Contact contactoTitular = null;
        newContact = contactInserted;
        newContact.Nombre__c = newContact.FirstName;
        newContact.Apellidos__c = newContact.LastName;
        Account acc = [SELECT id, Name, ContactoTitular__c FROM Account WHERE Id =:newContact.AccountId LIMIT 1].get(0);
        if(acc.ContactoTitular__c != null) {
          contactoTitular = [SELECT id, Rol__c FROM Contact WHERE id =: acc.ContactoTitular__c LIMIT 1].get(0);
        }
        insert newContact;

        if(newContact.Rol__c == 'Titular del contrato') {
          if(contactoTitular != null) {
            contactoTitular.Rol__c = 'Autorizado';
            acc.ContactoTitular__c = newContact.Id;
            acc.Name = newContact.Nombre__c + ' ' + newContact.Apellidos__c;
            update acc;
            update contactoTitular;
          }
          else {
            acc.ContactoTitular__c = newContact.Id;
            acc.Name = newContact.Nombre__c + ' ' + newContact.Apellidos__c;
            update acc;
          }
        }
        return newContact.Id;
    }
}