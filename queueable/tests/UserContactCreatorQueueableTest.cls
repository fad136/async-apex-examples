@isTest
private class UserContactCreatorQueueableTest {

    @isTest
    static void test_createUserAndContact() {

        List<String> usernames = new List<String>{
            'user1@example.k2usandbox.com',
            'user2@example.k2usandbox.com',
            'user3@example.k2usandbox.com'
        };

        Test.startTest();
        for(String username : usernames) {
            //The System.enqueueJob call inside the createUserAndContact method will enqueue the job at this point...
            UserContactCreatorQueueable.createUserAndContact(username, username, 'TestUser');
        }
        Test.stopTest();
        //...and the job will run at this point.

        // Verify all contacts were created
        List<Contact> contacts = [
            SELECT Id, Email 
            FROM Contact 
            WHERE Email IN :usernames
        ];
        
        System.assertEquals(3, contacts.size(), 'Should have created 3 contacts');
        
        // Verify all users were created
        List<User> users = [
            SELECT Id, Email 
            FROM User 
            WHERE Email IN :usernames
        ];
        
        System.assertEquals(3, users.size(), 'Should have created 3 users');
    }
}