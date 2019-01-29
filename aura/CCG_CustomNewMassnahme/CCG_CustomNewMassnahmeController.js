({
	doInit : function(component, event, helper) {
        component.set("v.showModal", true);
        helper.getPicklistValues(component);
	},
    
    closeModel : function(component, event, helper){
        var recordId = component.get("v.recordId");
        if(recordId != null && recordId != ''){
        	helper.navigateToRecord(recordId);        
        }
        else{
        	helper.navigateToSObject('CBM_Massnahme__c');        
        }
    },
    
    handleCampaignChange : function(component, event, helper){
        var massnahmeRecord = component.get("v.newMassnahmeObj"); 
        var selectedCampaign = component.get("v.selectedLookUpCampaignRecord");
        if(selectedCampaign.Id != null && selectedCampaign.Id != undefined){
            if(massnahmeRecord.CBM_Gehoertzu__c != selectedCampaign.Id){
                console.log('id>> ', selectedCampaign.Id);
                component.set("v.showErrorMessageOnGehort", false);
                helper.getCampaignRecord(component, selectedCampaign.Id);    
            }
        }
        else{
            massnahmeRecord.CBM_Status__c = '';
            massnahmeRecord.CBM_Fremdliste__c = false;
            massnahmeRecord.CBM_Aussendedatum_PAL__c = '';
            massnahmeRecord.CBM_Affinit_t_Kontinent__c = '';
            massnahmeRecord.CBM_Affinit_t_Arbeitsbereich__c = '';
            massnahmeRecord.CBM_Affinit_t_Land__c = '';
            massnahmeRecord.CBM_Aktionstyp__c = '';
            massnahmeRecord.CBM_Link_zu_Muster__c = '';
            massnahmeRecord.CBM_Verwendungszweck_ALT__c = '';
            massnahmeRecord.CBM_Key_Account_Management__c = '';
            massnahmeRecord.CBM_Bedankung_Dankbrief__c = '';
            massnahmeRecord.CBM_Bedankung_individueller_Dank__c = '';
            massnahmeRecord.CBM_Bedankung_Neuspender_Dankbrief__c = '';
            massnahmeRecord.CBM_Bedankung_Neuspender_Individueller_D__c = '';
            massnahmeRecord.CBM_Bedankung_Postkarte__c = '';
            massnahmeRecord.CBM_Gehoertzu__c = '';
            massnahmeRecord.CBM_Bedankung_Vorstand__c = false;
            massnahmeRecord.CBM_Bedankung_Kanal__c = '';
            massnahmeRecord.CBM_Bedankung_Format__c = '';
            component.set("v.newMassnahmeObj", massnahmeRecord);
            component.set("v.selectedLookUpVerwendungszweckRecord", '');
        }
    },
    
    saveRecords : function(component, event, helper){
        var nameValidity = component.find("massnahmeName").get("v.validity");
        var selectedCampaign = component.get("v.selectedLookUpCampaignRecord");
        var selectedVerwendungszweck = component.get("v.selectedLookUpVerwendungszweckRecord");
        if(selectedCampaign.Id != null && selectedCampaign.Id != undefined && nameValidity.valid == true){
			var massnahmeRecord = component.get("v.newMassnahmeObj");
            massnahmeRecord.CBM_Gehoertzu__c = selectedCampaign.Id;
            if(selectedVerwendungszweck.Id != null && selectedVerwendungszweck.Id != undefined){
            	massnahmeRecord.cbm_Verwendungszweck__c =  selectedVerwendungszweck.Id;   
            }
            component.set("v.newMassnahmeObj", massnahmeRecord);
            component.set("v.showSpinner", true);
            helper.saveMassnahmeRecord(component);
        }
        else{
            if(nameValidity.valid == false){
            	component.find("massnahmeName").showHelpMessageIfInvalid();    
            }
            else{
                component.set("v.showErrorMessageOnGehort", true);
            }
        }
    },
})