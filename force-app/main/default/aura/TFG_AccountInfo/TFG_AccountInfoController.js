({
	navegarCliente : function(component, event, helper) {
        event.preventDefault();
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            url: '/lightning/r/Account/' + component.get('v.accountId') + '/view',
            focus: true
        })
        .catch(function(error) {
            console.log(error);
        });
	}
})