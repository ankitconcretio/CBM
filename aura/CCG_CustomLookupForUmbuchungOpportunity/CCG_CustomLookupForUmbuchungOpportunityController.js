({
   onfocus : function(component,event,helper){
       $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
         helper.searchHelper(component,event,getInputkeyWord);
    },
    onblur : function(component,event,helper){       
        component.set("v.listOfSearchRecords", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
         var getInputkeyWord = component.get("v.SearchKeyWord");
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
	},
    
  // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        debugger;
        console.log('ttttt::'+component.get("v.quittungsID"));
        
        if(component.get("v.quittungsID")){
              
            if(component.get("v.verwendungsId") == "verwendungsId" || component.get("v.aktionId") == "aktionId"){
                var pillTarget = component.find("lookup-pill");
                var lookUpTarget = component.find("lookupField"); 
                
                $A.util.addClass(pillTarget, 'slds-hide');
                $A.util.removeClass(pillTarget, 'slds-show');
                
                $A.util.addClass(lookUpTarget, 'slds-show');
                $A.util.removeClass(lookUpTarget, 'slds-hide');
                
                component.set("v.showDetail", false);
                component.set("v.SearchKeyWord",null);
                component.set("v.listOfSearchRecords", null );
                component.set("v.selectedRecord", {} );
            }
            
        }else{
            var pillTarget = component.find("lookup-pill");
            var lookUpTarget = component.find("lookupField"); 
            
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide');
            
            component.set("v.showDetail", false);
            component.set("v.SearchKeyWord",null);
            component.set("v.listOfSearchRecords", null );
            component.set("v.selectedRecord", {} ); 
        }
        
       
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        debugger;
    // get the selected Account record from the COMPONETN event 	 
       var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log(selectedAccountGetFromEvent);
        console.log('vikash:::selectedAccountGetFromEvent::'+selectedAccountGetFromEvent.Name);
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
       
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
        
      /*   var forclose = component.find("VerwendungszweckId");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide'); */
  
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        
        var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');  
      
	},
    
   itemsChange :  function(component, event, helper) {
       var tt = component.get("v.selectedRecord");
        if(component.get("v.selectedRecord.quittungsID")){
            component.set("v.quittungsID",component.get("v.selectedRecord.quittungsID"));
        }
        console.log('vikahhsh quittungsID:::'+component.get("v.quittungsID"))
        console.log(component.get("v.selectedRecord.name"));
        if(component.get("v.selectedRecord.Name") != undefined){
       //   if(component.get("v.showDetail")){ 
            component.set("v.showDetail", false);
            
            var forclose = component.find("lookup-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');
            
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
            var lookUpTarget = component.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show'); 
          /*  
            if(component.get("v.selectedRecord.name") == null){            
                var pillTarget = component.find("lookup-pill");
                var lookUpTarget = component.find("lookupField");  
                
                $A.util.addClass(pillTarget, 'slds-hide');
                $A.util.removeClass(pillTarget, 'slds-show');
                
                $A.util.addClass(lookUpTarget, 'slds-show');
                $A.util.removeClass(lookUpTarget, 'slds-hide');
            }*/
        }
        else{
            var pillTarget = component.find("lookup-pill");
            var lookUpTarget = component.find("lookupField"); 
            
            $A.util.addClass(pillTarget, 'slds-hide');
            $A.util.removeClass(pillTarget, 'slds-show');
            
            $A.util.addClass(lookUpTarget, 'slds-show');
            $A.util.removeClass(lookUpTarget, 'slds-hide');
        }
        
        console.log('selected Record::'+component.get("v.selectedRecord"));
        console.log(component.get("v.selectedRecord.name"));
        console.log(component.get("v.selectedRecord"));
    },
    doInit : function(component, event, helper) {
         console.log('selected Record vikash::'+component.get("v.quittungsID"));
    
    }
})