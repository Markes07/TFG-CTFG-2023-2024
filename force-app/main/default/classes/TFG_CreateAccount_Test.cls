@IsTest
private class TFG_CreateAccount_Test {
    @IsTest
    static void testCreateAccount() {
        // Crear una cuenta de ejemplo para insertar
        Account accountToInsert = new Account();
        accountToInsert.Name = 'Test Account';
        
        // Llamar al método de creación de cuenta
        Id insertedAccountId = TFG_CreateAccount.createAccount(accountToInsert);
        
        // Verificar que se haya insertado correctamente
        Account insertedAccount = [SELECT Id, Name FROM Account WHERE Id = :insertedAccountId];
        System.assertEquals('Test Account', insertedAccount.Name, 'El nombre de la cuenta no coincide');
    }
}