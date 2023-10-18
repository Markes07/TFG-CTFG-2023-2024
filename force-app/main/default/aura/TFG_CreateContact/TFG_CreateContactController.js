({
    doInit : function(component, event, helper) {
        // Código de inicialización si es necesario
    },

    handleInputChange : function(component, event, helper) {
        var contactRecord = component.get('v.contactRecord');
        var isNifValid = false;
        var isTelefonoValid = false;
        var isEmailValid = false;
        var isMetodoContactoValid = false;
        var isRolValid = false;

        // Validar NIF
        var nifRegex = /[0-9]{8}[A-Z]{1}/;
        isNifValid = nifRegex.test(contactRecord.NIF__c);
        if(isNifValid) {
            component.set('v.isNifValid', true);
        }
        else {
            component.set('v.isNifValid', false);
        }

        // Validar Email y Teléfono según el método de contacto
        var metodoContacto = contactRecord.Metodo_contacto__c;

        if (metodoContacto === "Email") {
            var emailValue = contactRecord.Email;
            var regExpEmailformat = /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/;
            var isFormatEmailValid = regExpEmailformat.test(emailValue);
            if(isFormatEmailValid) {
                component.set('v.isEmailValid', true);
                isEmailValid = true;
            }
            else {
                component.set('v.isEmailValid', false);
                isEmailValid = false;
            }

            // Resetear la validación del campo de Teléfono
            component.set('v.isTelefonoValid', true);
            isTelefonoValid = true;

        } else if (metodoContacto === "SMS" || metodoContacto === "Teléfono") {
            var telefonoValue = contactRecord.Telefono__c;
            var isTelefonoValid = /[0-9]{9}/.test(telefonoValue);
            if(isTelefonoValid) {
                component.set('v.isTelefonoValid', true);
            }
            else {
                component.set('v.isTelefonoValid', false);
            }

            // Resetear la validación del campo de Email
            component.set('v.isEmailValid', true);
            isEmailValid = true;
        }

        //Validar método de contacto seleccione un valor
        if(metodoContacto === "Seleccione un valor") {
            isMetodoContactoValid = false;
        }
        else {
            isMetodoContactoValid = true;
        }

        //Validar rol seleccione un valor
        var rol = contactRecord.Rol__c;
        if(rol === "Seleccione un valor") {
            isRolValid = false;
        }
        else {
            isRolValid = true;
        }

        // Guardar el registro solo si todos los campos son válidos
        var isFormValid = isNifValid && isTelefonoValid && isEmailValid && isMetodoContactoValid && isRolValid;

        if (isFormValid) {
            component.set("v.isFormValid", isFormValid);
        }
        else {
            component.set("v.isFormValid", isFormValid);
        }
    },

    saveRecord : function(component, event, helper) {
        var contactRecord = component.get('v.contactRecord');
        if(contactRecord.AccountId == "") {
            alert("Se debe rellenar el Cliente para poder continuar"); 
        }
        else {
            var action = component.get("c.createContact");
            action.setParams({
                "contactInserted": contactRecord
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var contactId = response.getReturnValue();
                    if (contactId) {
                        helper.showToast("Success", "Contacto creado correctamente", "");
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": contactId,
                            "slideDevName": "detail"
                        });
                        navEvt.fire();
                        $A.get("e.force:closeQuickAction").fire();
                    } else {
                        helper.showToast("Error", "Error al crear el contacto", "");
                    }
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors && errors[0] && errors[0].message) {
                        helper.showToast("Error", errors[0].message, "error");
                    } else {
                        helper.showToast("Error", "Error al crear el contacto", "");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    }
})