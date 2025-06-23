public class LeadCleanupBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    private Integer leadsProcessed = 0;
    private Integer leadsDeleted = 0;
    private Integer errors = 0;
    
    public Database.QueryLocator start(Database.BatchableContext bc) {

        Date oneYearAgo = Date.today().addDays(-365);
        
        return Database.getQueryLocator([
            SELECT Id
            FROM Lead 
            WHERE CreatedDate < :oneYearAgo 
            AND IsConverted = false
        ]);

    }
    
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        
        List<Lead> leadsToDelete = new List<Lead>();
        
        for(Lead lead : scope) {
            try {
                leadsProcessed++;
                leadsToDelete.add(lead);
                
            } catch(Exception e) {
                errors++;
                System.debug('Error processing lead ' + lead.Id + ': ' + e.getMessage());
            }
        }
        
        try {
            if(!leadsToDelete.isEmpty()) {
                delete leadsToDelete;
                leadsDeleted += leadsToDelete.size();
                System.debug('Deleted ' + leadsToDelete.size() + ' leads');
            }
            
        } catch(Exception e) {
            errors++;
            System.debug('Error deleting leads: ' + e.getMessage());
        }
        
    }
    
    public void finish(Database.BatchableContext bc) {

        Batch_Log__c log = new Batch_Log__c(
            Batch_Name__c = 'Lead Cleanup Batch',
            Records_Processed__c = leadsProcessed,
            Records_Deleted__c = leadsDeleted,
            Errors__c = errors,
            Completion_Date__c = System.now()
        );
        
        try {
            insert log;
            System.debug('Batch log created successfully: ' + log.Id);
        } catch(Exception e) {
            System.debug('Error creating batch log: ' + e.getMessage());
        }
        
        
        String emailBody = 'Lead Cleanup Batch completed!\n\n';
        emailBody += 'Summary:\n';
        emailBody += '- Total leads processed: ' + leadsProcessed + '\n';
        emailBody += '- Leads deleted: ' + leadsDeleted + '\n';
        emailBody += '- Errors: ' + errors + '\n';
        emailBody += '- Completed at: ' + System.now();
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
        mail.setSubject('Lead Cleanup Batch - ' + Date.today());
        mail.setPlainTextBody(emailBody);
        
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        } catch(Exception e) {
            System.debug('Error sending email: ' + e.getMessage());
        }

    }

}