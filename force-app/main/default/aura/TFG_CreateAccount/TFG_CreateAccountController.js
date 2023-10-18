({
    doInit : function(component, event, helper) {

    },

    saveRecord : function(component, event, helper) {
        var action = component.get('c.createAccount');
        var accountRecord = component.get('v.accountRecord');
        action.setParams({
            "accountInserted" : accountRecord
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var accountId = response.getReturnValue();
                if (accountId) {
                    helper.showToast("Success", "Cliente creado correctamente", "success");
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": accountId,
                        "slideDevName": "detail"
                    });
                    navEvt.fire();
                    $A.get("e.force:closeQuickAction").fire();
                } else {
                    helper.showToast("Error", "Unknown error", "error");
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    helper.showToast("Error", errors[0].message, "error");
                } else {
                    helper.showToast("Error", "Unknown error", "error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})