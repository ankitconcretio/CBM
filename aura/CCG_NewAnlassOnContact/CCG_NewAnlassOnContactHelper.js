({
	getRecordTypes : function(component){
    	var self = this;
		var action = component.get("c.getRecTypeValues");
        action.setParams({ objectName : "CBM_Aktion__c" });
        
        action.setCallback(this, function(response){
            var state  = response.getState();
            if(state==='SUCCESS'){
                var result = response.getReturnValue();
                if(result != null && result.length > 0){
                    component.set("v.aktionRecordTypes", result);
                    component.set("v.selectedRecordTypeId", result[0].value);
                    var anlassRecTypeName = '';
                    var anlassRecTypeId = '';
                    for(var i=0; i<result.length; i++){
                        if(result[i].label == 'Anlass'){
                        	anlassRecTypeName = result[i].label;
                            anlassRecTypeId = result[i].value;
                        }    
                    }
                    $A.get("e.force:closeQuickAction").fire();
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef : "c:CCG_CustomNewAktion",
                        componentAttributes: {
                            contactId : component.get("v.recordId"),
                            selectedRecordTypeId : anlassRecTypeId,
                            selectedRecordTypeName : anlassRecTypeName,
                            filterMassnahme : true
                        }
                    });
        			evt.fire();
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
})