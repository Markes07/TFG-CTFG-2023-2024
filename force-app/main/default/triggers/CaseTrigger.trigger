trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TFG_Case_Handler handler = new TFG_Case_Handler();
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            handler.beforeInsert(Trigger.new);
        } else if (Trigger.isAfter) {
            handler.afterInsert(Trigger.new);
        }        
    }
    else if (Trigger.isUpdate) {
        if (Trigger.isBefore) {
            //handler.beforeUpdate(Trigger.oldMap, Trigger.newMap);
        } else if (Trigger.isAfter) {
             handler.afterUpdate(Trigger.old, Trigger.new);
        } 
    }
    else if (Trigger.isDelete) {
        if (Trigger.isBefore) {
            //handler.beforeDelete(Trigger.old, Trigger.oldMap);
        } else if (Trigger.isAfter) {
            //handler.afterDelete(Trigger.oldMap);
        } 
    }
}