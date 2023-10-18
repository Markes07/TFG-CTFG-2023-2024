/*
  * @ComponentName	TFG_CreateAccount
  * @description	  Component to create a new Account
  * @author			    FJMG
  * @email			    fran19943@gmail.com
  * @version		    V0.1
  * @dateCreated	  2023/05/07
  * @lastChange		
*/

public with sharing class TFG_CreateAccount {
    @AuraEnabled
    public static Id createAccount(Account accountInserted) {
        Account newAccount = new Account();
        newAccount = accountInserted;
        insert newAccount;
        return newAccount.Id;
    }
}