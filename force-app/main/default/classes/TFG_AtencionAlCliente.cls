/*============================================================================================================================================
* @className              TFG_AtencionAlCliente
* @owner                  FJMG
*============================================================================================================================================
*/
public with sharing class TFG_AtencionAlCliente {    
    /*
*============================================================================================================================================
* @methodName               getClient
* @received parameters      Id accountId
* @return                   Account [SELECT Id, Name, ContactoTitular__c FROM Account WHERE id = :accountId]
*============================================================================================================================================
*/
    @AuraEnabled
    public static Account getClient(Id accountId) {
        return [SELECT Id, Name, ContactoTitular__c FROM Account WHERE id = :accountId LIMIT 1];
    }

    @AuraEnabled
    public static Integer getContracts(Id accountId) {
        return [SELECT Id FROM Contract WHERE AccountId = :accountId].size();
    }
    
    
    /*
*============================================================================================================================================
* @methodName               caseAssign
* @received parameters      List<String> caseId
* @return                   (void method)
*============================================================================================================================================
*/
    @InvocableMethod
    public static void caseAssign(List<String> caseId) {
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;
        Case cases = new Case();
        if (Schema.sObjectType.Case.isAccessible() && Schema.sObjectType.Case.isUpdateable()) {
            cases = [SELECT id FROM Case WHERE Case.id IN :caseid];
            // }
            cases.setOptions(dmo);
            //if(){
            update cases;
        }
    }
}