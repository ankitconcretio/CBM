/*
* @purpose This class provides test data to test classes.
* @author Badan Singh Pundeer
* @group CBM
* @email support@cloudconsulting24.com
*
* @history:
* version                   | author                       | changes
* ====================================================================================
* 1.0 (17-07-2018)          | Badan Singh Pundeer  		   | initial version
*/
public class CCG_TestDataUtility {   
    public static Campaign createCampaign(){
        Campaign campObj = new Campaign(Name='Test Cpgn');
        insert campObj;
        return campObj;
    }
    
    public static void createBatchTraceData(){
        CCG_Batch_Trace__c bt = new CCG_Batch_Trace__c (
        	Name = 'Default',
            Sync_Limit__c = 10000
        );
        insert bt;
    }
    
    public static List<npe03__Recurring_Donation__c> createRecurringDonations(Integer donationsToCreate){
        List<npe03__Recurring_Donation__c> recList = new List<npe03__Recurring_Donation__c>();
        List<Account> accList = [SELECT Id FROM Account LIMIT 100];
        List<Contact> conList = [SELECT Id FROM Contact LIMIT 100];
        for(Integer i=0; i< donationsToCreate; i++){
            recList.add(new npe03__Recurring_Donation__c(Name='Test CBM Recurring Donation'+i,npe03__Amount__c =123,npe03__Organization__c=accList[i].Id,npe03__Date_Established__c =Date.today()));    
        }        
        if(recList.size() > 0){
            insert recList;     
        }
        return recList;
    }
    
    public static CBM_Massnahme__c createMassnahme(){
        Campaign campObj = createCampaign();
        CBM_Massnahme__c massObj = new CBM_Massnahme__c(Name='Test Massnahme', CBM_Gehoertzu__c=campObj.Id);
        insert massObj;
        return massObj;
    }
    
    public static List<CBM_Aktion__c> createAktions(Integer aktionsToCreate){
        List<CBM_Aktion__c> aktionsList = new List<CBM_Aktion__c>();
        CBM_Massnahme__c massObj = createMassnahme();
        for(Integer i=0; i< aktionsToCreate; i++){
            aktionsList.add(new CBM_Aktion__c(Name='Test CBM aktions'+i, CBM_Gehoertzu__c=massObj.Id, CBM_Aktionscode__c ='0023979',Fremdliste__c = true));		    
        }        
        if(aktionsList.size() > 0){
            insert aktionsList;    
        }
        return aktionsList;
    }
    
    /*public static List<CBM_Aktion__c> createAktions(Integer aktionsToCreate,String aktionCode){
        List<CBM_Aktion__c> aktionsList = new List<CBM_Aktion__c>();
        CBM_Massnahme__c massObj = createMassnahme();
        for(Integer i=0; i< aktionsToCreate; i++){
            aktionsList.add(new CBM_Aktion__c(Name='Test CBM aktions'+i, CBM_Gehoertzu__c=massObj.Id, CBM_Aktionscode__c =aktionCode));		    
        }        
        if(aktionsList.size() > 0){
            insert aktionsList;    
        }
        return aktionsList;
    }*/
    
    public static List<Account> createAccounts(Integer accountsToCreate){
        Id orgRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Organization').getRecordTypeId();
        Id hhRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household Account').getRecordTypeId();
        List<Account> accountList = new List<Account>();
        for(Integer i=0; i< accountsToCreate; i++){    	
            if(i > accountsToCreate/2){
                accountList.add(new Account(Name='Test CBM account'+i,BillingCountry='India',BillingPostalCode='1245',BillingCity='Delhi', RecordTypeId=orgRecTypeId));    
            }
            else{
                accountList.add(new Account(Name='Test CBM account'+i,BillingCountry='India',BillingPostalCode='1245',BillingCity='Delhi', RecordTypeId=hhRecTypeId));    
            }
        }        
        if(accountList.size() > 0){
            insert accountList;    
        }
        return accountList;
    }
    
    public static List<Contact> createContacts(Integer contactsToCreate){
        List<Contact> contactList = new List<Contact>();
        for(Integer i=0; i< contactsToCreate; i++){
            contactList.add(new Contact(LastName='Test CBM contact'+i,Salutation = 'Herr'));		
        }        
        if(contactList.size() > 0){
            insert contactList;  
        }
        return contactList;
    }
    
