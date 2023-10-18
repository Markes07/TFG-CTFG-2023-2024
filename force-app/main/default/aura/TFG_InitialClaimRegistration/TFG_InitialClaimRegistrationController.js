({
    doInit: function (component, event, helper) {	 
        helper.appendCSSRules('.cTFG_LaunchFlow .loadingSpinner { z-index: 99 !important; }', 
                              null,
                              component);
        var Maximum_size_Comment_Opening = $A.get("$Label.c.Maximun_size_comment_opening");
        component.set('v.MaximumSizeCommentOpening', Maximum_size_Comment_Opening);

        var action = component.get('c.getInitialData');
        action.setParams({
            recordId: component.get('v.accountId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {

                var mappedResult = response.getReturnValue();
                var contacts = mappedResult['contacts'];
                var selectedContactId = component.get('v.selectedContactId');
                var indexContact = 0;

                selectedContactId = contacts[indexContact].Id;
                component.set('v.selectedContactId', selectedContactId);  
                component.set('v.contacts', contacts);
                
                component.set('v.selectedOptionContactId', selectedContactId); 

            } else if (state === 'INCOMPLETE') {
                helper.printErrors('Error', true);
            } else if (state === 'ERROR') {
                helper.printErrors(response.getError(), true);
            }

        });
        
        $A.enqueueAction(action);

    },

    changeConctact: function (component, event, helper) {
        var selectedOptionContactId = component.get('v.selectedOptionContactId');
        var selectedContactId = component.get('v.selectedContactId');
        var listContacts = component.get("v.contacts");
        var contact = new Object();
        listContacts.forEach(function(element){
            if(element.Id === selectedOptionContactId){
                contact = element;
            }
        });
        component.set('v.selectedContactId' , selectedOptionContactId)
    },

    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');

        var actionFired = event.getParam('action');
        switch(actionFired) {
            case 'NEXT':
                if (helper.checkFormValidity(component, 'step1Form')) {
                    navigate(actionFired);
                }
                break;
            default:
                navigate(actionFired);
        }
    },
    
    handleChangeComment: function(component, event, helper) {        
    	var commentLegth = component.find("step1Form").get("v.value").length;
        var Maximum_size_Comment_Opening = component.get('v.MaximumSizeCommentOpening');
        var isVisibleMaxLenghtMessage = component.get('v.isVisibleMaxLenghtMessage');
        
        if(isVisibleMaxLenghtMessage == false && commentLegth >= Maximum_size_Comment_Opening){
           component.set("v.isVisibleMaxLenghtMessage", true);
        }
        else if(isVisibleMaxLenghtMessage == true  && commentLegth < Maximum_size_Comment_Opening){
           component.set("v.isVisibleMaxLenghtMessage", false);
        }
    },
})