/**
* @author Badan Singh Pundeer
* @date 21.08.2018
*
* @group CBM-85
*
* @description Controller class of CCG_CustomNewAktion(lightning component) & CCG_NewAktionOnMassnahme (vf page). It handles queries on 
* 			   Campaign/Massnahme/Aktion.
*
* @history
* version                   | author                          | changes
*=============================================================================
* 1.0 (21.08.2018)          | Badan Pundeer                   | initial version
*/

public class CCG_CustomNewAktionCtrl {
    
    public String massnahmeId{set;get;}
    public String massnahmeObject{set;get;}
    
    public CCG_CustomNewAktionCtrl(){
    	massnahmeId = ApexPages.CurrentPage().getParameters().get('id');
        
        if(String.isNotBlank(massnahmeId)){
            MassnahmeAndRelatedRecordsWrpr result = getMassnahmeRecord(massnahmeId);
            if(result != null){
                CBM_Massnahme__c massnahmeObj = result.massnahmeRecord;
                System.debug('massnahmeObj>> '+ massnahmeObj);
                massnahmeObject = JSON.serialize(massnahmeObj);    
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
    public static initValuesWrpr getPicklistValues(List<String> fieldApiNames, String objectName, String accId, String conId){
        if(String.isNotBlank(accId) && String.isBlank(conId)){
            Account accObj;
            try{
            	accObj = [SELECT Id, Name FROM Account WHERE Id=:accId];	    
            }
            catch(Exception e){
            	System.debug('error message :'+ e.getMessage());    
            }
        	return new initValuesWrpr(CCG_CustomNewMassnahmeCtrl.getPicklistValues(fieldApiNames, objectName), accObj, null);    
        }
        else if(String.isNotBlank(conId) && String.isBlank(accId)){
            Contact conObj;
            try{
            	conObj = [SELECT Id, Name FROM Contact WHERE Id=:conId];	    
            }
            catch(Exception e){
            	System.debug('error message :'+ e.getMessage());    
            }
        	return new initValuesWrpr(CCG_CustomNewMassnahmeCtrl.getPicklistValues(fieldApiNames, objectName), null, conObj);    
        }
        else{
        	return new initValuesWrpr(CCG_CustomNewMassnahmeCtrl.getPicklistValues(fieldApiNames, objectName), null, null);
        }
    }
    
    @AuraEnabled
    public static CBM_Aktion__c upsertRecord(CBM_Aktion__c aktionObj){
        System.debug('aktionObj>> '+ aktionObj);
        try{
        	upsert aktionObj;
            System.debug('aktionObj after insert>> '+ aktionObj);
            return aktionObj;
        }   
        catch(Exception e){
        	System.debug('message: '+ e.getMessage()); 
            return null;
        }
    }
    
    /**
    * @description Returns Massnahme and related records(Verwendungszweck).
    * @param recordId of Massnahme.
    * @return Massnahme and related records.
    */
	 @AuraEnabled 
    public static MassnahmeAndRelatedRecordsWrpr getMassnahmeRecord(String recordId){
        CBM_Massnahme__c massnahmeObj = new CBM_Massnahme__c();
        Verwendungszweck__c verObj = new Verwendungszweck__c();
        if(String.isNotBlank(recordId)){
            try{
            	massnahmeObj = [SELECT Id,Name,CBM_Affinit_t_Arbeitsbereich__c,CBM_Affinit_t_Kontinent__c,CBM_Affinit_t_Land__c,
                                    CBM_Status__c,CBM_Startdatum__c,CBM_Enddatum__c,CBM_Fremdliste__c,CBM_Key_Account_Management__c,
                                    CBM_Korrespondenzart__c,cbm_Verwendungszweck__c,CBM_Aussendedatum_PAL__c,CBM_Link_zu_Muster__c,
                               		CBM_Aktionstyp__c,CBM_Bedankung_Dankbrief__c,CBM_Bedankung_individueller_Dank__c, 
                                	CBM_Bedankung_Neuspender_Dankbrief__c,CBM_Bedankung_Neuspender_Individueller_D__c,CBM_Bedankung_Postkarte__c,
                                    CBM_Bedankung_Format__c, CBM_Bedankung_Kanal__c, CBM_Bedankung_Vorstand__c
                               		FROM CBM_Massnahme__c WHERE Id =: recordId];
                
                if(massnahmeObj.cbm_Verwendungszweck__c != null){
                    verObj = [Select Id,Name From Verwendungszweck__c WHERE Id=: massnahmeObj.cbm_Verwendungszweck__c];    
                }
            }             
            catch(Exception e){
            	System.debug('ErrorMessage : '+ e.getMessage());
                return null;
            }
            System.debug('massnahmeObj>> '+ massnahmeObj);
            System.debug('verObj>> '+ verObj);
			return new MassnahmeAndRelatedRecordsWrpr(null, massnahmeObj, verObj, null, null);    
        }
        return null;
    }
    
    /**
    * @description Returns Aktion and related records(Massnahme & Verwendungszweck).
    * @param recordId of Aktion.
    * @return Aktion and related records.
    */
    @AuraEnabled 
    public static MassnahmeAndRelatedRecordsWrpr getAktionRecord(String recordId){
    	CBM_Aktion__c aktionObj = new CBM_Aktion__c();
        CBM_Massnahme__c massnahmeObj = new CBM_Massnahme__c();
        Verwendungszweck__c verObj = new Verwendungszweck__c();
        Account accObj = new Account();
        Contact conObj = new Contact();
        if(String.isNotBlank(recordId)){
        	try{
            	aktionObj = [SELECT Id, CBM_Status__c, CBM_Affinit_t_Land__c, CBM_Korrenspondenzart__c, CBM_Affinit_t_Arbeitsbereich__c,
                                CBM_Typ__c, CBM_Affinit_t_Kontinent__c, CBM_Key_Account_Management__c, CBM_Beschreibung__c, CBM_Name_2__c,
                                CBM_Bedankung_Dankbrief__c, CBM_Bedankung_individueller_Dank__c, CBM_Bedankung_Neuspender_Dankbrief__c,
                                CBM_Bedankung_Neuspender_Individueller_D__c, CBM_Bedankung_Postkarte__c, Name, CBM_Aktiv__c, CBM_Link_zu_Muster__c,
                                CBM_Gehoertzu__c, CBM_Aussendedatum__c, Fremdliste__c, CBM_Verwendungszweck__c, CBM_Durchschnittliche_Spendengr_e__c,
                             	CBM_Ist_Kosten_Gesamt__c, CBM_Gewonnene_Spenden_Anzahl_Ist__c, CBM_Gewonnene_Spenden_Ist__c, CBM_Enddatum__c, CBM_Startdatum__c,
                                CBM_Bedankung_Format__c, CBM_Bedankung_Kanal__c, CBM_Bedankung_Vorstand__c, RecordTypeId, RecordType.Name,
                                CBM_Veranlasser_Account__c, CBM_Veranlasser__c, CBM_Aktionscode__c
                                FROM CBM_Aktion__c WHERE Id =: recordId];
                if(aktionObj.CBM_Gehoertzu__c != null){
                	massnahmeObj = [SELECT Id,Name FROM CBM_Massnahme__c WHERE Id=: aktionObj.CBM_Gehoertzu__c];	    
                }
                if(aktionObj.CBM_Verwendungszweck__c != null){
	            	verObj = [SELECT Id,Name FROM Verwendungszweck__c WHERE Id=: aktionObj.CBM_Verwendungszweck__c];        
                }
                if(aktionObj.CBM_Veranlasser_Account__c != null){
                	accObj = [SELECT Id,Name FROM Account WHERE Id=: aktionObj.CBM_Veranlasser_Account__c];    
                }
                if(aktionObj.CBM_Veranlasser__c != null){
                	conObj = [SELECT Id, Name FROM Contact WHERE Id=: aktionObj.CBM_Veranlasser__c];    
                }
            }             
            catch(Exception e){
            	System.debug('ErrorMessage : '+ e.getMessage());
                return null;
            }
            System.debug('massnahmeObj>> '+ massnahmeObj);
            System.debug('aktionObj>> '+ aktionObj);
            System.debug('verObj>> '+ verObj);
            System.debug('accObj>> '+ accObj);
            System.debug('conObj>> '+ conObj);
            return new MassnahmeAndRelatedRecordsWrpr(aktionObj, massnahmeObj, verObj, accObj, conObj);
        }
        return null;
    }
    
    public class MassnahmeAndRelatedRecordsWrpr{
        @AuraEnabled public CBM_Aktion__c aktionRecord {get; set;}
        @AuraEnabled public CBM_Massnahme__c massnahmeRecord {get; set;} 
        @AuraEnabled public Verwendungszweck__c verwendungszweckRecord {get; set;}
        @AuraEnabled public Account accountRecord {get; set;}
        @AuraEnabled public Contact contactRecord {get; set;}
        public MassnahmeAndRelatedRecordsWrpr(CBM_Aktion__c aktionRecord, CBM_Massnahme__c massnahmeRecord, Verwendungszweck__c verwendungszweckRecord, Account accountRecord, Contact contactRecord){
            this.massnahmeRecord = massnahmeRecord;
            this.aktionRecord = aktionRecord;
            this.verwendungszweckRecord = verwendungszweckRecord;
            this.accountRecord = accountRecord;
            this.contactRecord = contactRecord;
        }
    }
    
    public class initValuesWrpr{
        @AuraEnabled public Map<String, List<String>> picklistValues {get; set;}
        @AuraEnabled public Account accountRecord {get; set;}
        @AuraEnabled public Contact contactRecord {get; set;}
        public initValuesWrpr(Map<String, List<String>> picklistValues, Account accountRecord, Contact contactRecord){
            this.picklistValues = picklistValues;
            this.accountRecord = accountRecord;
            this.contactRecord = contactRecord;
        }
    }
}