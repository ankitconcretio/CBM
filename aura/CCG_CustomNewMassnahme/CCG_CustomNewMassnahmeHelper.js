({
	getCampaignRecord : function(component, campaignId) {
        var self = this;
		var action = component.get("c.getCampaignRecord");
        action.setParams({ recordId : campaignId });
        action.setCallback(this, function(response){
            var state  = response.getState();
            if(state==='SUCCESS'){
                var result = response.getReturnValue();
                
                if(result != null){
                    var campaignObject = result.campaignRecord;
                    var verwendungszweckRecord = result.verwendungszweckRecord;
                    
                    var massnahmeObj = component.get("v.newMassnahmeObj");
                    if(campaignObject.Status != undefined){massnahmeObj.CBM_Status__c = campaignObject.Status;}
                    if(campaignObject.CBM_Fremdliste__c != undefined){massnahmeObj.CBM_Fremdliste__c = campaignObject.CBM_Fremdliste__c;}
                    if(campaignObject.CBM_Aussendedatum__c != undefined){massnahmeObj.CBM_Aussendedatum_PAL__c = campaignObject.CBM_Aussendedatum__c;}
                    if(campaignObject.CBM_Affinit_t_Kontinent__c != undefined){massnahmeObj.CBM_Affinit_t_Kontinent__c = campaignObject.CBM_Affinit_t_Kontinent__c;}
                    if(campaignObject.CBM_Affinit_t_Arbeitsbereich__c != undefined){massnahmeObj.CBM_Affinit_t_Arbeitsbereich__c = campaignObject.CBM_Affinit_t_Arbeitsbereich__c;}
                    if(campaignObject.CBM_Affinit_t_Land__c != undefined){massnahmeObj.CBM_Affinit_t_Land__c = campaignObject.CBM_Affinit_t_Land__c;}
                    if(campaignObject.Type != undefined){massnahmeObj.CBM_Aktionstyp__c = campaignObject.Type;}
                    if(campaignObject.CBM_Link_zu_Muster__c != undefined){massnahmeObj.CBM_Link_zu_Muster__c = campaignObject.CBM_Link_zu_Muster__c;}
                    if(campaignObject.CBM_Verwendungszweck_ALT__c != undefined){massnahmeObj.CBM_Verwendungszweck_ALT__c = campaignObject.CBM_Verwendungszweck_ALT__c;}
                    if(campaignObject.CBM_Key_Account_Management__c != undefined){massnahmeObj.CBM_Key_Account_Management__c = campaignObject.CBM_Key_Account_Management__c;}
                    if(campaignObject.CBM_Bedankung_Dankbrief__c != undefined){massnahmeObj.CBM_Bedankung_Dankbrief__c = campaignObject.CBM_Bedankung_Dankbrief__c;}
                    if(campaignObject.CBM_Bedankung_individueller_Dank__c != undefined){massnahmeObj.CBM_Bedankung_individueller_Dank__c = campaignObject.CBM_Bedankung_individueller_Dank__c;}
                    if(campaignObject.CBM_Bedankung_Neuspender_Dankbrief__c != undefined){massnahmeObj.CBM_Bedankung_Neuspender_Dankbrief__c = campaignObject.CBM_Bedankung_Neuspender_Dankbrief__c;}
                    if(campaignObject.CBM_Bedankung_Neuspender_Individueller_D__c != undefined){massnahmeObj.CBM_Bedankung_Neuspender_Individueller_D__c = campaignObject.CBM_Bedankung_Neuspender_Individueller_D__c;}
                    if(campaignObject.CBM_Bedankung_Postkarte__c != undefined){massnahmeObj.CBM_Bedankung_Postkarte__c = campaignObject.CBM_Bedankung_Postkarte__c;}
                    if(campaignObject.CBM_Bedankung_Vorstand__c != undefined){massnahmeObj.CBM_Bedankung_Vorstand__c = campaignObject.CBM_Bedankung_Vorstand__c;}
                    if(campaignObject.CBM_Bedankung_Kanal__c != undefined){massnahmeObj.CBM_Bedankung_Kanal__c = campaignObject.CBM_Bedankung_Kanal__c;}
                    if(campaignObject.CBM_Bedankung_Format__c != undefined){massnahmeObj.CBM_Bedankung_Format__c = campaignObject.CBM_Bedankung_Format__c;}
                    component.set("v.newMassnahmeObj", massnahmeObj);
                    component.set("v.campaignObj", result);
                    
                    if(verwendungszweckRecord != null){
                        component.set("v.selectedLookUpVerwendungszweckRecord", verwendungszweckRecord);    
                    }
                    
                }
                else{
                    console.log('records not fetched');
                    self.showToast('Error', $A.get("$Label.c.CCG_Records_of_campaign_not_found"), 'Error');
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
    
    navigateToRecord : function(recordId){
        var navigateEvent = $A.get('e.force:navigateToSObject');
        navigateEvent.setParams({ 'recordId' : recordId });
        navigateEvent.fire();    
    },
    
    navigateToSObject : function(sObjectName){
        var navigateEvent = $A.get('e.force:navigateToObjectHome');
        navigateEvent.setParams({ 'scope' : sObjectName });
        navigateEvent.fire();    
    },
    
    getPicklistValues : function(component){
        var self = this;
        var action = component.get("c.getPicklistValues");
        var fieldApiNames = ['CBM_Status__c','CBM_Affinit_t_Land__c','CBM_Korrespondenzart__c',
                             'CBM_Affinit_t_Arbeitsbereich__c','CBM_Aktionstyp__c','CBM_Affinit_t_Kontinent__c',
                             'CBM_Verwendungszweck_ALT__c','CBM_Key_Account_Management__c','CBM_Bedankung_Format__c',
                             'CBM_Bedankung_Kanal__c'];
        action.setParams({
            'fieldApiNames': fieldApiNames,
            'objectName' : 'CBM_Massnahme__c'
        });
        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse != null){
                	component.set("v.pickListValMap", storeResponse);
                    var recordId = component.get("v.recordId");
                    if(recordId != null && recordId != ''){
                        component.set("v.showSpinner", true);
                    	self.getMassnahmeRecords(component);    
                    }
                }
                else{
                	console.log('Error in fetching picklist values'); 
                }
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
    
    saveMassnahmeRecord : function(component){
        var self = this;
        var action = component.get("c.upsertRecord");
        action.setParams({
            massnahmeObj : component.get("v.newMassnahmeObj")
        });
        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse != null){
                    var recordId = component.get("v.recordId");
                    if(recordId != null && recordId != ''){
                        self.showToast('Success', $A.get("$Label.c.CCG_Record_is_successfully_Updated"), 'success');       
                    }
                    else{
                        self.showToast('Success', $A.get("$Label.c.CCG_Record_is_successfully_Created"), 'success');        
                    }	
                    self.navigateToRecord(storeResponse.Id);   
                }
                else{
                	console.log('records not saved');
                    self.showToast('Error', $A.get("$Label.c.CCG_Error_Message_In_saving_any_Record"), 'Error');    
                }
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
    
    getMassnahmeRecords : function(component){
        var self = this;
        var action = component.get("c.getMassnamheRecord");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse != null){
                    if(storeResponse.massnahmeRecord != null){
                    	component.set("v.newMassnahmeObj", storeResponse.massnahmeRecord);
                        component.set("v.modalHeader", 'Edit '+ storeResponse.massnahmeRecord.Name);
                    }
                    if(storeResponse.campaignRecord != null){
                    	component.set("v.selectedLookUpCampaignRecord", storeResponse.campaignRecord);    
                    }
                    if(storeResponse.verwendungszweckRecord != null){
                    	component.set("v.selectedLookUpVerwendungszweckRecord", storeResponse.verwendungszweckRecord);    
                    }
                }
                else{
                    console.log('massnahme records not fetched');
                    self.showToast('Error', $A.get("$Label.c.CCG_Records_of_Massnahme_not_found"), 'Error');    
                }
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