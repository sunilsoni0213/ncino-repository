@IsTest
private class TestCSA_ObjectHistoryController {

	@TestSetup
    private static void createTestRecords() {
		Account newA = new Account(Name = 'TESTOBJHIST');
        newA.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId(); 
		Database.insert(newA);

		
 

		LLC_BI__Loan__c newL = new LLC_BI__Loan__c(
			Name = 'TESTOBJHIST',
			LLC_BI__Account__c = newA.Id,
			LLC_BI__lookupKey__c = '8235125',
        	LLC_BI__Stage__c = 'Booked',
        	LLC_BI__Status__c = 'Open');
        
		Database.insert(newL); 
        LLC_BI__Legal_Entities__c newLE = new LLC_BI__Legal_Entities__c(
        	LLC_BI__Loan__c = newL.Id,
        	LLC_BI__Account__c = newA.Id,
			LLC_BI__Borrower_Type__c = 'Borrower');
        
        Database.insert(newLE); 
	}

    static testMethod void test1() {
        

        LLC_BI__Loan__c myLoan = [SELECT Id, Name, LLC_BI__Risk_Grade__c FROM LLC_BI__Loan__c WHERE Name = :'TESTOBJHIST'];
 
		PageReference pageRef = Page.CSA_ObjectHistory;
        Test.setCurrentPage(pageRef); 
		pageRef.getParameters().put('id', String.valueOf(myLoan.Id)); 
      
        CSA_ObjectHistoryController ctrlr = new CSA_ObjectHistoryController();
 
        // Verify that page fails without parameters (NEGATIVE)
		// TO DO

		// Verify that the page works with parameters (POSITIVE)
		// NOTE: Cannot actually test the history table!! 
		// Should assert a value of 1 but because history table is not created in unit test it does not return any history records.
		// http://boards.developerforce.com/t5/Visualforce-Development/Unit-Testing-and-History-Table/td-p/142422
        System.assertEquals(ctrlr.getRecordList().size(), 0);

		ctrlr.NextPage();
		ctrlr.PreviousPage();
    } 
}