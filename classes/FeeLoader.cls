public with sharing class FeeLoader {

	public void loadFeeSystemProperties(){
		List<LLC_BI__System_Properties__c> configRecords =
			new List<LLC_BI__System_Properties__c>();
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Appraisal Fee','Appraisal Fee','Fee 001'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Attorney Fee','Attorney Fee','Fee 002'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'City/County Tax Stamps - Deed','City/County Tax Stamps - Deed','Fee 003'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'City/County Tax Stamps - Mortgage','City/County Tax Stamps - Mortgage','Fee 004'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'City Property Tax Fee','City Property Tax Fee','Fee 005'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Closing Fee - 3rd Party','Closing Fee - 3rd Party','Fee 006'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Courier Fee','Courier Fee','Fee 007'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Credit Report Fee','Credit Report Fee','Fee 008'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Doc Prep Fee','Doc Prep Fee','Fee 009'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Escrow Reserve Fee','Escrow Reserve Fee','Fee 010'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Filing Fee','Filing Fee','Fee 011'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Flood Insurance Fee','Flood Insurance Fee','Fee 012'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Homeowners Insurance Fee','Homeowners Insurance Fee','Fee 013'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Origination Fee','Origination Fee','Fee 014'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Owners Title Insurance Fee','Owners Title Insurance Fee','Fee 015'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Pest Inspection Fee','Pest Inspection Fee','Fee 016'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Recording Deed Fee','Recording Deed Fee','Fee 017'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Recording Mortgage Fee','Recording Mortgage Fee','Fee 018'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'State Tax Stamps - Deed - Fee','State Tax Stamps - Deed - Fee','Fee 019'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'State Tax Stamps - Mortgage - Fee','State Tax Stamps - Mortgage - Fee','Fee 020'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Survey Fee','Survey Fee','Fee 021'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Tax Service Fee','Tax Service Fee','Fee 022'));
		configRecords.add(CreateSystemRecord('Fees',TRUE,'Title Exam Fee','Title Exam Fee','Fee 023'));
		
		insert configRecords;		
	}
	
	private LLC_BI__System_Properties__c createSystemRecord (
		String Category_Name,
		Boolean Is_Active,
		String Key,
		String Value,
		String NameString)
	{
		return new LLC_BI__System_Properties__c (
			LLC_BI__Category_Name__c = Category_Name,
			LLC_BI__Is_Active__c = Is_Active,
			LLC_BI__Key__c = Key,
			LLC_BI__Value__c = Value,
			Name = 	nameString		
		);
	}
}