    public static List<Opportunity> createOpportunities(Integer oppsToCreate){
        List<Opportunity> oppsList = new List<Opportunity>();
        List<Contact> conList = [SELECT Id FROM Contact LIMIT 100];
        List<Account> accList = [SELECT Id FROM Account LIMIT 100];
        for(Integer i=0; i< oppsToCreate; i++){  
            oppsList.add(new Opportunity(Name='Test Opp'+i, StageName='Prospecting', CloseDate=Date.parse('20.07.2018'), npsp__Primary_Contact__c=conList[i].Id, AccountId=accList[i].Id, Amount= 500));            			    
        }        
        if(oppsList.size() > 0){
            insert oppsList;    
        }
        return oppsList;
    }
    
    public static List<Opportunity> createOpportunitiesWithRecordType(Integer oppsToCreate){
        List<Opportunity> oppsList = new List<Opportunity>();
        List<Contact> conList = [SELECT Id FROM Contact LIMIT 100];
        List<Account> accList = [SELECT Id FROM Account LIMIT 100];
        Id recordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();
        for(Integer i=0; i< oppsToCreate; i++){  
            oppsList.add(new Opportunity(Name='Test Opp'+i, StageName='Prospecting',recordtypeid=recordTypeIdOpp , CloseDate=Date.parse('20.07.2018'), npsp__Primary_Contact__c=conList[i].Id, AccountId=accList[i].Id));            			    
        }        
        if(oppsList.size() > 0){
            insert oppsList;    
        }
        return oppsList;
    }
    
    public static List<Lead> createLeads(Integer leadsToCreate){
        List<Lead> leadList = new List<Lead>();
        for(Integer i=0; i< leadsToCreate; i++){
            leadList.add(new Lead(LastName='Test CBM lead'+i, Company='Test Company'+i, CBM_Fremdadressennr__c='1036988787'));		    
        }        
        if(leadList.size() > 0){
            insert leadList;    
        }
        return leadList;
    }

    public static List<CBM_MUF_Zusatzverteiler__c> createZusatzverteilers(Integer zusatzverteilerToCreate){
        List<CBM_MUF_Zusatzverteiler__c> objList = new List<CBM_MUF_Zusatzverteiler__c>();
        for(Integer i=0; i< zusatzverteilerToCreate; i++){
            objList.add(new CBM_MUF_Zusatzverteiler__c (CBM_MUF_Verteiler__c ='CBM- Newsletter'));		    
        }        
        if(objList.size() > 0){
            insert objList;    
        }
        return objList;
    }

    public static void createAffliation(Integer count){
        List<npe5__Affiliation__c> objList = new List<npe5__Affiliation__c>();
        Contact c = [Select Id FROM Contact LIMIT 1];
        Account a = [Select Id FROM Account LIMIT 1];
        Account acc = new Account(Name = 'test');
        insert acc;
        for(Integer i=0;i<count;i++){
            objList.add(new npe5__Affiliation__c  ( npe5__Organization__c =acc.Id,npe5__Contact__c  =c.Id));
        }
        if(objList.size() > 0){
            insert objList;    
        }
    }
    //insert new CBM_MUF_Zusatzverteiler__c (CBM_MUF_Verteiler__c ='CBM- Newsletter');
    
