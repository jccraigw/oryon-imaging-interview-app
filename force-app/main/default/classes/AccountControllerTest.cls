@IsTest
public inherited sharing class AccountControllerTest {
  private static List<Account> ACCT;
  
  @testSetup 
  static void setup() {
    Account acc = new Account(
            Name ='Test Account',
            Active__c = 'Yes'
    );
    insert acc;
    Case testCase = new Case(
          Subject = 'Test Case', 
          Description = 'Test Case',
          AccountId = acc.Id
    );
    insert testCase;
    Opportunity opp = new Opportunity(
                Name ='Test Opp',
                AccountId = acc.Id,
                StageName = 'New',
                CloseDate = Date.newInstance(2023, 2, 12)
    ); 
    insert opp;
  }

  @IsTest
  static void testGetAllActiveAccounts() {
    getData();
  Test.startTest();
    List<Account> response = AccountController.getAllActiveAccounts();
    System.AssertEquals(ACCT.get(0).get('Name'), response.get(0).get('Name'));
  Test.stopTest();
  }

  @IsTest
  static void testDeleteSelectedAccount() {
    getData();
    Test.startTest();
      String response = AccountController.deleteSelectedAccount(Id.valueOf(ACCT.get(0).Id));
      getData();
      System.AssertEquals(0, ACCT.size());
    Test.stopTest();
  }

  private static void getData(){
    ACCT = [SELECT Id, Name, (SELECT Id from Cases ), (SELECT Id,name from Opportunities) FROM Account WHERE Name = 'Test Account'];
  }
}
