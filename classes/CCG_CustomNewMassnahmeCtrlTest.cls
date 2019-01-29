/**
* @author Badan Singh Pundeer
* @date 23.08.2018
*
* @group CBM-85 Test class
*
* @description Test class for CCG_CustomNewMassnahmeCtrl class.
*
* @history
* version                   | author                          | changes
*=============================================================================
* 1.0 (23.08.2018)          | Badan Pundeer                   | initial version
*/

@isTest
public class CCG_CustomNewMassnahmeCtrlTest {
	
    @TestSetup
    static void setup(){
        Verwendungszweck__c verObj = new Verwendungszweck__c(Name='Ver Test', CBM_Code__c='24556');
        insert verObj;
        Campaign campaignObj = new Campaign(Name='Campaign Test CCG', CBM_Key_Account_Management__c='One to Many',
                                            CBM_Verwendungszweck_1__c = verObj.Id, CBM_Link_zu_Muster__c='Test Link');
        insert campaignObj;
    	CBM_Massnahme__c massnahmeObj = new CBM_Massnahme__c(Name='CCG Massnahme test 123', CBM_Gehoertzu__c=campaignObj.Id,
                                                             cbm_Verwendungszweck__c = verObj.Id, CBM_Korrespondenzart__c='Telefon');
        insert massnahmeObj;
        CBM_Aktion__c aktionObj = new CBM_Aktion__c(Name='CCG Aktion Test 12', CBM_Gehoertzu__c=massnahmeObj.Id, CBM_Verwendungszweck__c=verObj.Id);
        insert aktionObj;
    }
    
    //test getPicklistValues method.
    static testMethod void getPicklistValuesTest() {
        List<String> fieldApiNames = new List<String>{'CBM_Affinit_t_Arbeitsbereich__c', 'CBM_Affinit_t_Land__c'};
        Map<String, List<String>> result = CCG_CustomNewMassnahmeCtrl.getPicklistValues(fieldApiNames, 'CBM_Massnahme__c');
        System.assertNotEquals(null, result);
    }
    
    //test getMassnamheRecord method.
    static testMethod void getMassnahmeRecordTest() {
    	//test using valid massnahme Id.
    	CBM_Massnahme__c massnahmeObj = [SELECT Id, Name, CBM_Korrespondenzart__c FROM CBM_Massnahme__c LIMIT 1];
        Verwendungszweck__c verObj = [SELECT Id,Name FROM Verwendungszweck__c LIMIT 1];
        Campaign campaignObj = [SELECT Id,Name FROM Campaign LIMIT 1];
        CCG_CustomNewMassnahmeCtrl.CampaignAndRelatedRecordsWrpr result = CCG_CustomNewMassnahmeCtrl.getMassnamheRecord(massnahmeObj.Id);
        System.assertEquals(massnahmeObj.CBM_Korrespondenzart__c, result.massnahmeRecord.CBM_Korrespondenzart__c);
        System.assertEquals(verObj.Id, result.verwendungszweckRecord.Id);
        System.assertEquals(campaignObj.Id, result.campaignRecord.Id);
        
        //test using invalid massnahme Id.
        CCG_CustomNewMassnahmeCtrl.CampaignAndRelatedRecordsWrpr result2 = CCG_CustomNewMassnahmeCtrl.getMassnamheRecord('7015E000000TbKTQA0');
        System.assertEquals(null, result2);
        
        //test using blank Id.
        CCG_CustomNewMassnahmeCtrl.CampaignAndRelatedRecordsWrpr result3 = CCG_CustomNewMassnahmeCtrl.getMassnamheRecord('');
        System.assertEquals(null, result3);
    }
    
    //This test method is to test the constructor of the CCG_NewAktionCtrl(controller of vf page)
    @isTest static void pageTest(){
        Campaign campaignObj = [SELECT Id,Name FROM Campaign LIMIT 1];
        PageReference pageRef = Page.CCG_NewMassnahmeOnCampaign;
  		pageRef.getParameters().put('id', String.valueOf(campaignObj.Id));
  		Test.setCurrentPage(pageRef);
        
        CCG_CustomNewMassnahmeCtrl newAktionObj = new CCG_CustomNewMassnahmeCtrl();
    }
    
    //test getCampaignRecord method.
    static testMethod void getCampaignRecordTest() {
    	//test using valid Campaign Id.
    	Campaign campaignObj = [SELECT Id,Name FROM Campaign LIMIT 1];
        Verwendungszweck__c verObj = [SELECT Id,Name FROM Verwendungszweck__c LIMIT 1];
        CCG_CustomNewMassnahmeCtrl.CampaignAndRelatedRecordsWrpr result = CCG_CustomNewMassnahmeCtrl.getCampaignRecord(campaignObj.Id);
        System.assertEquals(campaignObj.Id, result.campaignRecord.Id);
        System.assertEquals(verObj.Id, result.verwendungszweckRecord.Id);
        
        //test using invalid campaign Id.
        CCG_CustomNewMassnahmeCtrl.CampaignAndRelatedRecordsWrpr result2 = CCG_CustomNewMassnahmeCtrl.getCampaignRecord('7015E000000TbKTQ');
        System.assertEquals(null, result2);
        
        //test using blank Id.
        CCG_CustomNewMassnahmeCtrl.CampaignAndRelatedRecordsWrpr result3 = CCG_CustomNewMassnahmeCtrl.getCampaignRecord('');
        System.assertEquals(null, result3);
    }

    //test upsertRecord method.
    static testMethod void upsertRecordTest() {
    	CBM_Massnahme__c massnahmeObj = [SELECT Id, Name, CBM_Korrespondenzart__c FROM CBM_Massnahme__c LIMIT 1];
        massnahmeObj.Name = 'Test New CCG mass';
        CBM_Massnahme__c result = CCG_CustomNewMassnahmeCtrl.upsertRecord(massnahmeObj);
        System.assertEquals('Test New CCG mass', result.Name);
    }
}