({
	doInit : function(component, event, helper) {
        component.set("v.showModal", true);
        helper.getPicklistValues(component);
	},
    
    closeModel : function(component, event, helper){
        var recordId = component.get("v.recordId");
        var accountId = component.get("v.accountId");
        var contactId = component.get("v.contactId");
        if(recordId != null && recordId != ''){
        	helper.navigateToRecord(recordId);        
        }
        else if(accountId != null && accountId != ''){
        	helper.navigateToRecord(accountId);    
        }
        else if(contactId != null && contactId != ''){
        	helper.navigateToRecord(contactId);    
        }
        else{
        	helper.navigateToSObject('CBM_Aktion__c');        
        }
    },
    
    handleMassnahmeChange : function(component, event, helper){
        var aktionRecord = component.get("v.newAktionObj"); 
        var selectedMassnahme = component.get("v.selectedLookUpMassnahmeRecord");
        if(selectedMassnahme.Id != null && selectedMassnahme.Id != undefined){
            if(aktionRecord.CBM_Gehoertzu__c != selectedMassnahme.Id){
                console.log('id>> ', selectedMassnahme.Id);
                component.set("v.showErrorMessageOnGehort", false);
                helper.getMassnahmeRecord(component, selectedMassnahme.Id);    
            }
        }
        else{
            aktionRecord.CBM_Status__c = '';
            aktionRecord.Fremdliste__c = false;
            aktionRecord.CBM_Aussendedatum__c = '';
            aktionRecord.CBM_Affinit_t_Kontinent__c = '';
            aktionRecord.CBM_Affinit_t_Arbeitsbereich__c = '';
            aktionRecord.CBM_Affinit_t_Land__c = '';
            aktionRecord.CBM_Typ__c = '';
            aktionRecord.CBM_Link_zu_Muster__c = '';
            aktionRecord.CBM_Verwendungszweck__c = '';
            aktionRecord.CBM_Key_Account_Management__c = '';
            aktionRecord.CBM_Bedankung_Dankbrief__c = '';
            aktionRecord.CBM_Bedankung_individueller_Dank__c = '';
            aktionRecord.CBM_Bedankung_Neuspender_Dankbrief__c = '';
            aktionRecord.CBM_Bedankung_Neuspender_Individueller_D__c = '';
            aktionRecord.CBM_Bedankung_Postkarte__c = '';
            aktionRecord.CBM_Gehoertzu__c = '';
            aktionRecord.CBM_Startdatum__c = '';
            aktionRecord.CBM_Enddatum__c = '';
            aktionRecord.CBM_Korrenspondenzart__c = '';
            aktionRecord.CBM_Bedankung_Vorstand__c = false;
            aktionRecord.CBM_Bedankung_Kanal__c = '';
            aktionRecord.CBM_Bedankung_Format__c = '';
            component.set("v.newAktionObj", aktionRecord);
            component.set("v.selectedLookUpVerwendungszweckRecord", '');
        }
    },
    
    saveRecords : function(component, event, helper){
        var nameValidity = component.find("aktionName1").get("v.validity");
        var selectedMassnahme = component.get("v.selectedLookUpMassnahmeRecord");
        var selectedVerwendungszweck = component.get("v.selectedLookUpVerwendungszweckRecord");
        if(selectedMassnahme.Id != null && selectedMassnahme.Id != undefined && nameValidity.valid == true){
			var aktionRecord = component.get("v.newAktionObj");
            aktionRecord.CBM_Gehoertzu__c = selectedMassnahme.Id;
            if(selectedVerwendungszweck.Id != null && selectedVerwendungszweck.Id != undefined){
            	aktionRecord.CBM_Verwendungszweck__c =  selectedVerwendungszweck.Id;   
            }
            if(component.get("v.selectedRecordTypeName") == 'Anlass'){
            	var selectedAccount = component.get("v.selectedLookupAccountRecord");
        		var selectedContact = component.get("v.selectedLookupContactRecord");
                if(selectedAccount.Id != undefined && selectedAccount.Id != null){
                	aktionRecord.CBM_Veranlasser_Account__c =  selectedAccount.Id;    
                }
                if(selectedContact.Id != undefined && selectedContact.Id != null){
                	aktionRecord.CBM_Veranlasser__c =  selectedContact.Id;    
                }
            }
            component.set("v.newAktionObj", aktionRecord);
            if(component.get("v.selectedRecordTypeName") == 'Anlass' && 
               aktionRecord.CBM_Veranlasser_Account__c == '' && aktionRecord.CBM_Veranlasser__c == ''){
            	component.set("v.showErrorMessageOnInitiatorAcc", true);
                component.set("v.showErrorMessageOnInitiatorCon", true);
            }
            else{
                component.set("v.showSpinner", true);
                if(component.get("v.selectedRecordTypeName") == 'Anlass'){
                    helper.setValuesForAnlass(component);    
                }
                helper.saveAktionRecord(component);    
            }
        }
        else{
            if(nameValidity.valid == false){
            	component.find("aktionName1").showHelpMessageIfInvalid();    
            }
            else{
                component.set("v.showErrorMessageOnGehort", true);
            }
        }
    },
    
    handleInitiatorAccChange : function(component, event, helper){
        var selectedAcc = component.get("v.selectedLookupAccountRecord");
        if(selectedAcc.Id != undefined && selectedAcc.Id != null){
            component.set("v.showErrorMessageOnInitiatorAcc", false);
            component.set("v.showErrorMessageOnInitiatorCon", false);
        }
    },
    
    handleInitiatorConChange : function(component, event, helper){
        var selectedCon = component.get("v.selectedLookupContactRecord");
        if(selectedCon.Id != undefined && selectedCon.Id != null){
            component.set("v.showErrorMessageOnInitiatorAcc", false);
            component.set("v.showErrorMessageOnInitiatorCon", false);
        }
    },
})