({
    doInit : function(component, event, helper){
        component.set("v.showSpinner", true);
        helper.getOpportunity(component);
    },
    
    cancelClick: function(c,e,h){
        $A.get("e.force:closeQuickAction").fire();
    },
    
    cancelToast : function(c,e,h){
        var tostId = document.getElementById("toastId");
        tostId.classList.add("slds-hide");
    },
    
    saveOpportunity : function(component, event, helper) {
        console.log(component.get("v.opportunityRecord"));
        var oppRecord = component.get("v.opportunityRecord");
        
        if((oppRecord.aktionRecord.Id == "" || oppRecord.aktionRecord.Id == undefined || oppRecord.aktionRecord.Id == null) || (oppRecord.verwendungsRecord.Id == "" || oppRecord.verwendungsRecord.Id == undefined || oppRecord.verwendungsRecord.Id == null) || (oppRecord.primaryContactRecord.Id == "" || oppRecord.primaryContactRecord.Id == null || oppRecord.primaryContactRecord.Id == undefined)){
            var tostId = document.getElementById("toastId");
            tostId.classList.remove("slds-hide");
        }
        else{
            component.set("v.showSpinner", true);
            helper.saveOpp(component);     
        }
    }   
})