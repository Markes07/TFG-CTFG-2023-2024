({
    doInit: function (component, event, helper) {
        helper.getAccountId(component, event);
    },

    openTab: function (component, event, helper) {
        helper.newClaim(component);
    }
})