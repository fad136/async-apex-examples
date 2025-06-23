public with sharing class TransactionFinalizerExample implements Queueable, Finalizer {

    public void execute(QueueableContext context) {
        System.attachFinalizer(this);
        System.debug('START QUEUEABLE');
        System.debug('We are in the queueable');
        if(Math.random()/Math.random() > 1) {
            throw new CalloutException('Simulated failure');
        }
        System.debug('END QUEUEABLE');
    }

    public void execute(FinalizerContext context) {
        System.debug('START FINALIZER');
        System.debug('We are in the finalizer');
        System.debug('Result: ' + context.getResult());
        if(context.getResult() == ParentJobResult.UNHANDLED_EXCEPTION) {
            System.debug('Exception: ' + context.getException());
        }
        System.debug('END FINALIZER');
    }
    
}

/* 

HOW TO TEST:
- In the developer console, run the following code:

    TransactionFinalizerExample job = new TransactionFinalizerExample();
    System.enqueueJob(job);
    You have 50% chance of encountering an unhandled exception.

    If you encounter an unhandled exception, you will see the Queueable log with a 'Simulated failure' status and the following in the finalizer log:

    START FINALIZER
    We are in the finalizer
    Result: UNHANDLED_EXCEPTION
    Exception: System.CalloutException: Simulated failure
    END FINALIZER

    If you do not encounter an unhandled exception, you will see the Queueable log with a Success status and the following in the finalizer log:

    START FINALIZER
    We are in the finalizer
    Result: SUCCESS
    END FINALIZER

*/