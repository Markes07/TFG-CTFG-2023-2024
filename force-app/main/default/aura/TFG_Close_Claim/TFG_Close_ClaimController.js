({
	doInit : function(component, event, helper) {
		helper.initialize(component,event,helper);
	},

	closeClaim : function(component, event, helper){
		var action = component.get("c.closeSaveClaim");
		var cause = component.get("v.selectedCause");
		var result = component.get("v.selectedResult");
		var comments = component.get("v.comments");
		action.setParams({
			selectedCause : component.get("v.selectedCause"),
			selectedResult : component.get("v.selectedResult"),
			comments : component.get("v.comments"),
			recordId : component.get("v.recordId")
		});

		action.setCallback(this, function(response){
			component.set("v.pulse", false);
			//helper.hideSpinner(component);
			var state = response.getState();
			if(state === "SUCCESS"){
				var res = response.getReturnValue();
				if(res === 'OK'){
					component.set("V.selectedCause","");
					component.set("V.selectedReason","");
					component.set("V.comments","");
					helper.initialize(component,event,helper);					
					$A.get('e.force:refreshView').fire();	
				}else if(res == 'KO'){
					helper.showToast("No eres propietario del caso","error", "Para poder cerrar la reclamación debes ser propietario de la misma" ,"dismissible");
				}else{
					console.log("ha ocurrido un error");
				}
			}else if (state === "ERROR"){
				var error = response.getError();
				console.log(error);
			}
		});
		var sizeCommentMin = parseInt($A.get("$Label.c.Minimun_size_comment_close"));
		if(cause && result && comments && comments.length >= sizeCommentMin){
			$A.enqueueAction(action);
		}else{
			helper.checkFormValidity(component, "form_Valid");
			helper.checkFormValidity(component, "form_Valid2");
			component.set("v.pulse", false);
		}
	},

	onSelectedResult : function(component, event, helper){
		var selectedValue = component.get("v.selectedResult");
	},

    onSelectedCause : function(component, event, helper){
		var selectedValue = component.get("v.selectedCause");
	}
})