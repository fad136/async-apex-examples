public with sharing class SignatureExampleQueueable implements Queueable {
    public void execute(QueueableContext context) {
        System.debug('SignatureExampleQueueable');
    }

    public static void enqueueWithoutSignature() {
        System.enqueueJob(new SignatureExampleQueueable());
    }

    public static void enqueueWithSignature() {
        AsyncOptions option = new AsyncOptions();
        option.DuplicateSignature = QueueableDuplicateSignature.Builder()
                                        .addId(UserInfo.getUserId())
                                        .addString('Signature')
                                        .build();
        System.enqueueJob(new SignatureExampleQueueable(), option);
    }

}

/* 

HOW TO TEST:
- In the developer console, run the following code:

    SignatureExampleQueueable.enqueueWithoutSignature();
    SignatureExampleQueueable.enqueueWithoutSignature();

    You will notice 2 QueueableHandler logs that show that the queueable was enqueued and successfully executed. If you open the QueueableHandler logs, you will also be able to see the debug logs from the queueable.

- In the developer console, run the following code:

    SignatureExampleQueueable.enqueueWithSignature();
    SignatureExampleQueueable.enqueueWithSignature();

    You will encounter an error that says "Attempt to enqueue job with duplicate queueable signature". This is because the queueable is being enqueued with the same signature as the previous enqueue.

*/