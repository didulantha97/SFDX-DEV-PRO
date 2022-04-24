@isTest
private class RestCalloutsTest {
    // Helper method
    static Id createTestRecord() {
        // Create test record
        Case caseTest = new Case(
            Subject='Test record',
            Status='New',
            Origin='Phone',
            Priority='Medium');
        insert caseTest;
        return caseTest.Id;
    }   

    @isTest static void testGetCaseById(){
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri = 
            'https://freightexpresslogisticspvtl-dev-ed.lightning.force.com/services/apexrest/Cases/'
            +recordId;

            request.httpMethod = 'GET';
            RestContext.request = request;
            Case thisCase = RestCallouts.getCaseById();
            System.assert(thisCase != null);
            System.assertEquals('Test record', thisCase.Subject);
    }

    @isTest static void testCreateCase(){
        ID thiscaseId = RestCallouts.createCase('Ferocious chipmunk', 'New', 'Phone', 'Low');
        System.assert(thisCaseId != null);
        Case thisCase = [SELECT Id, Subject FROM Case Where Id = :thiscaseId];
        System.assert(thisCase != null);
        System.assertEquals(thisCase.Subject, 'Ferocious chipmunk');
    }

    @isTest static void testDeleteCase(){
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri = 
        'https://freightexpresslogisticspvtl-dev-ed.lightning.force.com/services/apexrest/Cases/'
            +recordId;

        request.httpMethod = 'DELETE';
        RestContext.request = request;
        RestCallouts.deleteCase();
        List<Case> cases = [SELECT Id FROM Case WHERE Id = :recordId];
        System.assert(cases.size() == 0);
    }

    @isTest static void testUpsertcase(){
        ID case1Id = RestCallouts.upsertCase('Ferocious chipmunk', 'New', 'Phone', 'Low', null);
        System.assert(Case1Id != null);
        Case case1 = [SELECT Id,Subject FROM Case WHERE Id=:case1Id];
        System.assert(case1 != null);
        System.assertEquals(case1.Subject, 'Ferocious chipmunk');

        ID case2Id = RestCallouts.upsertCase('Ferocious chipmunk', 'Working', 'Phone', 'Low', case1Id);
        System.assertEquals(case1Id, case2Id);
        Case case2 = [SELECT Id,Status FROM Case WHERE Id=:case2Id];
        System.assert(case2 != null);
         System.assertEquals(case2.Status, 'Working');
    }

    @isTest static void testUpdateCaseFields(){
       Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://yourInstance.my.salesforce.com/services/apexrest/Cases/'
            + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"status": "Working"}');
        RestContext.request = request;
        // Update status of existing record to Working
        ID thisCaseId = RestCallouts.updateCaseFields();
        // Verify record was updated
        System.assert(thisCaseId != null);
        Case thisCase = [SELECT Id,Status FROM Case WHERE Id=:thisCaseId];
        System.assert(thisCase != null);
        System.assertEquals(thisCase.Status, 'Working');
    }
       
}