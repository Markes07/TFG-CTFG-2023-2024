({
    doInit: function (component, event, helper) {
      var getId = component.get('v.accountId');
      var initialised = component.get('v.initialised');
  
      component.set('v.errorMsg', '');
      var element = component.find('searchRes');
      $A.util.removeClass(element, 'slds-has-error');
  
      if (!$A.util.isEmpty(getId) && !initialised) {
        component.set('v.initialised', true);
        helper.setInitialRecord(component, event, getId);
      }
    },
  
    onFocusBlur: function (component, event, helper) {
      if (!component.get('v.disabled')) {
        if (!component.get('v.hasFocus') && $A.util.isEmpty(component.get('v.selectedAction'))) {
          var forOpen = component.find("searchRes");
          $A.util.addClass(forOpen, 'slds-is-open');
          $A.util.removeClass(forOpen, 'slds-is-close');
  
          var getInputkeyWord = component.get("v.searchKeyWord");
          helper.searchHelper(component, event, helper, getInputkeyWord);
          component.set('v.hasFocus', true);
        } else if (component.get('v.hasFocus')) {
          component.set("v.listOfSearchRecords", null);
          helper.onBlurFocus(component, event, helper);
        }
      }
    },
  
    onfocus: function (component, event, helper) {
      $A.util.addClass(component.find("mySpinner"), "slds-show");
      var forOpen = component.find("searchRes");
      $A.util.addClass(forOpen, 'slds-is-open');
      $A.util.removeClass(forOpen, 'slds-is-close');
  
      var getInputkeyWord = component.get("v.searchKeyWord");
      helper.searchHelper(component, event, helper, getInputkeyWord);
    },
  
    onblur: function (component, event, helper) {
      component.set("v.listOfSearchRecords", null);
      var forclose = component.find("searchRes");
      $A.util.addClass(forclose, 'slds-is-close');
      $A.util.removeClass(forclose, 'slds-is-open');
    },
  
    keyPressController: function (component, event, helper) {
      // get the search Input keyword   
      var getInputkeyWord = component.get("v.searchKeyWord");
      // check if getInputKeyWord size id more then 0 then open the lookup result List and 
      // call the helper 
      // else close the lookup result List part.   
      if (getInputkeyWord.length > 0) {
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        helper.searchHelper(component, event, helper, getInputkeyWord);
  
      } else {
        component.set("v.listOfSearchRecords", null);
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
      }
    },
  
    // function for clear the Record Selection 
    clear: function (component, event, helper) {
      helper.onClear(component, event, helper);
      component.set("v.isClear", true);
    },
  
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent: function (component, event, helper) {
      // get the selected record from the COMPONENT event  
      component.set('v.initialised', true);
  
      var selectedRecordGetFromEvent = event.getParam("recordByEvent");
      component.set("v.selectedRecord", selectedRecordGetFromEvent);
      component.set('v.value', selectedRecordGetFromEvent.Id);
      component.set("v.isClear", true);
  
      var skipHandleComponentEvent = component.get('v.skipHandleComponentEvent');
      if (!skipHandleComponentEvent) {
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
  
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
  
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');
      }
    },
  
    setError: function (component, event, helper) {
      var element = component.find('searchRes');
      var params = event.getParam('arguments');
      if (params && params.errorMsg !== '') {
        component.set('v.errorMsg', params.errorMsg);
        $A.util.addClass(element, 'slds-has-error');
      } else {
        component.set('v.errorMsg', '');
        $A.util.removeClass(element, 'slds-has-error');
      }
    },
  
    setSkipHandleComponentEvent: function (component, event, helper) {
      var params = event.getParam('arguments');
      if (params && params.skip === true) {
        component.set('v.skipHandleComponentEvent', true);
      } else {
        component.set('v.skipHandleComponentEvent', false);
      }
    },
  
    //set default function when this is not used.
    defaultOnChange: function (component, event, helper) {
    },
  })