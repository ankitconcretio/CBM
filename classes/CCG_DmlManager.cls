/**
* @author Badan Singh Pundeer
* @date 29.05.2018
*
* @group CBM
*
* @description Performs DML operation for filter fields && columns Data.
*
* @history
* version                           | author                                    | changes
*=============================================================================
* 1.0 (29.05.2018)          | Badan Pundeer                   | initial version
*/

public class CCG_DmlManager{
    public CCG_DmlManager(){
        
    }
     /**
    * @description here we are saving filter fields , selected from multi-select picklist per object.
    * @param filterFields, Filter Fields Per Object in JSON form.
    */
    @RemoteAction
    public static void saveFilterFields(String filterFields){
        map<string,List<string>> mapFilterFields =  new map<string,List<string>>();
        CCG_FilterFieldWrapper wrp = CCG_FilterFieldWrapper.parse(filterFields);
        
        for(CCG_FilterFieldWrapper.cls_setFilterFields ff:wrp.setFilterFields){
            mapFilterFields.put(ff.objName,new List<string>());
            for(CCG_FilterFieldWrapper.cls_fields ffields : ff.fields){
                mapFilterFields.get(ff.objName).add(ffields.fieldApiName);
            }
        }
        List<Spender_Selektion_Object__c> lstSelObjs = new List<Spender_Selektion_Object__c>();
        
        for(string str : mapFilterFields.keyset()){
            Spender_Selektion_Object__c selObj = new Spender_Selektion_Object__c();
            selObj.Name = str;
            selObj.Object_Name__c = str;
            selObj.Filter_Fields__c = string.join(mapFilterFields.get(str),',');
            lstSelObjs.add(selObj);
        }
        upsert lstSelObjs Object_Name__c;
    }
    
    
    
    public static void saveCustomObjectColumns(String customColumnFields){
        
        map<string,List<string>> mapFilterFields =  new map<string,List<string>>();
        CCG_FilterFieldWrapper wrp = CCG_FilterFieldWrapper.parse(customColumnFields);
        
        for(CCG_FilterFieldWrapper.cls_setFilterFields ff:wrp.setFilterFields){
            mapFilterFields.put(ff.objName,new List<string>());
            for(CCG_FilterFieldWrapper.cls_fields ffields : ff.fields){
                mapFilterFields.get(ff.objName).add(ffields.fieldApiName);
            }
        }
        List<Spender_Selection_Custom_Column__c> lstSelObjs = new List<Spender_Selection_Custom_Column__c>();
        for(string str : mapFilterFields.keyset()){
            
            Spender_Selection_Custom_Column__c selObj = new Spender_Selection_Custom_Column__c();
            selObj.Name = str;
            selObj.Object_Name__c = str;
            selObj.Filter_Fields__c = string.join(mapFilterFields.get(str),',');
            lstSelObjs.add(selObj);
            
        }
        upsert lstSelObjs Object_Name__c;
    }
    
     /**
    * @description here we are saving Columns data for export table Columns in CS.
    * @param columns, Columns data per row in JSON form.
    */
    @RemoteAction
    public static void saveColumns(String columns){
        List<Spender_Selektion_Columns_Setting__c> columnSettingInsert = new List<Spender_Selektion_Columns_Setting__c>();
        map<string,Spender_Selektion_Columns_Setting__c> mapOfAllCoumnSettingRecord = Spender_Selektion_Columns_Setting__c.getAll();
        
        CCG_ColumnDetailWrpr col = CCG_ColumnDetailWrpr.parse(columns);
        if(col!=null){
            for(CCG_ColumnDetailWrpr.cls_setColumns colName : col.setColumns){
                    Spender_Selektion_Columns_Setting__c colSet = new Spender_Selektion_Columns_Setting__c();
                    colSet.Name = colName.Column;
                    colSet.Account_Field__c = colName.AccountField;
                    colSet.Contact_Field__c = colName.ContactField;
                    colSet.Fixed__c = Boolean.valueof(colName.isFixed);
                    colSet.Lead_Fields__c = colName.LeadField;
                    columnSettingInsert.add(colSet);
            }
        }
        if(!mapOfAllCoumnSettingRecord.isEmpty()){
            delete mapOfAllCoumnSettingRecord.values();
        }
        if(!columnSettingInsert.isEmpty()){
            insert columnSettingInsert;
        }
    }
}