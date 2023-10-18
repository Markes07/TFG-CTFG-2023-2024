/*
  * @ComponentName	CaseHandler
  * @description	Component controller for RequiredFieldFormCmp
  * @author			FJMG
  * @email			fran19943@gmail.com
  * @version		V0.1
  * @dateCreated	2023/06/15
  * @lastChange		
*/
public interface CaseHandler {

    void beforeInsert(List<Case> newItems);
    void beforeUpdate(Map<Id, Case> oldItems, Map<Id, Case> newItems);
    void beforeDelete(List<Case> oldRecordsList, Map<Id, Case> oldItems);
    void afterInsert(List<Case> newItems);
    void afterUpdate(List<Case> oldItems, List<Case> newItems);
    void afterDelete(Map<Id, Case> oldItems);
    void afterUndelete(List<Case> newRecordsList, Map<Id, Case> newItems);
}