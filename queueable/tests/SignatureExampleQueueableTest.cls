@isTest
private class SignatureExampleQueueableTest {

    @isTest
    static void test_enqueueWithoutSignature() {
        Test.startTest();
        SignatureExampleQueueable.enqueueWithoutSignature();
        SignatureExampleQueueable.enqueueWithoutSignature();
        Test.stopTest();

        //Verify the job was enqueued
        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob WHERE JobType = 'Queueable'];
        System.assertEquals(2, jobs.size(), 'Should have enqueued 2 jobs');
    }

    @isTest
    static void test_enqueueWithSignature() {
        try {
            Test.startTest();
            SignatureExampleQueueable.enqueueWithSignature();
            SignatureExampleQueueable.enqueueWithSignature();
            Test.stopTest();
        } catch(Exception e) {
            System.assert(e.getTypeName().equals('System.DuplicateMessageException'), 'Should have thrown a DuplicateMessageException');
        }
    }
}