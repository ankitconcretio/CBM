public class CCG_UmbuchungOpportunityController {   
    
    @AuraEnabled
    public static CCG_UmbuchungOpportunityContWrapper gettingOpportunity(String oppId) {
        System.debug('oppId:::'+oppId);
        Opportunity objOfOpportunity = [SELECT Name, Amount,CBM_Verwendungszweck__c, CBM_QuittungsID__c, CBM_Verwendungszweck__r.Name, CBM_Aktionscode__c, CBM_Aktionscode__r.Name, npsp__Primary_Contact__c, npsp__Primary_Contact__r.Name FROM Opportunity WHERE Id =: oppId];
        return new CCG_UmbuchungOpportunityContWrapper(objOfOpportunity);
    } 
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        String sQuery = '';
        List < sObject > returnList = new List < sObject > ();
        if(ObjectName.equalsIgnoreCase('Contact')){
        	sQuery =  'select id, Name, Spendernummer__c from ' +ObjectName + ' where Name LIKE: searchKey OR Spendernummer__c LIKE: searchKey order by createdDate DESC limit 5';    
        }
        else{
        	sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';    
        }
        List < sObject > lstOfRecords = Database.query(sQuery);        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    
    @AuraEnabled
    public static OpportunityWrpr updateOpportunity(Opportunity objOpp, String aktionsId, String verwendungsId, String contactId, String contactName){
   /*
        String opportunityId = objOpp.Id;
        String objectName = 'Opportunity';
        String query = 'SELECT';
        List<Opportunity> Opportunities;
        
        System.debug('contactId::'+contactId);
        System.debug('opportunityId::'+opportunityId);
        System.debug('npsp__Primary_Contact__c::'+objOpp.npsp__Primary_Contact__c);
     
        
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        System.debug(objectFields);
       
        for(String s : objectFields.keySet()) {
             query += ' ' + s + ', ';
        }
        System.debug('vkm');
        System.debug(query);
        query = query.subString(0,query.Length()-2);
        
        query += ' FROM ' + objectName;
        
        query += ' WHERE Id =: opportunityId';
		System.debug('query::'+query);
      
             Opportunities = database.query(query);
            System.debug(';;;;;;'+Opportunities);
      
        */
        
        
        
        if(objOpp.npsp__Primary_Contact__c == contactId ) {
            System.debug('primary contact Id is similar');
            
            objOpp.CBM_Verwendungszweck__c = verwendungsId;
            objOpp.CBM_Aktionscode__c = aktionsId;
            objOpp.npsp__Primary_Contact__c = contactId;
            
            System.debug('Opportunity::'+objOpp);
            
            try {
                update objOpp;
                return new OpportunityWrpr(objOpp, null);
            }catch(Exception ex){
                System.debug('Dml exception'+ex.getMessage());
                return new OpportunityWrpr(null, ex.getMessage());
            } 
        }else {                   
            String opportunityId = objOpp.Id;
            String objectName = 'Opportunity';
            String query = 'SELECT';
            List<Opportunity> Opportunities;
            List<Contact> cont;
            
            System.debug('contactId::'+contactId);
            System.debug('opportunityId::'+opportunityId);
            System.debug('npsp__Primary_Contact__c::'+objOpp.npsp__Primary_Contact__c);
            
            
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            System.debug(objectFields);
            
            for(String s : objectFields.keySet()) {
                query += ' ' + s + ', ';
            }
            System.debug(query);
            query = query.subString(0,query.Length()-2);    
            query += ' FROM ' + objectName;
            query += ' WHERE Id =: opportunityId';
            System.debug('query::'+query);
            try{
                Opportunities = database.query(query);
                System.debug(';;;;;;'+Opportunities); 
            }catch(Exception ex){
                System.debug('Occured Exception'+ex.getMessage());
            }   
            
            System.debug('oppppp::'+Opportunities[0]);
            Opportunity cloneOpp = Opportunities[0].clone(false, false, false, false);
            String oppName = '';
            if(String.isNotBlank(contactName)){
            	oppName = contactName + ' ';    
            }
            oppName = oppName + cloneOpp.CBM_RecordType_Name__c + ' ' + String.valueOf(cloneOpp.CloseDate).removeEnd(' 00:00:00');
            cloneOpp.Name = oppName;
            cloneOpp.CBM_Verwendungszweck__c = verwendungsId;
            cloneOpp.CBM_Aktionscode__c = aktionsId;
            cloneOpp.npsp__Primary_Contact__c = contactId;
            cloneOpp.StageName = 'Closed Won';
            objOpp.StageName = 'Closed Lost';
            
            if(!String.isBlank(contactId)) {
                String contactQuery = 'SELECT Id,AccountId, Account.Name FROM Contact WHERE Id=: contactId';
                cont = database.query(contactQuery);
                cloneOpp.AccountId = cont[0].AccountId; 
            }          
            try{
                insert cloneOpp; 
                update objOpp;
                System.debug('cloneOpp:: '+ cloneOpp);
                return new OpportunityWrpr(cloneOpp, null);
            }catch(Exception ex){
                System.debug(ex.getLineNumber()+ex.getMessage());
                return new OpportunityWrpr(null, ex.getMessage());
            }           
        }
    } 
    
    public class OpportunityWrpr{
        @AuraEnabled public Opportunity oppRecord {get; set;}
        @AuraEnabled public String errorMsg {get; set;}
        public OpportunityWrpr(Opportunity oppRecord, String errorMsg){
            this.oppRecord = oppRecord;
            this.errorMsg = errorMsg;
        }
    }
}