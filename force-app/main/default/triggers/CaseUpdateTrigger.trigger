trigger CaseUpdateTrigger on Case (before insert) {
    
    if(Trigger.isBefore){
        for(Case cs : Trigger.New){
            if(cs.Priority != null && cs.Priority == 'Medium'){
                cs.SLAViolation__c = 'No';
            }
            else if(cs.Priority != null && cs.Priority == 'High' ){
                cs.SLAViolation__c = 'Yes';
            }else {
                cs.SLAViolation__c = '';   
            }
        }
    }
		    

     
}