({
	getMassnahmeRecord : function(component, massnahmeId) {
        var self = this;
		var action = component.get("c.getMassnahmeRecord");
        action.setParams({ recordId : massnahmeId });
        action.setCallback(this, function(response){
            var state  = response.getState();
            if(state==='SUCCESS'){
                var result = response.getReturnValue();
                
                if(result != null){
                    var massnahmeObject = result.massnahmeRecord;
                    var verwendungszweckRecord = result.verwendungszweckRecord;
                    
                    var aktionObj = component.get("v.newAktionObj");
                    if(massnahmeObject.CBM_Status__c != undefined){aktionObj.CBM_Status__c = massnahmeObject.CBM_Status__c;}
                    if(massnahmeObject.CBM_Fremdliste__c != undefined){aktionObj.Fremdliste__c = massnahmeObject.CBM_Fremdliste__c;}
                    if(massnahmeObject.CBM_Aussendedatum_PAL__c != undefined){aktionObj.CBM_Aussendedatum__c = massnahmeObject.CBM_Aussendedatum_PAL__c;}
                    if(massnahmeObject.CBM_Affinit_t_Kontinent__c != undefined){aktionObj.CBM_Affinit_t_Kontinent__c = massnahmeObject.CBM_Affinit_t_Kontinent__c;}
                    if(massnahmeObject.CBM_Affinit_t_Arbeitsbereich__c != undefined){aktionObj.CBM_Affinit_t_Arbeitsbereich__c = massnahmeObject.CBM_Affinit_t_Arbeitsbereich__c;}
                    if(massnahmeObject.CBM_Affinit_t_Land__c != undefined){aktionObj.CBM_Affinit_t_Land__c = massnahmeObject.CBM_Affinit_t_Land__c;}
                    if(massnahmeObject.CBM_Aktionstyp__c != undefined){aktionObj.CBM_Typ__c = massnahmeObject.CBM_Aktionstyp__c;}
                    if(massnahmeObject.CBM_Link_zu_Muster__c != undefined){aktionObj.CBM_Link_zu_Muster__c = massnahmeObject.CBM_Link_zu_Muster__c;}
                    if(massnahmeObject.CBM_Korrespondenzart__c != undefined){aktionObj.CBM_Korrenspondenzart__c = massnahmeObject.CBM_Korrespondenzart__c;}
                    if(massnahmeObject.CBM_Key_Account_Management__c != undefined){aktionObj.CBM_Key_Account_Management__c = massnahmeObject.CBM_Key_Account_Management__c;}
                    if(massnahmeObject.CBM_Bedankung_Dankbrief__c != undefined){aktionObj.CBM_Bedankung_Dankbrief__c = massnahmeObject.CBM_Bedankung_Dankbrief__c;}
                    if(massnahmeObject.CBM_Bedankung_individueller_Dank__c != undefined){aktionObj.CBM_Bedankung_individueller_Dank__c = massnahmeObject.CBM_Bedankung_individueller_Dank__c;}
                    if(massnahmeObject.CBM_Bedankung_Neuspender_Dankbrief__c != undefined){aktionObj.CBM_Bedankung_Neuspender_Dankbrief__c = massnahmeObject.CBM_Bedankung_Neuspender_Dankbrief__c;}
                    if(massnahmeObject.CBM_Bedankung_Neuspender_Individueller_D__c != undefined){aktionObj.CBM_Bedankung_Neuspender_Individueller_D__c = massnahmeObject.CBM_Bedankung_Neuspender_Individueller_D__c;}
                    if(massnahmeObject.CBM_Bedankung_Postkarte__c != undefined){aktionObj.CBM_Bedankung_Postkarte__c = massnahmeObject.CBM_Bedankung_Postkarte__c;}
                    if(massnahmeObject.CBM_Startdatum__c != undefined){aktionObj.CBM_Startdatum__c = massnahmeObject.CBM_Startdatum__c;}
                    if(massnahmeObject.CBM_Enddatum__c != undefined){aktionObj.CBM_Enddatum__c = massnahmeObject.CBM_Enddatum__c;}
                    if(massnahmeObject.CBM_Bedankung_Vorstand__c != undefined){aktionObj.CBM_Bedankung_Vorstand__c = massnahmeObject.CBM_Bedankung_Vorstand__c;}
                    if(massnahmeObject.CBM_Bedankung_Kanal__c != undefined){aktionObj.CBM_Bedankung_Kanal__c = massnahmeObject.CBM_Bedankung_Kanal__c;}
                    if(massnahmeObject.CBM_Bedankung_Format__c != undefined){aktionObj.CBM_Bedankung_Format__c = massnahmeObject.CBM_Bedankung_Format__c;}
                    component.set("v.newAktionObj", aktionObj);
                    component.set("v.massnahmeObj", massnahmeObject);
                    
                    if(verwendungszweckRecord != null){
                        component.set("v.selectedLookUpVerwendungszweckRecord", verwendungszweckRecord);    
                    }
                    
                }
                else{
                    console.log('records not fetched');
                    self.showToast('Error', $A.get("$Label.c.CCG_Records_of_Massnahme_not_found"), 'Error');
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
        var fieldApiNames = ['CBM_Key_Account_Management__c','CBM_Affinit_t_Arbeitsbereich__c','CBM_Affinit_t_Kontinent__c',
                             'CBM_Status__c','CBM_Affinit_t_Land__c','CBM_Korrenspondenzart__c','CBM_Typ__c',
                             'CBM_Bedankung_Format__c','CBM_Bedankung_Kanal__c'];
        action.setParams({
            'fieldApiNames': fieldApiNames,
            'objectName' : 'CBM_Aktion__c',
            'accId' : component.get("v.accountId"),
            'conId' : component.get("v.contactId")
        });
        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse != null){
                    if(storeResponse.picklistValues != null){
                    	component.set("v.pickListValMap", storeResponse.picklistValues);    
                    }
                    if(storeResponse.accountRecord != null){
                    	component.set("v.selectedLookupAccountRecord", storeResponse.accountRecord);    
                    }
                    if(storeResponse.contactRecord != null){
                     	component.set("v.selectedLookupContactRecord", storeResponse.contactRecord);   
                    }
                    var recordId = component.get("v.recordId");
                    if(recordId != null && recordId != ''){
                        component.set("v.showSpinner", true);
                    	self.getAktionRecord(component);    
                    }
                    else{
                        component.set("v.modalHeader", component.get("v.modalHeader") + ' : '+ component.get("v.selectedRecordTypeName"));
                        if(component.get("v.fromRelatedTab") == true &&
                           component.get("v.massnahmeObj") != null){
                            component.set("v.selectedLookUpMassnahmeRecord", component.get("v.massnahmeObj"));
                        }
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
    
    saveAktionRecord : function(component){
        var selRecTypeId = component.get("v.selectedRecordTypeId");
        if(component.get("v.newAktionObj.RecordTypeId") == '' && selRecTypeId != ''){
        	component.set("v.newAktionObj.RecordTypeId", selRecTypeId);    
        }
        var self = this;
        var action = component.get("c.upsertRecord");
        action.setParams({
            'aktionObj' : component.get("v.newAktionObj")
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
                        if(component.get("v.fromRelatedTab") == false){
                        	self.showToast('Success', $A.get("$Label.c.CCG_Record_is_successfully_Created"), 'success');    
                        }      
                    }
                    console.log('storeResponse.Id : '+ storeResponse.Id);
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
    
    getAktionRecord : function(component){
        var self = this;
        var action = component.get("c.getAktionRecord");
        action.setParams({
            'recordId' : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            component.set("v.showSpinner", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if(storeResponse != null){
                    if(storeResponse.aktionRecord != undefined && storeResponse.aktionRecord != null){
                    	component.set("v.newAktionObj", storeResponse.aktionRecord);
                        component.set("v.selectedRecordTypeId", component.get("v.newAktionObj.RecordTypeId"));
                        if(storeResponse.aktionRecord.RecordTypeId != undefined && storeResponse.aktionRecord.RecordTypeId != null){
                        	component.set("v.selectedRecordTypeName", storeResponse.aktionRecord.RecordType.Name);    
                        }
                        component.set("v.modalHeader", $A.get("$Label.c.CCG_Edit") + ' ' +storeResponse.aktionRecord.Name);
                    }
                    if(storeResponse.massnahmeRecord != null){
                    	component.set("v.selectedLookUpMassnahmeRecord", storeResponse.massnahmeRecord);    
                    }
                    if(storeResponse.verwendungszweckRecord != null){
                    	component.set("v.selectedLookUpVerwendungszweckRecord", storeResponse.verwendungszweckRecord);    
                    }
                    if(storeResponse.accountRecord != null){
                    	component.set("v.selectedLookupAccountRecord", storeResponse.accountRecord);    
                    }
                    if(storeResponse.contactRecord != null){
                    	component.set("v.selectedLookupContactRecord", storeResponse.contactRecord);    
                    }
                }
                else{
                    console.log('aktion records not fetched');
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
    
    setValuesForAnlass : function(component){
        var aktionRecord = component.get("v.newAktionObj");
        aktionRecord.CBM_Name_2__c = '';
        aktionRecord.CBM_Key_Account_Management__c = '';
        aktionRecord.CBM_Affinit_t_Arbeitsbereich__c = '';
        aktionRecord.CBM_Affinit_t_Kontinent__c = '';
        aktionRecord.CBM_Status__c = '';
        aktionRecord.CBM_Affinit_t_Land__c = '';
        aktionRecord.CBM_Korrenspondenzart__c = '';
        aktionRecord.Fremdliste__c = false;
        aktionRecord.CBM_Aussendedatum__c = '';
        aktionRecord.CBM_Aktiv__c = false;
        aktionRecord.CBM_Link_zu_Muster__c = '';
        aktionRecord.CBM_Ist_Kosten_Gesamt__c = '';
        aktionRecord.CBM_Bedankung_individueller_Dank__c = '';
        aktionRecord.CBM_Bedankung_Neuspender_Dankbrief__c = '';
        aktionRecord.CBM_Bedankung_Neuspender_Individueller_D__c = '';
        aktionRecord.CBM_Bedankung_Postkarte__c = '';
        aktionRecord.CBM_Bedankung_Format__c = '';
        aktionRecord.CBM_Bedankung_Vorstand__c = '';
        aktionRecord.CBM_Bedankung_Kanal__c = '';
        aktionRecord.CBM_Bedankung_Dankbrief__c = '';
        component.set("v.newAktionObj", aktionRecord);
    },
})