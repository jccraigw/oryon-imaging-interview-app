public with sharing class AccountController {
  @AuraEnabled
  public static List<Account> getAllActiveAccounts() {
    List<Account> acc = [SELECT Id, Name, Active__c FROM Account WHERE Active__c = 'Yes' WITH SECURITY_ENFORCED];
    if (acc.size() == 0) {
      return NULL;
    }                                       
    return acc;
  }

  @AuraEnabled
  public static String deleteSelectedAccount(String Id) {
    Account acc = [SELECT Id , (SELECT Id from Cases ), (SELECT Id,name from Opportunities) FROM Account WHERE Id = :Id WITH SECURITY_ENFORCED];
    try {
      if(acc.Cases.size() > 0){
        delete acc.Cases;
      }
      if(acc.Opportunities.size() > 0){
        delete acc.Opportunities;
      }
      delete acc;
      return 'Success';
    } catch (DmlException e) {
      // Process exception here, for this challenge we will just log
      System.debug(e);
      return 'Failed';
    }
  }
}