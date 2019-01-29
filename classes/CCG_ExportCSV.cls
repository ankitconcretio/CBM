/**
* @author Badan Singh Pundeer
* @date 29.05.2018
*
* @group System State Monitoring
*
* @description Retrieve completed batch jobs from AsyncApexJob object.
*
* @history
* version                           | author                                    | changes
*=============================================================================
* 1.0 (29.05.2018)          | Badan Pundeer                   | initial version
*/


public class CCG_ExportCSV {
    public CCG_ExportCSV() { 

    } 
    
    public Integer generateCSVWithoutJunctionObj(String filters,String logic,String fields,String aktionId,Integer deleteIndex,Integer target){
		System.debug('deleteIndex::'+deleteIndex+'::target'+target);
        Map<String,String> filterData = CCG_ProcessResults.getObjectFilters(filters,logic);
        filterData.remove('CBM_Aktionteilnehmer__c');
        CCG_AktionteilnehmerUpsertBtch btchObj = new CCG_AktionteilnehmerUpsertBtch(filterData,aktionId,false,'',deleteIndex,target, new Set<Id>());
        Id bid = DataBase.executeBatch(btchObj,200); 
        return null;
    } 

    public static Integer saveSplitRecords(String filters,String logic,String fields,String splitCriteria){
        CCG_SplitRecordsBtch btchObj = new CCG_SplitRecordsBtch(filters,logic,fields,splitCriteria);
        Id bid = DataBase.executeBatch(btchObj,500);
        return null;
    }
}