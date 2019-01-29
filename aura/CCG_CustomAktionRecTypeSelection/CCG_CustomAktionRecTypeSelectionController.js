({
	doInit : function(component, event, helper) {
        component.set("v.showModal", true);
        helper.getRecordTypes(component);
	},
    
    clickNext : function(component, event, helper){
        var aktionRecordTypes = component.get("v.aktionRecordTypes");
        for(var i=0; i<aktionRecordTypes.length; i++){
            if(aktionRecordTypes[i].value == component.get("v.selectedRecordTypeId")){
            	component.set("v.selectedRecordTypeName", aktionRecordTypes[i].label);
                break;
            }    
        }
        var fromRelatedTab = component.get("v.fromRelatedTab");
        if(fromRelatedTab == true){
        	var recTypeSelect = $A.get("e.c:CCG_AktionRecTypeSelEvent");
            recTypeSelect.setParams({
                "recTypeId": component.get("v.selectedRecordTypeId"),
                "recTypeName": component.get("v.selectedRecordTypeName")
            });
            recTypeSelect.fire();    
        }
        else{
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "c:CCG_CustomNewAktion",
                componentAttributes: {
                    selectedRecordTypeId : component.get("v.selectedRecordTypeId"),
                    selectedRecordTypeName : component.get("v.selectedRecordTypeName")
                }
            });
            evt.fire();    
        }
    },
    
    closeModel : function(component, event, helper){
        helper.navigateToSObject('CBM_Aktion__c'); 
    },
})