/*
  * @ComponentName	TFG_GetRecordsContracts
  * @description	Component to search Contracts related to the account
  * @author			FJMG
  * @email			fran19943@gmail.com
  * @version		V0.1
  * @dateCreated	2023/06/15
  * @lastChange		
*/

public with sharing class TFG_GetRecordsContracts {

    @AuraEnabled
    public static List <sObject> fetchRecord(String searchKeyWord, String searchFields, String filter, String orderBy, String query) {
        String searchKey = '%' + searchKeyWord + '%';

        String filterAux;
        String queryAux;
        filterAux = 'ContractNumber LIKE  \'' + searchKey + '\'';

        if (query != null) {
            queryAux = filterAux + ' AND ' + query;
        } else {
            queryAux = filterAux;
        }
        if (orderBy != null) {
            queryAux = queryAux + ' ORDER BY ' + orderBy;
        }

        List < sObject > returnList = new List < sObject > ();
        String fields = searchFields != null ? 'Id, ' + searchFields : 'Id ';
        
        String sQuery =  'SELECT ' + fields + ' FROM Contract WHERE ' + queryAux;
        String auxQuery = sQuery;
        
        List <sObject> lstOfRecords  = Database.query(auxQuery);

        for (sObject obj : lstOfRecords) {
            returnList.add(obj);
        }
        return lstOfRecords;
    }

    @AuraEnabled
    public static sObject fetchRecordbyId(String recordId, String searchFields) {
        sObject returnRecord = null;

        String fields = searchFields != null ? 'Id, ' + searchFields : 'Id ';

        String sQuery = 'SELECT ' + fields + ' FROM Contract WHERE AccountId = \'' + recordId + '\'';
        String auxQuery = sQuery;

        List<sObject> lstOfRecords = Database.query(auxQuery);

        if (!lstOfRecords.isEmpty()) {
            returnRecord = lstOfRecords[0];
        }  
        return returnRecord;
    }
}