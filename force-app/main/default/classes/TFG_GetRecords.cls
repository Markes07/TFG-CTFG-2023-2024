/*
  * @ComponentName	TFG_GetRecords
  * @description	Component to search Accounts
  * @author			FJMG
  * @email			fran19943@gmail.com
  * @version		V0.1
  * @dateCreated	2023/05/13
  * @lastChange		
*/

public class TFG_GetRecords {

	@AuraEnabled
    public static List<SObjectResult> getResults(String Field, String searchName) {
        List<SObjectResult> SObjectResultList = new List<SObjectResult>();
        String query = 'SELECT Id,Name FROM Account WHERE '+Field+' LIKE \'%'+searchName+'%\'';

        for(SObject so: Database.query(query)){
            String fieldValue = (String) so.get(Field);
            SObjectResultList.add(new SObjectResult(fieldValue,so.Id));
        }
        return SObjectResultList;
    }

    public class SObjectResult{
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public Id Id;

        public SObjectResult(String NameTemporal, Id IdTemporal) {
            Name = NameTemporal;
            Id = IdTemporal;
        }
    }
}