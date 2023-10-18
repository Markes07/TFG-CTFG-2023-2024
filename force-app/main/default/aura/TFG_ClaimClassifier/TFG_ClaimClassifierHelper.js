({
    getTypesAndSubTypes: function (component, helper) {
        var action = component.get('c.getTypesAndSubTypes');

        action.setCallback(this, function (response) {
            
            var state = response.getState();
			
            if (state === 'SUCCESS') {
                var results = response.getReturnValue();
                var selectedType = component.get('v.selectedType');
                var customerTypeMgsByType = results['customerTypeMgsByType'];
                var customerSubTypeAndMsgByTypeDesc = results['customerSubTypeAndMsgByTypeDesc'];
                var codeAndCustomerType = results['codeAndCustomerType'];
                var codeAndCustomerSubType = results['codeAndCustomerSubType'];
                var classAndCustomerSubType = results['classAndCustomerSubType'];

                component.set('v.customerTypeMgsByType', customerTypeMgsByType);
                component.set('v.customerSubTypeAndMsgByTypeDesc', customerSubTypeAndMsgByTypeDesc);
                component.set('v.codeAndCustomerType', codeAndCustomerType);
                component.set('v.codeAndCustomerSubType', codeAndCustomerSubType);
                component.set('v.classAndCustomerSubType', classAndCustomerSubType);

                var typeOptions = [];
                for (var typeDesc in results['customerTypeMgsByType']) {
                    typeOptions.push({ desc: typeDesc });
                }
                               
                if (!$A.util.isEmpty(selectedType)) {
            		component.set('v.clarificationType', customerTypeMgsByType[selectedType]);
                    
                	helper.getSubTypeOptions(component, selectedType, customerSubTypeAndMsgByTypeDesc);
                    
                    let selectedSubType = component.get('v.selectedSubtype');
                    if (!$A.util.isEmpty(selectedSubType)) {
                        let subTypeDescription = customerSubTypeAndMsgByTypeDesc[selectedType];
                        component.set('v.clarificationSubType', subTypeDescription[selectedSubType]);  
                    }
                }
                component.set('v.typeOptions', typeOptions);
  
            } else if (state === 'INCOMPLETE') {
                helper.printErrors($A.get('$Label.c.Incomplete_Request'), true);

            } else if (state === 'ERROR') {
                helper.printErrors(response.getError(), true);
            }
        });
        
        $A.enqueueAction(action);
    },

    cleanSelectedValues: function (component) {
        component.set('v.selectedType', '');
        component.set('v.selectedSubtype', '');
        component.set('v.clarificationType', '');
        component.set('v.clarificationSubType', '');
        component.set('v.subTypeOptions', []);
    },

    getSubTypeOptions: function (component, selectedType, customerSubTypeAndMsgByTypeDesc) {
        var subTypes = customerSubTypeAndMsgByTypeDesc[selectedType];
        var subTypeOptions = [];
        for (var subTypeDesc in subTypes) {
            subTypeOptions.push({ desc: subTypeDesc });
        }
        
        if (subTypeOptions.length == 1) {
            component.set('v.selectedSubtype', subTypeOptions[0].desc);
        } else {
            subTypeOptions.sort((a,b) => (a.desc > b.desc) ? 1 : ((b.desc > a.desc) ? -1 : 0));
        }
        component.set('v.subTypeOptions', subTypeOptions);
        
    },
   
    onSelectType: function (component, event, helper) {
        
        var selectedType = component.get('v.selectedType');
        var customerTypeMgsByType = component.get('v.customerTypeMgsByType');
        var customerSubTypeAndMsgByTypeDesc = component.get('v.customerSubTypeAndMsgByTypeDesc');
        var codeAndCustomerType = component.get('v.codeAndCustomerType');
        var codeAndCustomerSubType = component.get('v.codeAndCustomerSubType');

        if (!$A.util.isEmpty(selectedType)) {
            component.set('v.clarificationType', customerTypeMgsByType[selectedType]);
            component.set('v.clarificationSubType', '');
            
            if (codeAndCustomerType[selectedType]) {
                component.set('v.selectedCodeType', codeAndCustomerType[selectedType]);
            } else {
                component.set('v.selectedCodeType','');
            }
            
            helper.getSubTypeOptions(component, selectedType, customerSubTypeAndMsgByTypeDesc);
        } else {
            helper.cleanSelectedValues(component);
        }
        
    },    
    onSelectSubType: function (component, event, helper) {
          
        var selectedSubtype = component.get('v.selectedSubtype');
        var customerSubTypeAndMsgByTypeDesc = component.get('v.customerSubTypeAndMsgByTypeDesc');
        var codeAndCustomerType = component.get('v.codeAndCustomerType');
        var codeAndCustomerSubType = component.get('v.codeAndCustomerSubType');
        var classAndCustomerSubType = component.get('v.classAndCustomerSubType');
        
        if (!$A.util.isEmpty(component.get('v.selectedType')) && !$A.util.isEmpty(selectedSubtype)) {
            var subTypeDescription = customerSubTypeAndMsgByTypeDesc[component.get('v.selectedType')];
            component.set('v.clarificationSubType', subTypeDescription[selectedSubtype]);
            
            if (codeAndCustomerSubType[component.get('v.selectedSubtype')]) {
                component.set('v.selectedCodeSubType', codeAndCustomerSubType[component.get('v.selectedSubtype')]);
            } else {
                component.set('v.selectedCodeSubType', '');
            }
            
            if (classAndCustomerSubType[component.get('v.selectedSubtype')]) {
                component.set('v.selectedClassSubType', classAndCustomerSubType[component.get('v.selectedSubtype')]);
            
            } else {
                component.set('v.selectedClassSubType', '');
            }
            
        } else {
            component.set('v.clarificationSubType', '');
            component.set('v.selectedSubtype', '');
        }      
    }  
})