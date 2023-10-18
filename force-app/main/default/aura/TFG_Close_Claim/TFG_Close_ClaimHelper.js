({
    initialize: function (component) {
        var action = component.get("c.getCauseAndResults");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                var listCause = res.listCausa;
                var listResult = res.listResultado;
                component.set("v.listCausa", listCause);
                component.set("v.listResult", listResult);
            } else if (state === "ERROR") {
                var error = response.getError();
                console.error(error);
            }
        });
        $A.enqueueAction(action);
    }
})