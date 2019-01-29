/**
* @author Badan Singh Pundeer
* @date 21.08.2018
*
* @group CBM-85
*
* @description Controller class of CCG_CustomLookup(lightning component). It fetch the results of lookup.
*
* @history
* version                   | author                          | changes
*=============================================================================
* 1.0 (21.08.2018)          | Badan Pundeer                   | initial version
*/
public class CCG_CustomLookupCtrl {
	@AuraEnabled
    public static List <SObject> fetchLookUpValues(String searchKeyWord, String ObjectName, Boolean filterMassnahme) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        String sQuery = '';
        List <SObject> returnList = new List <SObject> ();
      	
        if(ObjectName.equalsIgnoreCase('Account')){
        	sQuery =  'select id, Name, CBM_Spendernummer__c from ' +ObjectName + ' where Name LIKE: searchKey OR CBM_Spendernummer__c LIKE: searchKey order by createdDate DESC limit 5';    
        }
        else if(ObjectName.equalsIgnoreCase('Contact')){
        	sQuery =  'select id, Name, Spendernummer__c from ' +ObjectName + ' where Name LIKE: searchKey OR Spendernummer__c LIKE: searchKey order by createdDate DESC limit 5';    
        }
        else if(ObjectName.equalsIgnoreCase('CBM_Massnahme__c') && filterMassnahme == true){
        	sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey AND CBM_Gehoertzu__r.IsActive = true AND CBM_Gehoertzu__r.Anlass_Kampagne__c = true order by createdDate DESC limit 5';	    
        }
        else{
        	sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey order by createdDate DESC limit 5';    
        }
        List <SObject> lstOfRecords = Database.query(sQuery);
        for (SObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}