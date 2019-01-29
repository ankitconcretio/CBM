public class CCG_SplitOpportunityCtlr {
    public String defaultVerwen{get;set;}
    public String defaultAktion{get;set;}
    public String defaultContact{get;set;}
    public String opportunityData{get;set;}
    
    public CCG_SplitOpportunityCtlr(){
        PageReference currentPage = ApexPages.currentPage();
        if(currentPage != null){
            Map<String,String> urlParams = currentPage.getParameters();
            String recordId = currentPage != null ? urlParams.get('id') : '';
            System.debug('recordId : '+ recordId);
            if(!String.isBlank(recordId)){
                Opportunity opp = [SELECT Id,Name,Amount,npsp__Primary_Contact__c, npsp__Primary_Contact__r.Name,
                                   npsp__Primary_Contact__r.Id, CBM_Aktionscode__r.Name,CBM_Aktionscode__r.Id,
                                   CBM_Verwendungszweck__r.Name,CBM_Verwendungszweck__r.Id,
                                   CBM_QuittungsID__c FROM Opportunity WHERE Id =:recordId];
                System.debug('opp : '+ opp);
                if(opp != null){
                    opportunityData = JSON.serialize(opp);
                    if(!String.isBlank(opp.npsp__Primary_Contact__r.Name)){
                        Map<String,String> defaultContactMap = new Map<String,String>();
                        defaultContactMap.put('id',opp.npsp__Primary_Contact__r.Id);
                        defaultContactMap.put('label',opp.npsp__Primary_Contact__r.Name);
                        defaultContact = JSON.serialize(defaultContactMap);
                    }
                    if(!String.isBlank(opp.CBM_Aktionscode__r.Name)){
                        Map<String,String> defaultContactMap = new Map<String,String>();
                        defaultContactMap.put('id',opp.CBM_Aktionscode__r.Id);
                        defaultContactMap.put('label',opp.CBM_Aktionscode__r.Name);
                        defaultAktion = JSON.serialize(defaultContactMap);
                    }
                    if(!String.isBlank(opp.CBM_Verwendungszweck__r.Name)){
                        Map<String,String> defaultContactMap = new Map<String,String>();
                        defaultContactMap.put('id',opp.CBM_Verwendungszweck__r.Id);
                        defaultContactMap.put('label',opp.CBM_Verwendungszweck__r.Name);
                        defaultVerwen = JSON.serialize(defaultContactMap);
                    }
                }
            }
        }
    }
    
    @RemoteAction
    public static String getAktions(String searchTerm,String objectName, List<String> selectedConIds){
        searchTerm = '%'+searchTerm+'%';
        List<Map<String,String>> relatedActions = new List<Map<String,String>>();
        String sQuery = '';
        if(objectName.equalsIgnoreCase('Contact')){
            sQuery = 'SELECT Id, Name FROM '+ objectName +' WHERE Name LIKE :searchTerm AND Id NOT IN:selectedConIds LIMIT 150';
        }
        else{
            sQuery = 'SELECT Id, Name FROM '+ objectName +' WHERE Name LIKE :searchTerm LIMIT 150';
        }
        for(sObject aktion :Database.query(sQuery)){
            Map<String,String> aktionsMap  = new Map<String,String>();
            aktionsMap.put('id', aktion.id);
            aktionsMap.put('label', String.valueOf(aktion.get('Name')));
            relatedActions.add(aktionsMap);
        }
        return JSON.serialize(relatedActions);
    }
    
    @RemoteAction
    public static String updateAndCreateOpportunity(String oppId, List<Decimal> amtList, List<String> verwenList, List<String> aktionList, List<String> pConList){
        System.debug('oppId : '+ oppId);
        System.debug('amtList : '+ amtList);
        System.debug('verwenList : '+ verwenList);
        System.debug('aktionList : '+ aktionList);
        System.debug('pConList : '+ pConList);
        if(String.isNotBlank(oppId) && amtList.size() > 0 && verwenList.size() > 0 && aktionList.size() > 0 && pConList.size() > 0){
            Map<String, Contact> mapContact = new Map<String, Contact>();
            List<Opportunity> oppListToInsert = new List<Opportunity>();
            List<Opportunity> Opportunities;
            String query = 'SELECT';
            Opportunity oppObjToUpdate;
            try{
                oppObjToUpdate = [SELECT Id, Name, StageName FROM Opportunity Where Id=:oppId]; 
            }
            catch(Exception ex){
                System.debug('Exception : '+ ex.getMessage());
                return 'Error : ' + ex.getMessage();
            }
            
            /*clone opportunity*/
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap();
            System.debug(objectFields);
            for(String s : objectFields.keySet()) {
                query += ' ' + s + ', ';
            }
            query = query.subString(0, query.Length()-2) + ' FROM Opportunity'+' WHERE Id =: oppId';
            System.debug('query : '+ query);
            try{
                Opportunities = database.query(query);
                System.debug('Opportunities : '+ Opportunities); 
            }
            catch(Exception ex){
                System.debug('Occured Exception : '+ ex.getMessage());
                return 'Error : ' + ex.getMessage();
            }
			/*clone opportunity*/
            
            for(Contact conObj : [SELECT Id,Name,AccountId FROM Contact Where Id IN:pConList]){
                mapContact.put(conObj.Id, conObj);    
            }
            if(Opportunities.size() > 0 && mapContact.size() > 0){
                for(Integer i=0; i<amtList.size(); i++){
                    Opportunity cloneOpp = Opportunities[0].clone(false, false, false, false);
                    Contact conObject = mapContact.get(pConList[i]);
                    String oppName = conObject.Name + ' ' + cloneOpp.CBM_RecordType_Name__c + ' ' + String.valueOf(cloneOpp.CloseDate).removeEnd(' 00:00:00');
                    cloneOpp.Name = oppName;
                    cloneOpp.CBM_Verwendungszweck__c = verwenList[i];
                    cloneOpp.CBM_Aktionscode__c = aktionList[i];
                    cloneOpp.npsp__Primary_Contact__c = conObject.Id;
                    cloneOpp.AccountId = conObject.AccountId;
                    cloneOpp.StageName = Label.CBM_StageClosedWon;
                    cloneOpp.Amount = amtList[i];
                    oppListToInsert.add(cloneOpp); 
                }
                oppObjToUpdate.StageName = Label.CBM_StageClosedLost;
                System.debug('oppListToInsert before insert: '+ oppListToInsert);
                System.debug('oppObjToUpdate before insert: '+ oppObjToUpdate);
                try{
                    insert oppListToInsert; 
                    update oppObjToUpdate;
                    System.debug('oppListToInsert : '+ oppListToInsert);
                    return 'SUCCESS';
                }
                catch(Exception ex){
                    System.debug(ex.getLineNumber()+ex.getMessage());
                    return 'Error : ' + ex.getMessage();
                }     
            }  
        }
        return 'Fail';
    }
}