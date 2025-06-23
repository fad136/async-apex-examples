public class LeadCleanupScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        LeadCleanupBatch batchJob = new LeadCleanupBatch();
        Database.executeBatch(batchJob, 200);
    }
    
    public static String scheduleJob() {
        LeadCleanupScheduler scheduler = new LeadCleanupScheduler();
        return System.schedule('Lead Cleanup - Weekly', '0 0 2 ? * SUN', scheduler);
    }
    
} 