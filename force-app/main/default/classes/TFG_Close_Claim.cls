/*
  * @ComponentName	  TFG_CreateAccount
  * @description	  Component to create a new Account
  * @author			  FJMG
  * @email			  fran19943@gmail.com
  * @version		  V0.1
  * @dateCreated	  2023/06/18
  * @lastChange		
*/

public with sharing class TFG_Close_Claim {
	
	public class Result {
        @AuraEnabled
        public String value { get; set; }
    }

    @AuraEnabled
    public static Map<String, List<Result>> getCauseAndResults(String recordId) {
        Map<String, List<Result>> results = new Map<String, List<Result>>();
        List<Result> listCausa = new List<Result>();
        List<Result> listResultado = new List<Result>();

        if (Schema.sObjectType.Case.isAccessible() &&
            Schema.sObjectType.Causa_Cierre_Reclamacion__mdt.isAccessible() &&
            Schema.sObjectType.Resultado_Cierre_Reclamacion__mdt.isAccessible()) {

            List<Causa_Cierre_Reclamacion__mdt> causaPicklistValues = [SELECT Causa__c FROM Causa_Cierre_Reclamacion__mdt];
            for (Causa_Cierre_Reclamacion__mdt causa : causaPicklistValues) {
                Result item = new Result();
                item.value = causa.Causa__c;
                listCausa.add(item);
            }

            List<Resultado_Cierre_Reclamacion__mdt> resultadoPicklistValues = [SELECT Resultado__c FROM Resultado_Cierre_Reclamacion__mdt];
            for (Resultado_Cierre_Reclamacion__mdt resultado : resultadoPicklistValues) {
                Result item = new Result();
                item.value = resultado.Resultado__c;
                listResultado.add(item);
            }
            results.put('listCausa', listCausa);
            results.put('listResultado', listResultado);
        }
        return results;
    }
    
	@AuraEnabled
	public static String closeSaveClaim(String selectedCause, String selectedResult, String comments, String recordId){
        String res = '';
        Id rTypeClose = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Caso_Reclamacion_Cerrada').getRecordTypeId();
        String userId = UserInfo.getUserId();
        // Get the User record of the currently logged-in user
        User currentUser = [SELECT ProfileId FROM User WHERE Id = :userId LIMIT 1];

        // Get the Profile record using the ProfileId from the User record
        Profile userProfile = [SELECT Id, Name FROM Profile WHERE Id = :currentUser.ProfileId LIMIT 1];
        String profileName = userProfile.Name;

        Case caseObj = [SELECT Id, Resultado__c, Causa__c, Status, OwnerId, Comentario_de_Cierre__c FROM Case WHERE Id =: recordId];

        if(profileName == 'System Administrator') {
            caseObj.Resultado__c = selectedResult;
            caseObj.Causa__c = selectedResult;
            caseObj.Comentario_de_Cierre__c = comments;
            caseObj.Status = 'Resuelta';
            caseObj.RecordTypeId = rTypeClose;
            update caseObj;
            res = 'OK';
        }
        else if(caseObj.OwnerId != userId) {
            res = 'KO';
        }
        else {
            caseObj.Resultado__c = selectedResult;
            caseObj.Causa__c = selectedResult;
            caseObj.Comentario_de_Cierre__c = comments;
            caseObj.Status = 'Resuelta';
            caseObj.RecordTypeId = rTypeClose;
            update caseObj;
            res = 'OK';
        }
        return res;
	}
}