({
    init: function(component, event, helper) {
        // Figure out which buttons to display
        var availableActions = component.get('v.availableActions');
        for (var i = 0; i < availableActions.length; i++) {
            if (availableActions[i] == "PAUSE") {
                component.set("v.canPause", true);
            } else if (availableActions[i] == "BACK") {
                component.set("v.canBack", true);
            } else if (availableActions[i] == "NEXT") {
                component.set("v.canNext", true);
            } else if (availableActions[i] == "FINISH") {
                component.set("v.canFinish", true);
            }
        }
    },
    onButtonPressed: function(component, event, helper) {
        // Figure out which action was called
        var actionClicked;
        if(event.getSource){
        	actionClicked = event.getSource().getLocalId();
        }else{
            actionClicked = event.currentTarget.id; 
            event.currentTarget.blur();
        } 
        
        // Call that action
        var navigate = component.getEvent("navigateFlowEvent");
        navigate.setParam("action", actionClicked);
        navigate.fire();
    },
    closeTab: function(component, event, helper) {
         // Close the flow by destroying the component
         var workspaceAPI = component.find("workspace");
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                workspaceAPI.disableTabClose({
                    tabId: focusedTabId,
                    disabled: false
                }).then(function(response) {
                    workspaceAPI.closeTab({tabId: focusedTabId});
                });
                
            }).catch(function(error) {
                console.log(error);
            });
    },
    
    finishTab : function(component, event, helper){
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.disableTabClose({
                tabId: focusedTabId,
                disabled: false
            }).then(function(response) {
                workspaceAPI.closeTab({tabId: focusedTabId});
            });
            
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    openCloseTabDialog: function(component, event, helper) {
        
        $A.createComponents([
            ["div",{
                "aura:id" : "closeTabDialog",
                "class" : "slds-p-around_medium",
            }],
            ["aura:html",{
                "tag": "div",
                "body": $A.get("$Label.c.Exit_Confirmation"),
                "HTMLAttributes": {
                    "class" : "slds-text-heading_medium slds-m-bottom_large slds-text-align_center"
                }                
            }],
            ["div",{
                "class" : "slds-text-align_center",
            }],
            ["lightning:button",{
                "label" : $A.get("$Label.c.Yes"),
                "variant" : "brand",
                "class" : "slds-m-right_medium",
                "onclick" : component.getReference("c.closeTab")
            }],  
            ["lightning:button",{
                "label" : $A.get("$Label.c.No"),
                "variant" : "neutral",
                "onclick" : component.getReference("c.closeDialog")
            }],                  
            ],
            function(components, status, errorMessage) {
                if (status === "SUCCESS") {
                    var outterContainer = components[0];
                    var textLine = components[1];
                    var buttonContainer = components[2];
                    var buttonOkay = components[3];
                    var buttonCancel = components[4];
                    
                    var body = buttonContainer.get("v.body");
                    body.push(buttonOkay);
                    body.push(buttonCancel);
                    buttonContainer.set("v.body", body);

                    body = outterContainer.get("v.body");
                    body.push(textLine);
                    body.push(buttonContainer);
                    outterContainer.set("v.body", body);
                    
                    var dialog = component.find('overlayLib').showCustomModal({
                        body: outterContainer,
                        showCloseButton: false
                    });  
                    
                    component.set('v.dialogPromisse', dialog);                    
                    
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                    // Show error message
                }
            }
        );        

    },    
    closeDialog: function(component, event, helper) {
        component.get('v.dialogPromisse').then(function (overlay) {
            //closes the modal immediately
            overlay.close();
        });
    }
})