    public static void createSpenderSelektionObjects(){
        List<Spender_Selektion_Object__c> lstSelObjs = new List<Spender_Selektion_Object__c>();
        Spender_Selektion_Object__c selObj1 = new Spender_Selektion_Object__c();
        selObj1.Name = 'account';
        selObj1.Object_Name__c = 'Account';
        selObj1.Account_Field__c = 'Id';
        selObj1.Filter_Fields__c = 'Name,Rating,AccountSource,CBM_Adresse_ungueltig__c';
        lstSelObjs.add(selObj1);
        
        Spender_Selektion_Object__c selObj2 = new Spender_Selektion_Object__c();
        selObj2.Name = 'Contact';
        selObj2.Object_Name__c = 'Contact';
        selObj2.Account_Field__c = 'AccountId';
        selObj2.Filter_Fields__c = 'CBM_MUF_Abzugsverteiler__c,AccountId,CBM_Adelstitel__c,CBM_Adresse_unvollstaendig__c,CBM_Akademischer_Titel__c,CBM_MUF_Anlagecode__c,CBM_Anzahl_der_Haushaltsmitglieder__c,CBM_GS_Berufsgruppe__c,Birthdate,CBM_Dankcode__c,npsp__Deceased__c,DoNotCall,npsp__Do_Not_Contact__c,CBM_Einkommen__c,HasOptedOutOfEmail,CBM_MUF_Geschaetztes_Einkommen__c,CBM_GS_Grossspenderstatus__c,CBM_Grund_Kontaktsperre__c,CBM_Individuelle_Adresse__c,CBM_Individuelle_Ansprache__c,CBM_Key_Account_Management__c,CBM_MUF_Kontakthaeufigkeit__c,npo02__LastOppAmount__c,CBM_LF_Legatstatus__c,MailingCountryCode,CBM_Adresse_ungueltig__c,Retourenstufe__c,Salutation,CBM_MUF_Spender_ROI__c,CBM_GS_Spenderinteresse__c,CBM_MUF_Spenderstatus__c,CBM_MUF_Spenderstufe__c,npo02__TotalOppAmount__c,npo02__NumberOfClosedOpps__c,CBM_Unbekannt_verzogen__c,CBM_Verstorben__c,CBM_individuelle_Bedankung__c,CBM_interne_Rolle__c';
        lstSelObjs.add(selObj2);
        
        upsert lstSelObjs Object_Name__c;
    }
    
    public static void createSpenderSelektionColumnsSetting(){
        List<Spender_Selektion_Columns_Setting__c> spenderSelektionColumnsSettingList = new List<Spender_Selektion_Columns_Setting__c>();
        
        Spender_Selektion_Columns_Setting__c spenderSelektionColumnsSettingObj = new Spender_Selektion_Columns_Setting__c();
        spenderSelektionColumnsSettingObj.Name= 'Country';
        spenderSelektionColumnsSettingObj.Account_Field__c = 'BillingCountry';
        spenderSelektionColumnsSettingObj.Contact_Field__c = 'MailingCountry';
        spenderSelektionColumnsSettingObj.Fixed__c =  true;
        spenderSelektionColumnsSettingObj.Lead_Fields__c = 'npsp__CompanyCountry__c';
        spenderSelektionColumnsSettingList.add(spenderSelektionColumnsSettingObj);
        
        Spender_Selektion_Columns_Setting__c spenderSelektionColumnsSettingObj2 = new Spender_Selektion_Columns_Setting__c();
        spenderSelektionColumnsSettingObj2.Name= 'Last Name';
        spenderSelektionColumnsSettingObj2.Account_Field__c = 'Type';
        spenderSelektionColumnsSettingObj2.Fixed__c =  true;
        spenderSelektionColumnsSettingObj2.Lead_Fields__c = 'LastName';
        spenderSelektionColumnsSettingList.add(spenderSelektionColumnsSettingObj2);
        
        Spender_Selektion_Columns_Setting__c spenderSelektionColumnsSettingObj3 = new Spender_Selektion_Columns_Setting__c();
        spenderSelektionColumnsSettingObj3.Name= 'Name';
        spenderSelektionColumnsSettingObj3.Account_Field__c = 'Name';
        spenderSelektionColumnsSettingObj3.Contact_Field__c = 'FirstName';
        spenderSelektionColumnsSettingObj3.Fixed__c =  true;
        spenderSelektionColumnsSettingObj3.Lead_Fields__c = 'FirstName';
        spenderSelektionColumnsSettingList.add(spenderSelektionColumnsSettingObj3);
        
        insert spenderSelektionColumnsSettingList;
    }
    
