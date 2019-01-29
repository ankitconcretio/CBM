/**
* @author Badan Singh Pundeer
* @date 21.08.2018
*
* @group CBM-85
*
* @description Controller class of CCG_CustomNewMassnahme(lightning component) & CCG_NewMassnahmeOnAktion (vf page). It handles queries on 
* 			   Campaign/Massnahme/Aktion.
*
* @history
* version                   | author                          | changes
*=============================================================================
* 1.0 (21.08.2018)          | Badan Pundeer                   | initial version
*/

public class CCG_CustomNewMassnahmeCtrl {
    
    public String campaignId{set;get;}
    public String campaignObject{set;get;}
    
    public CCG_CustomNewMassnahmeCtrl(){
    	campaignId = ApexPages.CurrentPage().getParameters().get('id'); 
        if(String.isNotBlank(campaignId)){
            CampaignAndRelatedRecordsWrpr result = getCampaignRecord(campaignId);
            if(result != null){
                Campaign campaignObj = result.campaignRecord;
                System.debug('campaignObj>> '+ campaignObj);
                campaignObject = JSON.serialize(campaignObj);    
            }
        }
    }
    
    /**
    * @description fetch the picklist values of fields from a particular object.
    * @param fieldApiNames of which picklist values to be fetched.
    * @param objectName from which picklist field values to be fetched.
    * @return map of fields and their picklist values.
    */
	@AuraEnabled
    public static Map<String, List<String>> getPicklistValues(List<String> fieldApiNames, String objectName){
        Map<String, List<String>> mapFieldsPicklistValues = new Map<String, List<String>>();
    	System.debug('fieldApiNames>> '+ fieldApiNames);
        System.debug('ObjectName>> '+ objectName);
        SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        if(fieldApiNames.size() > 0 && objectType != null){ 
            for(String fieldName : fieldApiNames){
                List<String> listPicklistVal = new List<String>();
            	List<Schema.PicklistEntry> pickListValues = objectType.getDescribe().fields.getMap().get(fieldName).getDescribe().getPickListValues();
                for(Schema.PicklistEntry picListVal : pickListValues){
                	listPicklistVal.add(picListVal.getValue());	    
                }
                mapFieldsPicklistValues.put(fieldName, listPicklistVal);
            }	    
        }
		return mapFieldsPicklistValues;
    }
    
    @AuraEnabled
    public static CBM_Massnahme__c upsertRecord(CBM_Massnahme__c massnahmeObj){
        System.debug('massnahmeObj>> '+ massnahmeObj);
        try{
        	upsert massnahmeObj;
            return massnahmeObj;
        }   
        catch(Exception e){
        	System.debug('message: '+ e.getMessage()); 
            return null;
        }
    }
    
	/**
    * @description Returns Campaign and related records(Verwendungszweck).
    * @param recordId of Campaign.
    * @return Campaign and related records.
    */
	 @AuraEnabled 
    public static CampaignAndRelatedRecordsWrpr getCampaignRecord(String recordId){
        Verwendungszweck__c verObj = new Verwendungszweck__c();
        Campaign campaignObj = new Campaign();
        if(String.isNotBlank(recordId)){
            try{
            	campaignObj = [SELECT Id,Status,CBM_Fremdliste__c,CBM_Verwendungszweck_1__c, Type, CBM_Key_Account_Management__c, StartDate, EndDate,
                                    CBM_Aussendedatum__c,CBM_Affinit_t_Arbeitsbereich__c,CBM_Affinit_t_Kontinent__c,CBM_Affinit_t_Land__c,
                                    CBM_Link_zu_Muster__c,CBM_Verwendungszweck_ALT__c,CBM_Bedankung_Dankbrief__c,CBM_Bedankung_individueller_Dank__c,
                               		CBM_Bedankung_Neuspender_Dankbrief__c,CBM_Bedankung_Neuspender_Individueller_D__c,CBM_Bedankung_Postkarte__c,
                                    CBM_Bedankung_Format__c, CBM_Bedankung_Kanal__c, CBM_Bedankung_Vorstand__c 
                               		FROM Campaign WHERE Id =: recordId]; 
                
                if(campaignObj.CBM_Verwendungszweck_1__c != null){
                    verObj = [Select Id,Name From Verwendungszweck__c WHERE Id=: campaignObj.CBM_Verwendungszweck_1__c];    
                }
            }             
            catch(Exception e){
            	System.debug('ErrorMessage : '+ e.getMessage());
                return null;
            }
            System.debug('campaignObj>> '+ campaignObj);
            System.debug('verObj>> '+ verObj);
            return new CampaignAndRelatedRecordsWrpr(null, campaignObj, verObj);    
        }
        return null;
    }
    
