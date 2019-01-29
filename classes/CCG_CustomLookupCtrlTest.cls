/**
* @author Badan Singh Pundeer
* @date 23.08.2018
*
* @group CBM-85 Test class
*
* @description Test class for CCG_CustomLookupCtrl class.
*
* @history
* version                   | author                          | changes
*=============================================================================
* 1.0 (23.08.2018)          | Badan Pundeer                   | initial version
*/
@isTest
public class CCG_CustomLookupCtrlTest {
    @TestSetup
    static void setup(){
        Verwendungszweck__c verObj = new Verwendungszweck__c(Name='Ver Test', CBM_Code__c='24556');
        insert verObj;
        Campaign campaignObj = new Campaign(Name='Campaign Test CCG', CBM_Key_Account_Management__c='One to Many',
                                            CBM_Verwendungszweck_1__c = verObj.Id, CBM_Link_zu_Muster__c='Test Link',
                                            IsActive = true, Anlass_Kampagne__c = true);
        insert campaignObj;
        CBM_Massnahme__c massnahmeObj = new CBM_Massnahme__c(Name='CCG Massnahme test 123', CBM_Gehoertzu__c=campaignObj.Id,
                                                             cbm_Verwendungszweck__c = verObj.Id, CBM_Korrespondenzart__c='Telefon');
        insert massnahmeObj;
        CBM_Aktion__c aktionObj = new CBM_Aktion__c(Name='CCG Aktion Test 12', CBM_Gehoertzu__c=massnahmeObj.Id, CBM_Verwendungszweck__c=verObj.Id);
        insert aktionObj;
    }
    
    //test fetchLookUpValues method.
    static testMethod void fetchLookUpValuesTest() {
        //when no result found
    	List <SObject> result = CCG_CustomLookupCtrl.fetchLookUpValues('Test', 'CBM_Massnahme__c', false);
        System.assertEquals(0, result.size());
        
        //one result found
        List <SObject> result2 = CCG_CustomLookupCtrl.fetchLookUpValues('CC', 'CBM_Massnahme__c', false);
        System.assertEquals(1, result2.size());
        
        //no result found
        List <SObject> result3 = CCG_CustomLookupCtrl.fetchLookUpValues('CC', 'Account', false);
        System.assertEquals(0, result3.size());
        
        //no result found
        List <SObject> result4 = CCG_CustomLookupCtrl.fetchLookUpValues('CC', 'Contact', false);
        System.assertEquals(0, result4.size());
        
        //no result found
        List <SObject> result5 = CCG_CustomLookupCtrl.fetchLookUpValues('CC', 'CBM_Massnahme__c', true);
        System.assertEquals(1, result5.size());
    }
}