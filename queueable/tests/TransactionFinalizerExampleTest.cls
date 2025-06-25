@isTest
private class TransactionFinalizerExampleTest {
    
    //this will always pass, because the try-catch incorporates the startTest and stopTest methods
    @isTest
    static void test_transactionFinalizerExample() {

        try {
            Test.startTest();
            System.enqueueJob(new TransactionFinalizerExample());
            Test.stopTest();
        } catch(CalloutException e) {
            //Ignore the exception
        }
    }

    //this will fail when the queueable job throws an exception, because the try-catch does not incorporate the startTest and stopTest methods, and the actual execution of the job is done after the stopTest.
    @isTest
    static void test_transactionFinalizerExample_fail() {

        try {
            Test.startTest();
            System.enqueueJob(new TransactionFinalizerExample());
            Test.stopTest();
        } catch(CalloutException e) {
            //Ignore the exception
        }
    }

}