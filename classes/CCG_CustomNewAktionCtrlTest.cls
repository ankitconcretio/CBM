/**
* @author Badan Singh Pundeer
* @date 23.08.2018
*
* @group CBM-85 Test class
*
* @description Test class for CCG_CustomNewAktionCtrl class.
*
* @history
* version                   | author                          | changes
*=============================================================================
* 1.0 (23.08.2018)          | Badan Pundeer                   | initial version
*/

@isTest
public class CCG_CustomNewAktionCtrlTest {
    
	@TestSetup
    static void setup(){
        Account accObj = new Account(Name='Test Acc123');
        insert accObj;
        
        Contact conObj = new Contact(LastName='test123Con', Salutation='Frau');
        insert conObj;
        
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
    
    //test getMassnahmeRecord method.
    static testMethod void getMassnahmeRecordTest() {
    	//test using valid massnahme Id.
    	CBM_Massnahme__c massnahmeObj = [SELECT Id, Name, CBM_Korrespondenzart__c FROM CBM_Massnahme__c LIMIT 1];
        Verwendungszweck__c verObj = [SELECT Id,Name FROM Verwendungszweck__c LIMIT 1];
        CCG_CustomNewAktionCtrl.MassnahmeAndRelatedRecordsWrpr result = CCG_CustomNewAktionCtrl.getMassnahmeRecord(massnahmeObj.Id);
        System.assertEquals(massnahmeObj.CBM_Korrespondenzart__c, result.massnahmeRecord.CBM_Korrespondenzart__c);
        System.assertEquals(verObj.Id, result.verwendungszweckRecord.Id);
        
        //test using invalid massnahme Id.
        CCG_CustomNewAktionCtrl.MassnahmeAndRelatedRecordsWrpr result2 = CCG_CustomNewAktionCtrl.getMassnahmeRecord('7015E000000TbKTQA0');
        System.assertEquals(null, result2);
        
        //test using blank Id.
        CCG_CustomNewAktionCtrl.MassnahmeAndRelatedRecordsWrpr result3 = CCG_CustomNewAktionCtrl.getMassnahmeRecord('');
        System.assertEquals(null, result3);
    }
    
    //This test method is to test the constructor of the CCG_NewAktionCtrl(controller of vf page)
    @isTest static void pageTest(){
        CBM_Massnahme__c massnahmeObj = [SELECT Id, Name, CBM_Korrespondenzart__c FROM CBM_Massnahme__c LIMIT 1];
        PageReference pageRef = Page.CCG_NewAktionOnMassnahme;
  		pageRef.getParameters().put('id', String.valueOf(massnahmeObj.Id));
  		Test.setCurrentPage(pageRef);
        
        CCG_CustomNewAktionCtrl newAktionObj = new CCG_CustomNewAktionCtrl();
    }
    
    //test getAktionRecord method.
    static testMethod void getAktionRecordTest() {
    	//test using valid massnahme Id.
    	CBM_Aktion__c aktionObj = [SELECT Id, Name, CBM_Gehoertzu__c, CBM_Verwendungszweck__c FROM CBM_Aktion__c LIMIT 1];
    	CBM_Massnahme__c massnahmeObj = [SELECT Id, Name, CBM_Korrespondenzart__c FROM CBM_Massnahme__c LIMIT 1];
        Verwendungszweck__c verObj = [SELECT Id,Name FROM Verwendungszweck__c LIMIT 1];
        CCG_CustomNewAktionCtrl.MassnahmeAndRelatedRecordsWrpr result = CCG_CustomNewAktionCtrl.getAktionRecord(aktionObj.Id);
        System.assertEquals(aktionObj.Id, result.aktionRecord.Id);
        System.assertEquals(massnahmeObj.Id, result.massnahmeRecord.Id);
        System.assertEquals(verObj.Id, result.verwendungszweckRecord.Id);
        
        //test using invalid aktion Id.
        CCG_CustomNewAktionCtrl.MassnahmeAndRelatedRecordsWrpr result2 = CCG_CustomNewAktionCtrl.getAktionRecord('7015E000000TbKTQ');
        System.assertEquals(null, result2);
        
        //test using blank Id.
        CCG_CustomNewAktionCtrl.MassnahmeAndRelatedRecordsWrpr result3 = CCG_CustomNewAktionCtrl.getAktionRecord('');
        System.assertEquals(null, result3);
    }
    
    //test getPicklistValues method.
    static testMethod void getPicklistValuesTest() {
        List<String> fieldApiNames = new List<String>{'CBM_Affinit_t_Arbeitsbereich__c', 'CBM_Affinit_t_Land__c'};
        CCG_CustomNewAktionCtrl.initValuesWrpr result = CCG_CustomNewAktionCtrl.getPicklistValues(fieldApiNames, 'CBM_Aktion__c', '', '');
        System.assertNotEquals(null, result.picklistValues);
        
        //with Account
        Account accObj = [SELECT Id,Name FROM Account Limit 1];
        CCG_CustomNewAktionCtrl.initValuesWrpr result1 = CCG_CustomNewAktionCtrl.getPicklistValues(fieldApiNames, 'CBM_Aktion__c', accObj.Id, '');
        System.assertNotEquals(null, result1.accountRecord);
        
        //with Contact
        Contact conObj = [SELECT Id,Name FROM Contact Limit 1];
        CCG_CustomNewAktionCtrl.initValuesWrpr result2 = CCG_CustomNewAktionCtrl.getPicklistValues(fieldApiNames, 'CBM_Aktion__c', '', conObj.Id);
        System.assertNotEquals(null, result2.contactRecord);
    }
    
    //test upsertRecord method.
    static testMethod void upsertRecordTest() {
    	CBM_Aktion__c aktionObj = [SELECT Id, Name, CBM_Gehoertzu__c, CBM_Verwendungszweck__c FROM CBM_Aktion__c LIMIT 1];
        aktionObj.Name = 'Test New CCG Ak';
        CBM_Aktion__c result = CCG_CustomNewAktionCtrl.upsertRecord(aktionObj);
        System.assertEquals('Test New CCG Ak', result.Name);
    }

}