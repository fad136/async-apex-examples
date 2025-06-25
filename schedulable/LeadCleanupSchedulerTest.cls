@isTest
private class LeadCleanupSchedulerTest {

    @isTest
    static void test_leadCleanupScheduler() {
        Test.startTest();

        String jobId = LeadCleanupScheduler.scheduleJob();

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

        System.assertEquals('0 0 2 ? * SUN', ct.CronExpression, 'Should have scheduled the job to run every Sunday at 2:00 AM');
        System.assertEquals(0, ct.TimesTriggered, 'Should have run 0 times');

        // Verify next fire time is at 2:00 AM
        DateTime nextFireTime = ct.NextFireTime;
        System.assertEquals(2, nextFireTime.hour(), 'Next fire time should be at 2 AM');
        System.assertEquals(0, nextFireTime.minute(), 'Next fire time should be at minute 0');
        System.assertEquals(0, nextFireTime.second(), 'Next fire time should be at second 0');
        // Verify it's on a Sunday
        String dayOfWeek = nextFireTime.format('EEEE');
        System.assertEquals('Sunday', dayOfWeek, 'Next fire time should be on Sunday');

        Test.stopTest();

        //here the job is executed synchronously, so we can add the code to test the actual logic (see batch test)
    }
}