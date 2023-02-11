public with sharing class AccountController {
  @AuraEnabled
  public static List<Account> getAllActiveAccounts() {
    List<Account> acc = [SELECT Id, Name, Active__c FROM Account WHERE Active__c = 'Yes' WITH SECURITY_ENFORCED];
    if (acc.size() == 0) {
      return NULL;
    }                                       

    return acc;
  }
}