    public static void createSpenderSelectionCustomColumn(){
        List<Spender_Selection_Custom_Column__c> spenderSelectionCustomColumnList = new List<Spender_Selection_Custom_Column__c>();
        
        Spender_Selection_Custom_Column__c spenderSelectionCustomColumnObj = new Spender_Selection_Custom_Column__c();
        spenderSelectionCustomColumnObj.Name = 'CBM_Aktion__c';
        spenderSelectionCustomColumnObj.Filter_Fields__c = 'CBM_Affinit_t_Kontinent__c,CBM_Affinit_t_Land__c,Name';
        spenderSelectionCustomColumnObj.Object_Name__c = 'CBM_Aktion__c';
        spenderSelectionCustomColumnList.add(spenderSelectionCustomColumnObj);
        
        Spender_Selection_Custom_Column__c spenderSelectionCustomColumnObj2 = new Spender_Selection_Custom_Column__c();
        spenderSelectionCustomColumnObj2.Name = 'CBM_Massnahme__c';
        spenderSelectionCustomColumnObj2.Filter_Fields__c = 'CBM_Affinit_t_Land__c,CBM_Aktionstyp__c';
        spenderSelectionCustomColumnObj2.Object_Name__c = 'CBM_Massnahme__c';
        spenderSelectionCustomColumnList.add(spenderSelectionCustomColumnObj2);
        
        insert spenderSelectionCustomColumnList;
    }
    
    public static CBM_Aktion_Search_Setting__c createAktionSearchSetting(CBM_Aktion__c aktionobj){
        CBM_Aktion_Search_Setting__c aktionSearchSettingObj =  new CBM_Aktion_Search_Setting__c();
        aktionSearchSettingObj.Aktion__c = aktionobj.Id ;
        aktionSearchSettingObj.Name = 'Test 21';
        aktionSearchSettingObj.Search_Filters__c = '[{"objName":"Account","filters":[{"field":"Name","type":"STRING","fieldLabel":"Account Name","operator":"!=","operatorLabel":"not equals to","value":"eefe","valueLabel":""}]}]';
        insert aktionSearchSettingObj;
        return aktionSearchSettingObj; 
        
    }
    
    public static void createAktionteilnehmerObject(Account accObj,CBM_Aktion__c aktionObj,Contact conObj,Lead leadObj ){
        List<CBM_Aktionteilnehmer__c> aktionteilnehmerObjList = new  List<CBM_Aktionteilnehmer__c>();
        CBM_Aktionteilnehmer__c aktionteilnehmerObj = new CBM_Aktionteilnehmer__c();
        aktionteilnehmerObj.Account__c = accObj.Id;
        aktionteilnehmerObj.Aktion__c = aktionObj.Id;
        aktionteilnehmerObj.Contact__c = conObj.Id;
        aktionteilnehmerObj.Lead__c = leadObj.Id;
        aktionteilnehmerObj.Status__c  = 'In Progress';
        aktionteilnehmerObjList.add(aktionteilnehmerObj);
        
         CBM_Aktionteilnehmer__c aktionteilnehmerObj2 = new CBM_Aktionteilnehmer__c();
       // aktionteilnehmerObj.Account__c = accObj.Id;
        aktionteilnehmerObj2.Aktion__c = aktionObj.Id;
        aktionteilnehmerObj2.Contact__c = conObj.Id;
        //aktionteilnehmerObj.Lead__c = leadObj.Id;
        aktionteilnehmerObj2.Status__c  = 'In Progress';
       aktionteilnehmerObjList.add(aktionteilnehmerObj2); 
        
         CBM_Aktionteilnehmer__c aktionteilnehmerObj3 = new CBM_Aktionteilnehmer__c();
        //aktionteilnehmerObj.Account__c = accObj.Id;
        aktionteilnehmerObj3.Aktion__c = aktionObj.Id;
       // aktionteilnehmerObj.Contact__c = conObj.Id;
        aktionteilnehmerObj3.Lead__c = leadObj.Id;
        aktionteilnehmerObj3.Status__c  = 'In Progress';
       aktionteilnehmerObjList.add(aktionteilnehmerObj3);
        
        insert aktionteilnehmerObjList;
      
    }
    
    /*public static AcxiomSetting__c createAcxiomSetting() {
        AcxiomSetting__c cs = new AcxiomSetting__c(Name='AcxiomSetting',
                                                   Endpoint__c ='https://eu-interactive.acxiom.com/cbmGateway/1.0',
                                                   username__c ='0625113123000001',password__c ='VmN36dE8rU6b');
        insert cs;
        return cs;
    }*/
    
}