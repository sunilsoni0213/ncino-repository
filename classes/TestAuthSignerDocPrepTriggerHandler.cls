/**
 * DocPrep Plugin
 **/
@isTest
public with sharing class TestAuthSignerDocPrepTriggerHandler {
	@TestSetup
	private static void testSetup() {
		new nFUSE.DataInstaller().onInstall(null);
		CSIDepActDocPrep.Activator act = new CSIDepActDocPrep.Activator();
		act.onActivate();
	}

	@IsTest
	private static void testAuthSignerDocPrepTriggerHandlerUpdatesCSICodeForValidASRole() {
		final String CSI_CODE = '20';

		LLC_BI__Ownership_Structure_Type__c individualOwnershipStructureType = new LLC_BI__Ownership_Structure_Type__c(
			Name = 'Individual',
			LLC_BI__Category__c = 'Individual'
		);
		insert individualOwnershipStructureType;

		LLC_BI__Ownership_Structure_Role__c authorizedSignerRole = new LLC_BI__Ownership_Structure_Role__c(
			Name = 'Individual: AS Test Role',
			LLC_BI__Ownership_Structure_Type__c = individualOwnershipStructureType.Id,
			LLC_BI__Relationship_Type__c = 'AS Test Role',
			LLC_BI__Is_Active__c = true,
			nCino_Code__c = CSI_CODE,
			LLC_BI__Is_Authorized_Signer__c = true
		);
		insert authorizedSignerRole;

		Account businessAccount = new Account(
			Name = 'Business Account',
			Type = 'Corporation'
		);
		insert businessAccount;

		LLC_BI__Deposit__c testDeposit = new LLC_BI__Deposit__c(
			Name = 'Test Deposit',
			LLC_BI__Amount__c = 500,
			LLC_BI__Stage__c = 'Qualification',
			LLC_BI__Status__c = 'Open',
			LLC_BI__Ownership_Structure_Type__c = individualOwnershipStructureType.Id
		);
		insert testDeposit;

		LLC_BI__Legal_Entities__c primaryOwnerEntity = new LLC_BI__Legal_Entities__c(
			Name = 'Primary Owner 1',
			LLC_BI__Deposit__c = testDeposit.Id,
			LLC_BI__Account__c = businessAccount.Id,
			LLC_BI__Relationship_Type__c = 'Primary Owner'
		);
		insert primaryOwnerEntity;

		Account authorizedSignerAccount = new Account(
			Name = 'AuthorizedSigner Account',
			Type = 'Individual'
		);
		insert authorizedSignerAccount;

		Contact authorizedSignerContact = new Contact(
			FirstName = 'AuthorizedSigner',
			LastName = 'Account',
			LLC_BI__Primary_Contact__c = true,
			AccountId = authorizedSignerAccount.Id
		);
		insert authorizedSignerContact;

		LLC_BI__Contingent_Liabilty__c authorizedSigner = new LLC_BI__Contingent_Liabilty__c(
			LLC_BI__Entity__c = primaryOwnerEntity.Id,
			LLC_BI__Contact__c = authorizedSignerContact.Id,
			LLC_BI__Ownership_Structure_Role__c = authorizedSignerRole.Id
		);
		insert authorizedSigner;

		// Verify that the Authorized Signer trigger mapped the nCino code from the ownership structure role to the AS
		authorizedSigner = getAuthorizedSigner(authorizedSigner.Id);
		System.assertEquals(CSI_CODE, authorizedSigner.nCino_Code__c);
	}

	@IsTest
	private static void testAuthSignerDocPrepTriggerHandlerHandlesNoOwnershipStructureOnAS() {
		Account businessAccount = new Account(
			Name = 'Business Account',
			Type = 'Corporation'
		);
		insert businessAccount;

		LLC_BI__Deposit__c testDeposit = new LLC_BI__Deposit__c(
			Name = 'Test Deposit'
		);
		insert testDeposit;

		LLC_BI__Legal_Entities__c primaryOwnerEntity = new LLC_BI__Legal_Entities__c(
			Name = 'Primary Owner 1',
			LLC_BI__Deposit__c = testDeposit.Id,
			LLC_BI__Account__c = businessAccount.Id,
			LLC_BI__Relationship_Type__c = 'Primary Owner'
		);
		insert primaryOwnerEntity;

		Account authorizedSignerAccount = new Account(
			Name = 'AuthorizedSigner Account',
			Type = 'Individual'
		);
		insert authorizedSignerAccount;

		Contact authorizedSignerContact = new Contact(
			FirstName = 'AuthorizedSigner',
			LastName = 'Account',
			LLC_BI__Primary_Contact__c = true,
			AccountId = authorizedSignerAccount.Id
		);
		insert authorizedSignerContact;

		LLC_BI__Contingent_Liabilty__c authorizedSigner = new LLC_BI__Contingent_Liabilty__c(
			LLC_BI__Entity__c = primaryOwnerEntity.Id,
			LLC_BI__Contact__c = authorizedSignerContact.Id
		);
		insert authorizedSigner;

		authorizedSigner = getAuthorizedSigner(authorizedSigner.Id);
		System.assertEquals(null, authorizedSigner.nCino_Code__c);
	}

	@IsTest
	private static void testAuthSignerDocPrepTriggerHandlerDoesNotProcessInLoanScenario() {
		Account businessAccount = new Account(
			Name = 'Business Account',
			Type = 'Corporation'
		);
		insert businessAccount;

		LLC_BI__Loan__c testLoan = new LLC_BI__Loan__c(
			Name = 'Test Loan',
			LLC_BI__Amount__c = 125000
		);
		insert testLoan;

		LLC_BI__Legal_Entities__c borrowerEntity = new LLC_BI__Legal_Entities__c(
			Name = 'Primary Owner 1',
			LLC_BI__Loan__c = testLoan.Id,
			LLC_BI__Account__c = businessAccount.Id,
			LLC_BI__Borrower_Type__c = 'Borrower'
		);
		insert borrowerEntity;

		Account authorizedSignerAccount = new Account(
			Name = 'AuthorizedSigner Account',
			Type = 'Individual'
		);
		insert authorizedSignerAccount;

		Contact authorizedSignerContact = new Contact(
			FirstName = 'AuthorizedSigner',
			LastName = 'Account',
			LLC_BI__Primary_Contact__c = true,
			AccountId = authorizedSignerAccount.Id
		);
		insert authorizedSignerContact;

		LLC_BI__Contingent_Liabilty__c authorizedSigner = new LLC_BI__Contingent_Liabilty__c(
			LLC_BI__Entity__c = borrowerEntity.Id,
			LLC_BI__Contact__c = authorizedSignerContact.Id
		);
		insert authorizedSigner;

		authorizedSigner = getAuthorizedSigner(authorizedSigner.Id);
		System.assertEquals(null, authorizedSigner.nCino_Code__c);
	}

	private static LLC_BI__Contingent_Liabilty__c getAuthorizedSigner(Id authorizedSignerId) {
		return [
			SELECT
				Id,
				nCino_Code__c
			FROM
				LLC_BI__Contingent_Liabilty__c
			WHERE
				Id = :authorizedSignerId
		];
	}
}