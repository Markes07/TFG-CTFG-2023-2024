({
    init: function(component, event, helper) {
        var flow = component.find("flow");
        var pageRef = component.get("v.pageReference");
        component.set('v.flowName', pageRef.state.c__flowname);
        component.set('v.flowInput', JSON.parse(pageRef.state.c__flowinput));
        flow.startFlow(component.get('v.flowName'), component.get('v.flowInput'));
    }
})