({
    init : function(component, event, helper) {
        
        var progressIndicator = component.find('progressIndicator');
        var stepsDefinition = [];
        for (let step of component.get('v.stages')) { 
            stepsDefinition.push(["lightning:progressStep",
                        {
                            "aura:id": "step_" + step,
                            "label": step,
                            "value": step
                        }]);         
        }
        
        $A.createComponents(stepsDefinition,
            function(steps, status, errorMessage) {
                // Add the new step to the progress array
                if (status === "SUCCESS") {                 
                    var body = progressIndicator.get("v.body");
                    for (let step of steps) {
                        body.push(step);
                    }                       
                    progressIndicator.set("v.body", body);
                    
                } else if (status === "INCOMPLETE") {
                    // Show offline error
                    console.log("No response from server, or client is offline.")
                } else if (status === "ERROR") {
                        // Show error message
                        console.log("Error: " + errorMessage);
                    }
            }
        );
    }
 })