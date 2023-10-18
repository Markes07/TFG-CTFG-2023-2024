// eslint-disable-next-line no-unused-expressions
({
    init: function (component, event, helper) {
        
        helper.appendCSSRules('.cFII_LC_LaunchFlow .loadingSpinner { z-index: 99 !important; }',
                              null,
                              component);
        
        //Get Type and Subtype from metadata
        helper.getTypesAndSubTypes(component, helper);  
    },

    handleNavigate: function (component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionFired = event.getParam('action');
        
        switch (actionFired) {
            case 'NEXT':
                if (helper.checkFormValidity(component, 'Type_Claim')) {
                    if (helper.checkFormValidity(component, 'Subtype_Claim')) {
                        navigate(actionFired);
                    }              
                }
                else {
                    helper.showToast('', "error" , $A.get('$Label.c.Selection_Required'), 'dismissible');
                }
                break;
            default:
                navigate(actionFired);
        }
    },

    onSelectType: function (component, event, helper) {
        helper.onSelectType(component, event, helper); 
    }, 

    onSelectSubType: function (component, event, helper) {
        helper.onSelectSubType(component, event, helper); 
    }    
})