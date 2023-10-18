({
    validateLookup: function (component, event, helper) {
        var contractId = component.get('v.contractId');
        var completed = true;

        if (component.get('v.contractRequired')) {
            var forclose = component.find('lookupContract');
            if (forclose && $A.util.isEmpty(contractId)) {
                forclose.setError($A.get("$Label.c.CompleteField"));
                completed = false;
            }
        }     
        return completed;
    },

    fireToast: function (error, message) {
        var toastEvent = $A.get('e.force:showToast');
        if (!error) {
            toastEvent.setParams({
                'message': message,
                'type': 'success',
                'duration': '3000'
            });
        } else {
            toastEvent.setParams({
                'message': message,
                'type': 'error',
                'duration': '3000'
            });
        }
        toastEvent.fire();
    },

    removeAccents: function (str) {
        var chars = {
            "á": "a", "é": "e", "í": "i", "ó": "o", "ú": "u",
            "à": "a", "è": "e", "ì": "i", "ò": "o", "ù": "u", "ñ": "n",
            "Á": "A", "É": "E", "Í": "I", "Ó": "O", "Ú": "U",
            "À": "A", "È": "E", "Ì": "I", "Ò": "O", "Ù": "U", "Ñ": "N"
        }
        var expr = /[áàéèíìóòúùñ]/ig;
        var res = str.replace(expr, function (e) { return chars[e] });
        return res;
    },

    formatSystemDate: function (requestedDate) {
        var inputDate = requestedDate;
        var outputDate = new Date();
        var dd = inputDate.getDate();
        var mm = inputDate.getMonth() + 1;
        var yyyy = inputDate.getFullYear();

        if (dd < 10) {
            dd = '0' + dd;
        }
        if (mm < 10) {
            mm = '0' + mm;
        }
        outputDate = yyyy + '-' + mm + '-' + dd;

        return outputDate;
    },

    createCaseBBDD: function (component, event, helper) {
        //helper.showSpinner(component);
        var caseInsert = component.get("v.newClaimFields");
        console.log(caseInsert);
        var action = component.get("c.insertClaim");
        action.setParams({
            caseClaim: caseInsert
        });

        action.setCallback(this, function (response) {
            //helper.hideSpinner(component);
            var state = response.getState();
            if (state === "SUCCESS") {
                var Id = response.getReturnValue();
                if (Id != '') {
                    component.set('v.Id', Id);
                    helper.openTab(component, event, helper);
                    var footerFlowCmp = component.find("footerFlowCmp");
                    footerFlowCmp.finishFlow();
                } else {
                    helper.showToast("", "error", $A.get("$Label.c.UnknownError"), 'sticky');
                }

            } else if (state === 'INCOMPLETE') {
                console.log($A.get('$Label.c.Incomplete_Request'));
                helper.printErrors($A.get('$Label.c.Incomplete_Request'), true);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
                helper.printErrors(errors, true);
            }
        });
        $A.enqueueAction(action);

    },

    openTab: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var recordId = component.get("v.Id");
        if (recordId) {
            workspaceAPI.openTab({
                url: '/lightning/r/Case/' + recordId + '/view',
                focus: true
            }).then(function (response) {
                $A.get('e.force:refreshView').fire();
                workspaceAPI.getTabInfo({
                    tabId: response
                }).then(function (tabInfo) {
                    console.log("The recordId for this tab is: " + tabInfo.recordId);
                });
            }).catch(function (error) {
                console.log(error);
            });
        }
    },

    applyCSS: function(cmp, element ,styleClass) {
        var cmpTarget = cmp.find(element);
        $A.util.addClass(cmpTarget,styleClass);
    },
    
    removeCSS: function(cmp, element , styleClass) {
        var cmpTarget = cmp.find(element);
        $A.util.removeClass(cmpTarget,styleClass);
    },

    accordionInit: function (component, event, helper) {
        // Validación mostrar acordeones según si son requeridos o no
        var valSectionContract = component.get("v.contractRequired");
        component.set('v.activeSections', this.validAccordion(valSectionContract));
    },
    
    validAccordion: function(valSectionContracton) {
    	var array = [];
    	if(valSectionContract) {
    		array.push('Customer');
		}
        array.push('Observaciones');
        return array;
	}
})