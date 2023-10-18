({
    showToast: function (title, type, message, mode) {
        if (!mode)
            mode = "sticky";
        if (!type)
            type = "other";      
        if (!title)
            title = "";
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message,
            "mode": mode
        });

        toastEvent.fire();
    },
    showSuccessToast: function (title, message) {
        this.showToast(title, "success", message);
    },
    showErrorToast: function (title, message) {
        this.showToast(title, "error", message);
    },
    showWarningToast: function (title, message) {
        this.showToast(title, "warning", message);
    },
    showInfoToast: function (title, message) {
        this.showToast(title, "info", message);
    },
    showSpinner: function (component) {

        var baseComponent = this.getComponentReference(component, 'c:TFG_BaseComponent');

        if (baseComponent) {

            var spinner = baseComponent.find("baseComponentSpinner");

            if ($A.util.hasClass(spinner, "slds-hide")) {
                this.toggleSpinner(baseComponent, spinner);
            }
        }
    },
    hideSpinner: function (component) {

        var baseComponent = this.getComponentReference(component, 'c:TFG_BaseComponent');

        if (baseComponent) {
            var spinner = baseComponent.find("baseComponentSpinner");

            if (!$A.util.hasClass(spinner, "slds-hide")) {
                this.toggleSpinner(baseComponent, spinner);
            }
        }
    },
    toggleSpinner: function (component, spinner) {

        if (spinner == undefined) {
            var baseComponent = this.getComponentReference(component, 'c:TFG_BaseComponent');
            spinner = baseComponent.find("baseComponentSpinner");
        }

        $A.util.toggleClass(spinner, "slds-hide");
    },
    printErrors: function (errors, showToast) {

        var msg;

        if (errors) {

            if (typeof errors == 'string') {
                msg = errors;
            } else {
                msg = this.getFormattedErrors(errors);
            }

        } else {
            msg = $A.get("$Label.c.UnknownError");
        }

        $A.log(msg);

        if (showToast) {
            this.showToast($A.get("$Label.c.GenericErrorTitle"), "error", msg);
        }
    },
    addClass: function (element, className) {

        element = this.getElement(element);

        element.classList.add(className);
    },
    removeClass: function (element, className) {

        element = this.getElement(element);

        element.classList.remove(className);
    },
    hasClass: function (element, className) {

        element = this.getElement(element);

        return element && element.classList.contains(className);
    },
    toggleClass: function (element, className) {

        element = this.getElement(element);

        if (element) {
            if (this.hasClass(element, className))
                element.classList.remove(className);
            else
                element.classList.add(className);
        }

    },
    getElement: function (element) {

        if (typeof element === "string")
            element = document.querySelector(element);

        return element;
    },
    getFormattedTime: function (date) {
        return this.getFormattedDateTime(date, $A.get("{!$Locale.timeFormat}"));
    },
    getFormattedDate: function (date) {
        return this.getFormattedDateTime(date, $A.get("{!$Locale.dateFormat}"));
    },
    getFormattedDateTime: function (date, format) {

        if (!date)
            date = new Date();

        if (!format)
            format = $A.get("{!$Locale.datetimeFormat}");

        try {
            return $A.localizationService.formatDate(date, format);
        } catch (err) {
            return "-";
        }
    },
    getFormattedErrors: function (errors) {
        var msg = '';
        for (var i = 0; i < errors.length; i++) {
            msg += errors[i].message + "\n";
        }
        return msg;
    },
    encodeData: function (data) {
        return Object.keys(data).map(function (key) {
            return [key, data[key]].map(encodeURIComponent).join("=");
        }).join("&");
    },
    navigateToUrl: function (url, params) {

        if (params) {
            url = url + '?' + this.encodeData(params);
        }

        $A.get("e.force:navigateToURL").setParams({ "url": url }).fire();
    },
    getComponentReference: function (component, componentType) {

        var componentReference = component;

        while (componentReference.getType() != componentType) {
            componentReference = componentReference.getSuper();
            if (!componentReference)
                break;
        }

        return componentReference;
    },
    checkFormValidity: function (component, elementsId) {

        var formElements = component.find(elementsId);

        if ($A.util.isArray(formElements)) {
            return formElements.reduce(function (validSoFar, inputCmp) {
                // Displays error messages for invalid fields
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
        }

        formElements.showHelpMessageIfInvalid();

        return formElements.get('v.validity').valid;
    },
    appendCSSRules: function (cssRules, callbackFunction, component) {

        var baseComponent = this.getComponentReference(component, 'c:TFG_BaseComponent');
        var baseArguments = arguments;

        $A.createComponent(
            "c:TFG_cssRules",
            {
                "cssRules": cssRules
            },
            function (cssRulesComponent, status, errorMessage) {
                //Add the new button to the body array
                if (status === "SUCCESS") {
                    var body = baseComponent.get("v.body");
                    body.push(cssRulesComponent);
                    baseComponent.set("v.body", body);

                    if (callbackFunction)
                        callbackFunction.apply(null, Array.prototype.slice.call(baseArguments, 2));

                } else {
                    console.log("Error creating CSS Rules component: " + errorMessage);
                }
            }
        );
    },
    getElementPosition: function (el) {
        var xPos = 0;
        var yPos = 0;

        while (el) {
            if (el.tagName == "BODY") {
                // deal with browser quirks with body/window/document and page scroll
                var xScroll = el.scrollLeft || document.documentElement.scrollLeft;
                var yScroll = el.scrollTop || document.documentElement.scrollTop;

                xPos += (el.offsetLeft - xScroll + el.clientLeft);
                yPos += (el.offsetTop - yScroll + el.clientTop);
            } else {
                // for all other non-BODY elements
                xPos += (el.offsetLeft - el.scrollLeft + el.clientLeft);
                yPos += (el.offsetTop - el.scrollTop + el.clientTop);
            }

            el = el.offsetParent;
        }
        return {
            x: xPos,
            y: yPos
        };
    },

    removeAcents: function (str) {
        var chars = {
            "á": "a", "é": "e", "í": "i", "ó": "o", "ú": "u",
            "à": "a", "è": "e", "ì": "i", "ò": "o", "ù": "u", "ñ": "n",
            "Á": "A", "É": "E", "Í": "I", "Ó": "O", "Ú": "U",
            "À": "A", "È": "E", "Ì": "I", "Ò": "O", "Ù": "U", "Ñ": "N"
        }
        var expr = /[áàéèíìóòúùñ]/ig;
        var res = str.replace(expr, function (e) { return chars[e] });
        return res;
    }
})