    /**
    * @description Returns Massnahme and related records(Campaign & Verwendungszweck).
    * @param recordId of Massnahme.
    * @return Massnahme and related records.
    */
    @AuraEnabled 
    public static CampaignAndRelatedRecordsWrpr getMassnamheRecord(String recordId){
    	CBM_Massnahme__c massnahmeObj = new CBM_Massnahme__c();
        Campaign campaignObj = new Campaign();
        Verwendungszweck__c verObj = new Verwendungszweck__c();
        if(String.isNotBlank(recordId)){
        	try{
            	massnahmeObj = [SELECT Id, CBM_Status__c, CBM_Affinit_t_Land__c, CBM_Korrespondenzart__c, CBM_Affinit_t_Arbeitsbereich__c,
                                CBM_Aktionstyp__c, CBM_Affinit_t_Kontinent__c, CBM_Verwendungszweck_ALT__c, CBM_Key_Account_Management__c,
                                CBM_Bedankung_Dankbrief__c, CBM_Bedankung_individueller_Dank__c, CBM_Bedankung_Neuspender_Dankbrief__c,
                                CBM_Bedankung_Neuspender_Individueller_D__c, CBM_Bedankung_Postkarte__c, Name, CBM_Aktiv__c, CBM_Link_zu_Muster__c,
                                CBM_Gehoertzu__c, CBM_Aussendedatum_PAL__c, CBM_Fremdliste__c, CBM_Budgetauflage__c, cbm_Verwendungszweck__c,
                                CBM_Bedankung_Format__c, CBM_Bedankung_Kanal__c, CBM_Bedankung_Vorstand__c
                                FROM CBM_Massnahme__c WHERE Id =: recordId];
                if(massnahmeObj.CBM_Gehoertzu__c != null){
                	campaignObj = [SELECT Id,Name FROM Campaign WHERE Id=: massnahmeObj.CBM_Gehoertzu__c];	    
                }
                if(massnahmeObj.cbm_Verwendungszweck__c != null){
	            	verObj = [SELECT Id,Name FROM Verwendungszweck__c WHERE Id=: massnahmeObj.cbm_Verwendungszweck__c];        
                }
            }             
            catch(Exception e){
            	System.debug('ErrorMessage : '+ e.getMessage());
                return null;
            }
            System.debug('massnahmeObj>> '+ massnahmeObj);
            System.debug('campaignObj>> '+ campaignObj);
            System.debug('verObj>> '+ verObj);
            return new CampaignAndRelatedRecordsWrpr(massnahmeObj, campaignObj, verObj);
        }
        return null;
    }
    
    public class CampaignAndRelatedRecordsWrpr{
        @AuraEnabled public CBM_Massnahme__c massnahmeRecord {get; set;}
        @AuraEnabled public Campaign campaignRecord {get; set;}
        @AuraEnabled public Verwendungszweck__c verwendungszweckRecord {get; set;}
        public CampaignAndRelatedRecordsWrpr(CBM_Massnahme__c massnahmeRecord, Campaign campaignRecord, Verwendungszweck__c verwendungszweckRecord){
            this.massnahmeRecord = massnahmeRecord;
            this.campaignRecord = campaignRecord;
            this.verwendungszweckRecord = verwendungszweckRecord;
        }
    }
}