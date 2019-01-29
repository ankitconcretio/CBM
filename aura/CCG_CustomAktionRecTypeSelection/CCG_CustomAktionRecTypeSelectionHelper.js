({
    getRecordTypes : function(component){
    	var self = this;
		var action = component.get("c.getRecTypeValues");
        action.setParams({ objectName : "CBM_Aktion__c" });
        action.setCallback(this, function(response){
            component.set("v.showSpinner", false);
            var state  = response.getState();
            if(state==='SUCCESS'){
                var result = response.getReturnValue();
                if(result != null && result.length > 0){
                    component.set("v.aktionRecordTypes", result);
                    component.set("v.selectedRecordTypeId", result[0].value);
                }
                else{
                    console.log('record types not available');
                }
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);    
    },
    
	showToast : function(title, message, type){
    	var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : title,
            message: message,
            type: type
        });
        toastEvent.fire();    
    },
    
    navigateToSObject : function(sObjectName){
        var navigateEvent = $A.get('e.force:navigateToObjectHome');
        navigateEvent.setParams({ 'scope' : sObjectName });
        navigateEvent.fire();    
    },
})