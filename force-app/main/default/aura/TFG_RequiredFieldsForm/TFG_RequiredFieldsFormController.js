({
    init: function (component, event, helper) {    
        component.set('v.showFooter', 'false'); 
        component.set('v.contractRequired', true);
        component.set('v.MaximumSizeObservations', $A.get("$Label.c.SizeObservaciones"));  
        var recordId = component.get("v.accountId");
        component.set('v.isBack', true);
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set("v.today", today);	
        var tipo = component.get('v.selectedType');
        var subtipo = component.get('v.selectedSubType');
        var clase = component.get('v.selectedClassSubtype');
        var accountId = component.get('v.accountId');
        var contactId = component.get('v.contactId');
        var comments = component.get('v.comments');
        component.set('v.newClaimFields.Tipo_Reclamacion__c', tipo);
        component.set('v.newClaimFields.Subtipo_Reclamacion__c', subtipo);
        component.set('v.newClaimFields.Clase__c', clase);
        component.set('v.newClaimFields.AccountId', accountId);
        component.set('v.newClaimFields.ContactId', contactId);
        component.set('v.newClaimFields.Comentarios_Apertura__c', comments);   

        component.set('v.toggleSpinner', false);
        component.set('v.showFooter', 'true'); 
    },

    setLookupChange: function (component, event, helper) {
        var subtype = component.get('v.selectedSubType');
        var type = component.get('v.selectedType');
        var lookupContract = component.get('v.selectedLookUpContract');
        var lookupContractId = component.get('v.contractId');
        
        if (lookupContract == '') {               
            helper.applyCSS(component,'lookupContract','pillClass');                                                                 
        }     
        else {
            component.set('v.newClaimFields.ContractId__c', lookupContract.Id);
            helper.removeCSS(component,'lookupContract','pillClass');
        }  
    },

    handleNavigate: function (component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionFired = event.getParam('action');
        switch (actionFired) {
            case 'FINISH':
                helper.showSpinner(component);
                var valLookup = helper.validateLookup(component, event);
                var validReq = true;
                if (!valLookup) {
                    validReq = false;
                }
                if (validReq) {
                    helper.createCaseBBDD(component, event, helper);

                } else {
                    console.log('fail');
                    helper.fireToast(true, $A.get('$Label.c.Required_Fields'));
                    helper.hideSpinner(component);
                }
                break;
            default:
                var newClaimFields = component.get('v.newClaimFields');
                component.set('v.newClaim', JSON.stringify(newClaimFields));
                navigate(actionFired);
        }
    },
    
    handleChangeObservations: function(component, event, helper) {      
    	var observationsLegth = event.getSource().get("v.value").length;
        var observations = event.getSource().get("v.value");
        component.set('v.newClaimFields.Observaciones__c', observations); 
        var Maximum_size_Observations = component.get('v.MaximumSizeObservations');
        var isVisibleMaxLenghtMessage = component.get('v.isVisibleMaxLenghtMessage');
        
        if(isVisibleMaxLenghtMessage == false && observationsLegth >= Maximum_size_Observations){
           component.set("v.isVisibleMaxLenghtMessage", true);
        }
        else if(isVisibleMaxLenghtMessage == true  && observationsLegth < Maximum_size_Observations){
           component.set("v.isVisibleMaxLenghtMessage", false);
        }
    },
})