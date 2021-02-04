@isTest
public class TestCSA_OverviewController {
	
	@isTest
	public static void initialize() {
		Overview_Properties__c testOverviewProperty1 = createOverviewProperty('12345', 'Usable_Product_Line', 'Commercial', null);
		Overview_Properties__c testOverviewProperty2 = createOverviewProperty('123456', 'Usable_Stage', 'Qualification', null);
		Overview_Properties__c testOverviewProperty3 = createOverviewProperty('123456', 'Usable_Stage', 'Proposal', 'TestLinkHere');
		Overview_Properties__c testOverviewProperty4 = createOverviewProperty('1234567', 'Usable_Status', 'Open', null);
		LLC_BI__Loan__c testLoan1 = createLoan('Test Loan1', 'Qualification', 'Open', 'Commercial', null);
		LLC_BI__Loan__c testLoan2 = createLoan('Test Loan1', 'Proposal', 'Open', 'Commercial', null);
		CSA_OverviewController OCC = new CSA_OverviewController();
	}

	@isTest
	public static void branches() {
		LLC_BI__Branch__c testBranch = createBranch();
		CSA_OverviewController OCC = new CSA_OverviewController();

		Test.startTest();

		OCC.getBranchesPicklist();

		Test.stopTest();
	}

	@isTest
	public static void loanTeamMembers() {
		Profile platformUser = [select id from Profile where Name = 'Standard Platform User'];
		User testUser = testUserCreation('Joe', 'Smith', 'joe@acme.com', 'testing123456780@ncino.com', platformUser.Id);
		insert testUser;
		LLC_BI__Loan__c testLoan1 = createLoan('Test Loan1', 'Qualification', 'Open', 'Commercial', null);
		LLC_BI__LoanTeam__c testLoanTeam = createLoanTeamMember(testLoan1.Id, testUser.Id);
		CSA_OverviewController OCC = new CSA_OverviewController();
		
		Test.startTest();

		OCC.getLoanTeamMembersPicklist();

		Test.stopTest();
	}

	@isTest
	public static void applyBranch() {
		Overview_Properties__c testOverviewProperty1 = createOverviewProperty('12345', 'Usable_Product_Line', 'Commercial', null);
		Overview_Properties__c testOverviewProperty2 = createOverviewProperty('123456', 'Usable_Stage', 'Qualification', null);
		Overview_Properties__c testOverviewProperty3 = createOverviewProperty('123456', 'Usable_Stage', 'Proposal', 'TestLinkHere');
		Overview_Properties__c testOverviewProperty4 = createOverviewProperty('1234567', 'Usable_Status', 'Open', null);
		LLC_BI__Branch__c testBranch = createBranch();
		LLC_BI__Loan__c testLoan1 = createLoan('Test Loan1', 'Qualification', 'Open', 'Commercial', testBranch.Id);
		LLC_BI__Loan__c testLoan2 = createLoan('Test Loan1', 'Proposal', 'Open', 'Commercial', null);
		CSA_OverviewController OCC = new CSA_OverviewController();

		Test.startTest();

		OCC.selectedBranch = testBranch.Id;
		OCC.applyFilter();

		Test.stopTest();
	}

	@isTest
	public static void applyLoanTeam() {
		Profile platformUser = [select id from Profile where Name = 'Standard Platform User'];
		User testUser = testUserCreation('Joe', 'Smith', 'joe@acme.com', 'testing123456780@ncino.com', platformUser.Id);
		insert testUser;
		Overview_Properties__c testOverviewProperty1 = createOverviewProperty('12345', 'Usable_Product_Line', 'Commercial', null);
		Overview_Properties__c testOverviewProperty2 = createOverviewProperty('123456', 'Usable_Stage', 'Qualification', null);
		Overview_Properties__c testOverviewProperty3 = createOverviewProperty('123456', 'Usable_Stage', 'Proposal', 'TestLinkHere');
		Overview_Properties__c testOverviewProperty4 = createOverviewProperty('1234567', 'Usable_Status', 'Open', null);
		LLC_BI__Loan__c testLoan1 = createLoan('Test Loan1', 'Qualification', 'Open', 'Commercial', null);
		LLC_BI__Loan__c testLoan2 = createLoan('Test Loan1', 'Proposal', 'Open', 'Commercial', null);
		LLC_BI__LoanTeam__c testLoanTeam = createLoanTeamMember(testLoan1.Id, testUser.Id);
		CSA_OverviewController OCC = new CSA_OverviewController();

		Test.startTest();

		OCC.selectedLoanTeamMember = testLoanTeam.Id;
		OCC.applyFilter();

		Test.stopTest();
	}

