@isTest
public class UserContactCreatorTest {
    
    @isTest
    public static void test_createUserAndContactAsync() {
        // Test with multiple records
        List<String> usernames = new List<String>{
            'user1@example.k2usandbox.com',
            'user2@example.k2usandbox.com',
            'user3@example.k2usandbox.com'
        };
        
        Test.startTest();
        
        for(String username : usernames) {

            //Here the future method is scheduled
            UserContactCreator.createUserAndContactAsync(
                username, 
                username, 
                'TestUser'
            );
        }
        
        Test.stopTest();
        //The future method will run at this point, after the Test.stopTest()
        
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