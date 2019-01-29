/**
* @author Badan Singh Pundeer
* @date 07.12.2018
*
* @group CBM-85
*
* @description Controller class of CCG_CustomAktionRecTypeSelection(lightning component). It fetch recordTypes from Aktion.
*
* @history
* version                   | author                          | changes
*=============================================================================
* 1.0 (07.12.2018)          | Badan Pundeer                   | initial version
*/
public class CCG_CustomAktionRecTypeSelCtrl {
	@AuraEnabled
    public static List<recordTypeValues> getRecTypeValues(String objectName){
        if(String.isNotBlank(objectName)){
            try{
                List<recordTypeValues> recTypeValues = new List<recordTypeValues>();
            	List<RecordType> recTypeList = [SELECT Id, Name FROM RecordType WHERE sObjectType=:objectName AND isActive=true];
                for(RecordType recType : recTypeList){
                	recTypeValues.add(new recordTypeValues(recType.Name, recType.Id));		    
                }
                System.debug('recTypeValues>> '+ recTypeValues);
                return recTypeValues;
            }
            catch(Exception e){
        		System.debug('message: '+ e.getMessage()); 
        	}
        }
        return null;
    }
    
    public class recordTypeValues{
        @AuraEnabled public String label {set;get;}
        @AuraEnabled public String value {set;get;}
        recordTypeValues(String label, String value){
        	this.label = label;
            this.value = value;
        }
    }
}