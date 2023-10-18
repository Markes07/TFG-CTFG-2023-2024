/*
  * @ComponentName	TFG_RequiredFieldsFormController
  * @description	Component controller for RequiredFieldFormCmp
  * @author			FJMG
  * @email			fran19943@gmail.com
  * @version		V0.1
  * @dateCreated	2023/06/15
  * @lastChange		
*/

public without sharing class TFG_RequiredFieldsFormController {
    @AuraEnabled
    public static Id insertClaim(Case caseClaim) {
        if(Schema.sObjectType.Case.IsAccessible() && Schema.sObjectType.Case.isCreateable() && Schema.sObjectType.Case.isUpdateable()){
            Id recordTypeClaimCase = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Caso_Reclamacion_Abierta').getRecordTypeId();
            caseClaim.RecordTypeId = recordTypeClaimCase;
            String status = 'Recibida';
            caseClaim.Status = status;
            System.debug('FJMG CASO: ' + caseClaim);
            insert caseClaim;
        }
        return caseClaim.Id;
    }
}