@isTest
public with sharing class CaseUpdateTriggerTest {
    @isTest
    static void TestCaseSlaFieldUpdate(){
        Case cs1 = new Case();
        cs1.Origin = 'Phone';
        cs1.Priority = 'Low';
        
        Case cs2 = new Case();
        cs2.Origin = 'Phone';
        cs2.Priority = 'Medium';
        
        Case cs3 = new Case();
        cs3.Origin = 'Phone';
        cs3.Priority = 'High';
        
        Test.startTest();
            insert cs1;
            insert cs2;
            insert cs3;
        Test.stopTest();

    }

    
}

