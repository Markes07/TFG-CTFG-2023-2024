({

    doInit: function(cmp,evt,callback) {
        cmp.set("v.displayList",true);
    },

	searchField: function(component, event, helper){
        var textoBuscado = event.getSource().get("v.value");
        if(textoBuscado != ''){
            component.set("v.displayList",true);
        }

        var action = component.get("c.getResults");
        action.setParams({
            "Field": 'Name',
            "searchName": textoBuscado   
       });

        action.setCallback(this, function(response) {
            var state = response.getState();

            if(state === "SUCCESS") {
                component.set("v.searchAccounts", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    setSelectedRecord: function(component, event, helper){
        var textoBuscado = event.currentTarget.id;
        var nameAccount = event.currentTarget.dataset.name;
        component.set("v.selectedAccountName",nameAccount);
        component.set("v.selectedAccountId",textoBuscado);
        component.set("v.displayList",false);
    }
})