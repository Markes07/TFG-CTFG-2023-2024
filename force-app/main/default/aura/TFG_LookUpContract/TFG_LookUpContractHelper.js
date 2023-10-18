({
    setInitialRecord: function (component, event, recordId) {
        var action = component.get("c.fetchRecordbyId");
        action.setParams({
            'recordId': recordId,
            'searchFields': component.get("v.searchFields")
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.
                if (storeResponse != null) {
                    component.set("v.listOfSearchRecords", storeResponse);
                }
            } else if (state === 'INCOMPLETE') {
                component.set("v.message", $A.get('$Label.c.Incomplete_Request'));
                helper.printErrors($A.get('$Label.c.Incomplete_Request'), true);
                
            } else if (state === 'ERROR') {
                // Javascript error
                component.set('v.message', 'Ups! Something has gone wrong.');
                helper.printErrors(response.getError(), true);
            }
        });
        // enqueue the Action
        $A.enqueueAction(action);
    },
    
    searchHelper: function (component, event, helper, getInputkeyWord) {
        // call the apex class method 
        var action = component.get("c.fetchRecord");
        // set param to method  
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'searchFields': component.get("v.searchFields"),
            'filter': component.get("v.filter"),
            'orderBy': component.get("v.orderBy"),
            'query': component.get("v.query")
        });
        // set a callBack    
        action.setCallback(this, function (response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                // if storeResponse size is equal 0 ,display No Result Found... message on screen.                }
                if (storeResponse.length == 0) {
                    component.set("v.message", $A.get("$Label.c.No_resultados"));
                } else {
                    component.set("v.message", $A.get("$Label.c.Search"));
                }
                // set searchResult list with return value from server.
                var records = 25;
                if (storeResponse.length < 25) {
                    records = storeResponse.length;
                } 
                component.set("v.listOfSearchRecords", storeResponse.slice(0,25));
            } else if (state === 'INCOMPLETE') {
                component.set("v.message", $A.get('$Label.c.Incomplete_Request'));
                helper.printErrors($A.get('$Label.c.Incomplete_Request'), true);
                
            } else if (state === 'ERROR') {
                // Javascript error
                component.set('v.message', 'Ups! Something has gone wrong.');
                helper.printErrors(response.getError(), true);
            }
        });
        // enqueue the Action  
        $A.enqueueAction(action);
    },
    
    onBlurFocus: function (component, event, helper) {
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        component.set('v.hasFocus', false);
    },
    
    onClear: function (component, event, helper) {
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField");
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        component.set("v.searchKeyWord", '');
        component.set("v.listOfSearchRecords", null);
        component.set("v.selectedRecord", null);
        component.set('v.value', '');
        helper.onBlurFocus(component, event, helper);
    }
})