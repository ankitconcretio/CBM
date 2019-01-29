public class CCG_UmbuchungOpportunityContWrapper {
    @AuraEnabled  public static wrapVerwendungs verwendungsRecord {get;set;}
    @AuraEnabled  public static wrapAktions aktionRecord{get;set;}
    @AuraEnabled  public static wrapContact primaryContactRecord{get;set;}
    @AuraEnabled  public static Opportunity opportuntyRecord{get;set;}
    
    
    
    public CCG_UmbuchungOpportunityContWrapper(Opportunity opp){
        verwendungsRecord = new wrapVerwendungs(opp);
        aktionRecord = new wrapAktions(opp);
        primaryContactRecord = new wrapContact(opp);
       	opportuntyRecord = opp;
        
        
    }
    
    public class wrapVerwendungs{       
        @AuraEnabled public String Name{get;set;}
		@AuraEnabled public String Id{get;set;}
		@AuraEnabled public String quittungsID{get;set;}        
        public wrapVerwendungs(Opportunity opp){  
            this.Name = opp.CBM_Verwendungszweck__r.Name;
            this.Id = opp.CBM_Verwendungszweck__c;
            this.quittungsID = opp.CBM_QuittungsID__c;
        }
    }  
    
    
     public class wrapAktions{       
         @AuraEnabled public String Name{get;set;}   
         @AuraEnabled public String Id{get;set;} 
         @AuraEnabled public String quittungsID{get;set;}  
        public wrapAktions(Opportunity opp){  
            this.Name = opp.CBM_Aktionscode__r.Name;
            this.Id = opp.CBM_Aktionscode__c;
            this.quittungsID = opp.CBM_QuittungsID__c;
        }
    }    
    
     public class wrapContact{       
         @AuraEnabled public String Name{get;set;} 
         @AuraEnabled public String Id{get;set;} 
         @AuraEnabled public String quittungsID{get;set;}  
        public wrapContact(Opportunity opp){  
            this.Name = opp.npsp__Primary_Contact__r.Name;
            this.Id = opp.npsp__Primary_Contact__c;
            this.quittungsID = opp.CBM_QuittungsID__c;
        }
    }    
}