public with sharing class UserContactCreatorQueueable implements Queueable {
    
    private String username;
    private String email;
    private String lastName;
    
    public UserContactCreatorQueueable(String username, String email, String lastName) {
        this.username = username;
        this.email = email;
        this.lastName = lastName;
    }
    
    public void execute(QueueableContext context) {
        // Create user in the queueable context
        User u = new User(
            Username = username,
            Email = email,
            LastName = lastName,
            Alias = 'tuser',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User'].Id,
            UserRoleId = [SELECT Id FROM UserRole WHERE Name = 'CEO'].Id,
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US'
        );
        insert u;
    }
    
    // Static method to create both contact and user
    public static void createUserAndContact(String username, String email, String lastName) {
        // Create contact in the current transaction
        Contact con = new Contact(
            FirstName = 'Test',
            LastName = lastName,
            Email = email
        );
        insert con;
        
        // Enqueue the user creation
        System.enqueueJob(new UserContactCreatorQueueable(username, email, lastName));
    }
}
