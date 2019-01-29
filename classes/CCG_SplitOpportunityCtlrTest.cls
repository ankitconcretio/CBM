/**
* @author Badan Singh Pundeer
* @date 29.01.2019
*
* @group CBM-247 Test class
*
* @description Test class for CCG_SplitOpportunityCtlr class.
*
* @history
* version                   | author                          | changes
*=============================================================================
* 1.0 (29.01.2019)          | Badan Pundeer                   | initial version
*/
@isTest
public class CCG_SplitOpportunityCtlrTest {
    @TestSetup
    static void setup(){
        Account accObj = new Account(Name='Test Acc123');
        insert accObj;
        
        Contact conObj = new Contact(LastName='test123Con', Salutation='Frau', AccountId=accObj.Id);
        insert conObj;

        Contact conObj2 = new Contact(LastName='new test1234', Salutation='Frau', AccountId=accObj.Id);
        insert conObj2;
        
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
        
        Opportunity oppObj = new Opportunity(Name='OppObjTest', npsp__Primary_Contact__c=conObj.Id, CBM_Aktionscode__c=aktionObj.Id, CBM_Verwendungszweck__c=verObj.Id,
                                            Amount=50, StageName='Pledged', CloseDate=date.today());
        insert oppObj;
    }

    static testMethod void getAktionsTest() {
        Contact conObj = [SELECT Id,Name FROM Contact LIMIT 1];
        List<String> conIds = new List<String>{conObj.Id};
        String result1 = CCG_SplitOpportunityCtlr.getAktions('test123', 'Contact', conIds);
        System.assertNotEquals(null, result1);

        String result2 = CCG_SplitOpportunityCtlr.getAktions('test', 'CBM_Aktion__c', new List<String>());
        System.assertNotEquals(null, result2);
    }

    static testMethod void updateAndCreateOpportunityTest() {
        Contact conObj = [SELECT Id,Name FROM Contact LIMIT 1];
        Verwendungszweck__c verObj = [SELECT Id,Name FROM Verwendungszweck__c LIMIT 1];
        CBM_Aktion__c aktionObj = [SELECT Id,Name FROM CBM_Aktion__c LIMIT 1];
        Opportunity oppObj = [SELECT Id,Name FROM Opportunity LIMIT 1];
        String result1 = CCG_SplitOpportunityCtlr.updateAndCreateOpportunity(oppObj.Id, new List<Integer>{50},
            new List<String>{verObj.Id}, new List<String>{aktionObj.Id}, new List<String>{conObj.Id});
        System.assertEquals('SUCCESS', result1);
    }

    static testMethod void pageTest(){
        Opportunity oppObj = [SELECT Id,Name FROM Opportunity LIMIT 1];
        PageReference pageRef = Page.CCG_SplitOpportunity;
        pageRef.getParameters().put('id', String.valueOf(oppObj.Id));
        Test.setCurrentPage(pageRef);
        
        CCG_SplitOpportunityCtlr newAktionObj = new CCG_SplitOpportunityCtlr();
    }

}