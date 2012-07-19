@isTest
private class UTInitializationController {
    static testMethod void testPopulateUnits() {
        InitializationController ic = new InitializationController();
                
        Test.startTest();
        Unit__c[] exsistingUnits = [SELECT id from Unit__c];
        delete exsistingUnits;
        PageReference dummyPage = ic.populateUnits();
        Integer unitCount = [SELECT COUNT() FROM Unit__c];
        System.assert(unitCount >= 128);
        Test.stopTest();
    }
}