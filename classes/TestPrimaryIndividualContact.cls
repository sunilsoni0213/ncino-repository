@isTest
private class TestPrimaryIndividualContact {
	
	@isTest static void noPrimaryContact() {
		Account testAccount = createAccount();
		Contact testContact = createContact(testAccount.Id);

		ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        PrimaryIndividualContactController pic = new PrimaryIndividualContactController(stdController);

        Test.startTest();

        System.assertEquals(true, pic.showNoPrimary);
        System.assertEquals(false, pic.showEdit);
        System.assertEquals(false, pic.showContact);

        Test.stopTest();
	}

	@isTest static void primaryContactExists() {
		Account testAccount = createAccount();
		Contact testContact = createPrimaryContact(testAccount.Id);

		ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        PrimaryIndividualContactController pic = new PrimaryIndividualContactController(stdController);

        Test.startTest();

        System.assertEquals(false, pic.showNoPrimary);
        System.assertEquals(false, pic.showEdit);
        System.assertEquals(true, pic.showContact);

        Test.stopTest();
	}

	@isTest static void editPrimaryContact() {
		Account testAccount = createAccount();
		Contact testContact = createPrimaryContact(testAccount.Id);

		ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        PrimaryIndividualContactController pic = new PrimaryIndividualContactController(stdController);

        Test.startTest();

        pic.theEdit();

        System.assertEquals(false, pic.showNoPrimary);
        System.assertEquals(true, pic.showEdit);
        System.assertEquals(false, pic.showContact);

        Test.stopTest();
	}

	@isTest static void theCancel() {
		Account testAccount = createAccount();
		Contact testContact = createPrimaryContact(testAccount.Id);

		ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        PrimaryIndividualContactController pic = new PrimaryIndividualContactController(stdController);

        Test.startTest();

        pic.theCancel();

        System.assertEquals(false, pic.showNoPrimary);
        System.assertEquals(false, pic.showEdit);
        System.assertEquals(true, pic.showContact);

        Test.stopTest();
	}

	@isTest static void savePrimaryContact() {
		Account testAccount = createAccount();
		Contact testContact = createPrimaryContact(testAccount.Id);

		ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        PrimaryIndividualContactController pic = new PrimaryIndividualContactController(stdController);

        Test.startTest();

        pic.theEdit();

        System.assertEquals(false, pic.showNoPrimary);
        System.assertEquals(true, pic.showEdit);
        System.assertEquals(false, pic.showContact);

        pic.theSavePrimaryConatact();

        Test.stopTest();
	}

	@isTest static void saveNewPrimaryContact() {
		Account testAccount = createAccount();
		Contact testContact = createContact(testAccount.Id);

		ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        PrimaryIndividualContactController pic = new PrimaryIndividualContactController(stdController);

        Test.startTest();

        System.assertEquals(true, pic.showNoPrimary);
        System.assertEquals(false, pic.showEdit);
        System.assertEquals(false, pic.showContact);

        testContact.LLC_BI__Primary_Contact__c = true;

        pic.theSaveNewPrimary();

        Test.stopTest();
	}

	@isTest static void savePrimaryContactError() {
		Account testAccount = createAccount();
		Contact testContact = createContact(testAccount.Id);

		ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        PrimaryIndividualContactController pic = new PrimaryIndividualContactController(stdController);

        Test.startTest();

        pic.theSavePrimaryConatact();

        Test.stopTest();
	}

	@isTest static void saveNewPrimaryContactError() {
		Account testAccount = createAccount();
		Contact testContact = createPrimaryContact(testAccount.Id);

		ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount);
        PrimaryIndividualContactController pic = new PrimaryIndividualContactController(stdController);

        Test.startTest();

        pic.theSaveNewPrimary();

        Test.stopTest();
	}
	
	private static Account createAccount(){
        Account testAccount = new Account(
            Name = 'TestAccount');
        insert testAccount;
        return testAccount;
    }
    private static Contact createContact(Id acctId) {
    	Contact testContact = new Contact(
    		FirstName = 'Test',
    		LastName = 'Name',
    		AccountId = acctId);
		insert testContact;
		return testContact;
	}
	private static Contact createPrimaryContact(Id acctId) {
    	Contact testContact = new Contact(
    		FirstName = 'Test',
    		LastName = 'Name',
    		AccountId = acctId,
    		LLC_BI__Primary_Contact__c = true);
		insert testContact;
		return testContact;
	}
}