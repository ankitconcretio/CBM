/**
* @author Badan Singh Pundeer
* @date 12.12.2018
*
* @group CBM-85 Test class
*
* @description Test class for CCG_CustomAktionRecTypeSelCtrl class.
*
* @history
* version                   | author                          | changes
*=============================================================================
* 1.0 (12.12.2018)          | Badan Pundeer                   | initial version
*/
@isTest
public class CCG_CustomAktionRecTypeSelCtrlTest {
    
    //test getRecTypeValues method.
    static testMethod void getRecTypeValuesTest() {
        //for valid object Name.
        List<CCG_CustomAktionRecTypeSelCtrl.recordTypeValues> result = CCG_CustomAktionRecTypeSelCtrl.getRecTypeValues('CBM_Aktion__c');
        System.assertNotEquals(null, result);
        
        //for blank object Name.
        List<CCG_CustomAktionRecTypeSelCtrl.recordTypeValues> result2 = CCG_CustomAktionRecTypeSelCtrl.getRecTypeValues('');
        System.assertEquals(null, result2);
    }
}