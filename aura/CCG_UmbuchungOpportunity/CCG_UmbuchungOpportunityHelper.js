({
    getOpportunity : function(component){
        var action = component.get("c.gettingOpportunity");        
        console.log('Opportunity Id:::'+component.get("v.recordId"));
        
        action.setParams({ oppId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnVal = response.getReturnValue(); 
                component.set('v.opportunityRecord',returnVal);
                component.set('v.oldOpportunity', returnVal);
                /*
                component.set('v.selectedLookUpVerwendungszweckRecord',returnVal.verwendungs);
                component.set('v.selectedLookUpAktionsRecord', returnVal.aktionName);
                component.set('v.selectedLookUpPrimaryContactRecord', returnVal.primaryContact);
                
                
                
                 console.log();
                console.log('quintungsId::'+returnVal.opportunty.CBM_QuittungsID__c);
                console.log(returnVal);
                console.log('tttfg'+returnVal.verwendungs.Name);
                console.log('jhkhghg'+returnVal.aktionName.Name);
                console.log('hnjddjdh'+returnVal.primaryContact.Name);*/
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
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
    
    saveOpp : function(component){
        var self = this;
        var oppRecord = component.get("v.opportunityRecord");
        var action = component.get("c.updateOpportunity");       
        action.setParams({objOpp : oppRecord.opportuntyRecord,
                          aktionsId : oppRecord.aktionRecord.Id,
                          verwendungsId : oppRecord.verwendungsRecord.Id,
                          contactId : oppRecord.primaryContactRecord.Id,
                          contactName : oppRecord.primaryContactRecord.Name
                         });
        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse.oppRecord != null){
                    if(oppRecord.opportuntyRecord.Id != storeResponse.oppRecord.Id){
                        //self.showToast('Success', 'Opportunity record has been created successfully', 'Success');
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title : 'Success',
                            type: 'Success',
                            mode: 'sticky',
                            message: 'Opportunity record has been created successfully',
                            messageTemplate: 'Opportunity {0} was created!',
                            messageTemplateData: [{
                                url: '/'+ storeResponse.oppRecord.Id,
                                label: storeResponse.oppRecord.Name,
                            }]
                        });
    					toastEvent.fire();
                    }
                    else{
                        self.showToast('Success', 'The record has been updated successfully', 'Success');    
                    }
                    $A.get("e.force:closeQuickAction").fire();
                    $A.get('e.force:refreshView').fire();
                }
                if(storeResponse.errorMsg != null){
                    var errorMessage = storeResponse.errorMsg;
                    var errorMsgToShow = 'Error in updating opportunity';
                    console.log('errorMsg : '+ errorMessage);
                    var index = errorMessage.indexOf("Value does not exist or does not match filter criteria");
                    if(index > -1){
                    	errorMsgToShow = errorMessage.substring(index, errorMessage.length);    
                    }
                    component.set("v.errorMsg", errorMsgToShow);
                    var tostId = document.getElementById("toastId");
            		tostId.classList.remove("slds-hide");
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);	    
    },  
})