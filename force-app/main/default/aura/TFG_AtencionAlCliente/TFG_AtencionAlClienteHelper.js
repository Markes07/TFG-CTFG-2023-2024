({
	getAccountId: function (component) {
		component.set("v.isSpinner", true);
		var client = component.get("c.getClient");
		client.setParams({
			accountId: component.get("v.recordId")
		});
		client.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.set("v.accountId", response.getReturnValue().Id);
			} else {
				console.log('Error');
				console.log(response.getError());
			}
		});
		$A.enqueueAction(client);

		var contracts = component.get("c.getContracts");
		contracts.setParams({
			accountId: component.get("v.recordId")
		});
		contracts.setCallback(this, function (response) {
			component.set("v.isSpinner", false);
			var state = response.getState();
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
				component.set('v.contractSize', storeResponse);
			}
			else {
				console.log('Error');
				console.log(response.getError());
			}
		});
		$A.enqueueAction(contracts);
	},

	refreshFocusedTab: function (component) {
		var workspaceAPI = component.find("workspace");
		var sObjName = component.get("v.sobjectType");
		var parentId;

		workspaceAPI.getFocusedTabInfo().then(function (response) {

			if (sObjName == 'Account' && response.parentTabId == null) {

				parentId = response.tabId;
				var sObjectEvent = $A.get("e.force:navigateToSObject");
				sObjectEvent.setParams({
					"recordId": response.recordId.substring(0, 15),
					"slideDevName": "related"
				});
				sObjectEvent.fire();
			}
			else {

				parentId = response.parentTabId;
				//Obtenemos la info del tab padre
				workspaceAPI.getTabInfo({
					tabId: parentId
				}).then(function (infoTabParent) {
					for (let tab of infoTabParent.subtabs) {
						if (tab.pageReference.attributes.objectApiName == "Account") {
							//Volvemos a abrir la subtab con los mismos datos
							workspaceAPI.openSubtab({
								parentTabId: tab.parentTabId,
								url: tab.url,
								focus: tab.focused
							}).then(function (response) {
								if (tab.focused) {
									workspaceAPI.focusTab({ tabId: response });
								}
							});
							//Nos aseguramos que la tab anterior se cierra
							workspaceAPI.closeTab({
								tabId: tab.tabId
							});
						} else {
							workspaceAPI.refreshTab({
								tabId: tab.tabId,
								includeAllSubtabs: true
							});
						}
					}
				})
			}
		})
			.catch(function (error) {
				console.log('ERROR');
				console.log(error);
			});
	},

	newClaim: function (component) {
		var contractSize = component.get('v.contractSize');
		if(contractSize == 0) {
			alert('PARA PODER ABRIR UNA RECLAMACIÓN EL CLIENTE DEBE TENER CONTRATOS');
		}
		else {
			component.set("v.isSpinner", true);
			var workspaceAPI = component.find("workspace");
			var pageReference = {
				"type": "standard__component",
				"attributes": {
					"componentName": "c__TFG_LaunchFlow"
				},
				"state": {
					"c__flowname": "TFG_FLW_Registro_de_Reclamacion",
					"c__flowinput": JSON.stringify([{ name: "accountId", type: "String", value: component.get('v.accountId') }])
				}
			};
			workspaceAPI.openTab({
				pageReference: pageReference,
				focus: true
			}).then(function (tabId) {
				workspaceAPI.setTabIcon({
					tabId: tabId,
					icon: "standard:default",
					iconAlt: "Nueva Reclamacion"
				});
				component.set("v.isSpinner", false);

				workspaceAPI.setTabLabel({
					tabId: tabId,
					label: $A.get("$Label.c.New_Claim")
				}).then(function (tabInfo) {
					workspaceAPI.disableTabClose({
						tabId: tabId,
						disabled: true
					});
					component.set("v.isSpinner", false);
				});
			}).catch(function (error) {
				component.set("v.isSpinner", false);
				console.log(error);
			});
		}	
	},

	showErrorToast: function(texto) {
        const toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({
			type: 'error',
			message: texto,
			duration: '8000'
		});
		toastEvent.fire();
    },

	createComponent: function (name, data) {
		return new Promise(
			$A.getCallback(
				(resolve, reject) => {
					$A.createComponent(name, data,
						(component, status, error) => {
							if (status == "SUCCESS") {
								resolve(component);
							}
							else {
								reject(error.message);
							}
						});
				}
			)
		);
	},

	createComponentList: function (data) {
		return new Promise(
			$A.getCallback(
				(resolve, reject) => {
					$A.createComponents(data,
						(componentList, status, error) => {
							if (status == "SUCCESS") {
								resolve(componentList);
							}
							else {
								reject(error.message);
							}
						});
				}
			)
		);
	},
    
    showToast : function(title, msg, toastType) {
        let toastEvent = $A.get( 'e.force:showToast' );
        toastEvent.setParams({
            title   : title,
            message : msg,
            type    : toastType
        });
        toastEvent.fire();
    }
})