	@isTest
	public static void applyLoanTeamAndBranch() {
		Profile platformUser = [select id from Profile where Name = 'Standard Platform User'];
		User testUser = testUserCreation('Joe', 'Smith', 'joe@acme.com', 'testing123456780@ncino.com', platformUser.Id);
		insert testUser;
		Overview_Properties__c testOverviewProperty1 = createOverviewProperty('12345', 'Usable_Product_Line', 'Commercial', null);
		Overview_Properties__c testOverviewProperty2 = createOverviewProperty('123456', 'Usable_Stage', 'Qualification', null);
		Overview_Properties__c testOverviewProperty3 = createOverviewProperty('123456', 'Usable_Stage', 'Proposal', 'TestLinkHere');
		Overview_Properties__c testOverviewProperty4 = createOverviewProperty('1234567', 'Usable_Status', 'Open', null);
		LLC_BI__Branch__c testBranch = createBranch();
		LLC_BI__Loan__c testLoan1 = createLoan('Test Loan1', 'Qualification', 'Open', 'Commercial', testBranch.Id);
		LLC_BI__Loan__c testLoan2 = createLoan('Test Loan1', 'Proposal', 'Open', 'Commercial', null);
		LLC_BI__LoanTeam__c testLoanTeam = createLoanTeamMember(testLoan1.Id, testUser.Id);
		CSA_OverviewController OCC = new CSA_OverviewController();

		Test.startTest();

		OCC.selectedBranch = testBranch.Id;
		OCC.selectedLoanTeamMember = testLoanTeam.Id;
		OCC.applyFilter();

		Test.stopTest();
	}

	@isTest
	public static void checkMapSize() {
		Overview_Properties__c testOverviewProperty1 = createOverviewProperty('12345', 'Usable_Product_Line', 'Commercial', null);
		Overview_Properties__c testOverviewProperty2 = createOverviewProperty('123456', 'Usable_Stage', 'Qualification', null);
		Overview_Properties__c testOverviewProperty3 = createOverviewProperty('123456', 'Usable_Stage', 'Proposal', 'TestLinkHere');
		Overview_Properties__c testOverviewProperty4 = createOverviewProperty('1234567', 'Usable_Status', 'Open', null);
		LLC_BI__Loan__c testLoan1 = createLoan('Test Loan1', 'Qualification', 'Open', 'Commercial', null);
		LLC_BI__Loan__c testLoan2 = createLoan('Test Loan1', 'Proposal', 'Open', 'Commercial', null);
		CSA_OverviewController OCC = new CSA_OverviewController();

		Test.startTest();

		OCC.getCheckMapSize();

		Test.stopTest();
	}

	private static LLC_BI__Loan__c createLoan(String tName, String stage, String status, String pLine, Id branchId) {
		LLC_BI__Loan__c newL = new LLC_BI__Loan__c(
			Name = tName,
			LLC_BI__Stage__c = stage,
			LLC_BI__Status__c = status,
			LLC_BI__Product_Line__c = pLine,
			LLC_BI__Branch__c = branchId);

		Database.insert(newL);
		return newL;
	}

	private static LLC_BI__Branch__c createBranch() {
		LLC_BI__Branch__c newB = new LLC_BI__Branch__c(
			Name = 'Test');

		Database.insert(newB);
		return newB;
	}

	private static LLC_BI__LoanTeam__c createLoanTeamMember(Id loanId, Id userId) {
		LLC_BI__LoanTeam__c newLT = new LLC_BI__LoanTeam__c(
			LLC_BI__Loan__c = loanId,
			LLC_BI__User__c = userId);

		Database.insert(newLT);
		return newLT;
	}

	private static Overview_Properties__c createOverviewProperty(String tName, String category, String sName, String reportName) {
		Overview_Properties__c newOP = new Overview_Properties__c(
			Name = tName,
			Category_Name__c = category,
			Stage_Status_Product_Line_Name__c = sName,
			Is_Active__c = true,
			Report_Id__c = reportName);

		Database.insert(newOP);
		return newOP;
	}
	 
	private static User DummyUser {
		get {
			if (DummyUser == null) {
				DummyUser = [SELECT 
								Id, 
								TimeZoneSidKey, 
								LocaleSidKey, 
								EmailEncodingKey, 
								ProfileId, 
								LanguageLocaleKey
							FROM 
								User limit 1];
			}
			return DummyUser ;
		} set ;
	}

	private static User testUserCreation(String firstName, String lastName, String email, String userName, Id profileId) {
		return new User(
			FirstName = firstName,
			LastName = lastName,
			Email = email,
			Username = userName,
			ProfileId = profileId,
			Alias = lastName.substring(0,5),
			CommunityNickname = lastName.substring(0,5),
			TimeZoneSidKey = DummyUser.TimeZoneSidKey,
			LocaleSidKey = DummyUser.LocaleSidKey,
			EmailEncodingKey = DummyUser.EmailEncodingKey,
			LanguageLocaleKey = DummyUser.LanguageLocaleKey);
	}
}