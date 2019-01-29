({
    doInit : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:CCG_CustomNewAktion",
            componentAttributes: {
                recordId : component.get("v.recordId")
            }
        });
        evt.fire();	
    }
})