@isTest
private class LeadCleanupBatchTest {

    @TestSetup
    static void setup() {
        /* in order to set the CreatedDate, follow these steps:
        1. Setup > User Interface > Enable "Set Audit Fields upon Record Creation" and "Update Records with Inactive Owners" User Permissions
        2. Create a permission set enabling the "Set Audit Fields upon Record Creation" option under System Permissions
        3. Assign it to the your user */
        List<Lead> leads = new List<Lead>();
        for(Integer i = 0; i < 200; i++) {
            leads.add(new Lead(LastName = 'Test Lead ' + i, Company = 'Test Company ' + i, IsConverted = false, CreatedDate = Date.today().addDays(-366)));
        }
        insert leads;
    }

    @isTest
    static void test_leadCleanupBatch() {
        Test.startTest();
        Database.executeBatch(new LeadCleanupBatch(), 200);
        Test.stopTest();

        //Verify the batch was executed
        List<Lead> leads = [SELECT Id FROM Lead];
        System.assertEquals(0, leads.size(), 'Should have deleted all leads');
    }
}