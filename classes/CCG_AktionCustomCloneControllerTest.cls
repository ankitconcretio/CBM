/**
* @author Badan Singh Pundeer
* @date 18.09.2018
*
* @group Aktion Custom Clone
*
* @description Test class for AktionCustomCloneController class.
*
* @history
* version                   | author                          | changes
*=============================================================================
* 1.0 (18.09.2018)          | Badan Pundeer                   | initial version
*/

@isTest
public class CCG_AktionCustomCloneControllerTest {
    
    @TestSetup
    static void setup(){
        Verwendungszweck__c verObj = new Verwendungszweck__c(Name='Ver Test', CBM_Code__c='24556');
        insert verObj;
        Campaign campaignObj = new Campaign(Name='Campaign Test CCG', CBM_Key_Account_Management__c='One to Many',
                                            CBM_Verwendungszweck_1__c = verObj.Id, CBM_Link_zu_Muster__c='Test Link must');
        insert campaignObj;
        CBM_Massnahme__c massnahmeObj = new CBM_Massnahme__c(Name='CCG Massnahme test 123', CBM_Gehoertzu__c=campaignObj.Id,
                                                             cbm_Verwendungszweck__c = verObj.Id, CBM_Korrespondenzart__c='Telefon');
        insert massnahmeObj;
        
        CBM_Aktion__c aktionObj = new CBM_Aktion__c(Name='CCG Aktion Test 12', CBM_Gehoertzu__c=massnahmeObj.Id, CBM_Verwendungszweck__c=verObj.Id);
        insert aktionObj;
        CBM_Aktionteilnehmer__c aktionTeilObj = new CBM_Aktionteilnehmer__c(Aktion__c=aktionObj.Id);
        insert aktionTeilObj;
    }
    
     //test cloneAktionAndChilds method.
    static testMethod void cloneAktionAndChildsTest() {
        //for success case
        CBM_Aktion__c aktionObj = [SELECT Id, Name, CBM_Gehoertzu__c, CBM_Verwendungszweck__c FROM CBM_Aktion__c LIMIT 1];
        String result = AktionCustomCloneController.cloneAktionAndChilds(aktionObj.Id);
        System.assertNotEquals(null, result);
        
        //for null case
        String result2 = AktionCustomCloneController.cloneAktionAndChilds('');
        System.assertEquals(null, result2);
    }
}