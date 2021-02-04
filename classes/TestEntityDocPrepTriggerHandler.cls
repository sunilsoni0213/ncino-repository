@IsTest
public with sharing class TestEntityDocPrepTriggerHandler {

	@TestSetup
	static void setup() {
		new nFUSE.DataInstaller().onInstall(null);
		CSIDepActDocPrep.Activator act = new CSIDepActDocPrep.Activator();
		act.onActivate();
	}

	@IsTest
	private static void TestEntityDocPrepTriggerHandlerUpdatesEntityCode() {

		String testCode = '20';
		LLC_BI__Ownership_Structure_Type__c testOwnerType = new LLC_BI__Ownership_Structure_Type__c(
			Name = 'Individual',
			LLC_BI__Category__c = 'Individual'
		);
		insert testOwnerType;

		LLC_BI__Ownership_Structure_Role__c testOwnerRole = new LLC_BI__Ownership_Structure_Role__c(
			Name = 'Individual: Authorized Signer',
			LLC_BI__Ownership_Structure_Type__c = testOwnerType.Id,
			LLC_BI__Relationship_Type__c = 'Authorized Signer',
			LLC_BI__Is_Active__c = true,
			nCino_Code__c = testCode
		);
		insert testOwnerRole;

		LLC_BI__Deposit__c testDeposit = new LLC_BI__Deposit__c(
			Name = 'Test Deposit',
			LLC_BI__Amount__c = 500,
			LLC_BI__Stage__c = 'Qualification',
			LLC_BI__Status__c = 'Open',
			LLC_BI__Ownership_Structure_Type__c = testOwnerType.Id
		);
		insert testDeposit;

		Account accnt = new Account(
			Name = 'Test Account'
		);
		insert accnt;

		LLC_BI__Legal_Entities__c ei = new LLC_BI__Legal_Entities__c(
			Name = 'Test Entity1',
			LLC_BI__Deposit__c = testDeposit.Id,
			LLC_BI__Account__c = accnt.Id,
			LLC_BI__Relationship_Type__c = testOwnerRole.LLC_BI__Relationship_Type__c
		);
		insert ei;

		LLC_BI__Legal_Entities__c updateEi = getLegalEntity(ei.Id);
		System.assertEquals(testCode, updateEi.nCino_Code__c);
	}

	private static LLC_BI__Legal_Entities__c getLegalEntity(Id entityId) {
		List<LLC_BI__Legal_Entities__c> entities = [
			SELECT
				Id, 
				nCino_Code__c
			FROM
				LLC_BI__Legal_Entities__c
			WHERE
				Id =: entityId
			LIMIT 1
		];
		if(entities.size() > 0) {
			return entities[0];
		}
		return null;
	}
}