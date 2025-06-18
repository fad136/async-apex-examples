public with sharing class UserContactCreator {

    // VERSION 1: This will cause a mixed DML error
    // The error occurs because we're trying to create a User and a Contact in the same transaction
    public static void createUserAndContact(String username, String email, String lastName) {
        // Create a contact
        Contact con = new Contact(
            FirstName = 'Test',
            LastName = lastName,
            Email = email
        );
        insert con;

        // Create a user
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

    // VERSION 2: This fixes the mixed DML error using @future
    public static void createUserAndContactAsync(String username, String email, String lastName) {
        // Create contact in the current transaction
        Contact con = new Contact(
            FirstName = 'Test',
            LastName = lastName,
            Email = email
        );
        insert con;

        // Create user asynchronously in a separate transaction
        createUserAsync(username, email, lastName);
    }

    @future
    public static void createUserAsync(String username, String email, String lastName) {
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
}