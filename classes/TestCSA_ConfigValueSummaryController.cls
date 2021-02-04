@isTest
public class TestCSA_ConfigValueSummaryController {
	@isTest
	public static void NumConfigValues() {
		CSA_ConfigValueSummaryController CVSC = new CSA_ConfigValueSummaryController();

		Test.startTest();

		CVSC.getNumConfigValues();

		Test.stopTest();
	}

	@isTest
	public static void NumKYConfigKeys() {
		CSA_ConfigValueSummaryController CVSC = new CSA_ConfigValueSummaryController();

		Test.startTest();

		CVSC.getKYConfigKeys();

		Test.stopTest();
	}

	@isTest
	public static void NumPTConfigKeys() {
		CSA_ConfigValueSummaryController CVSC = new CSA_ConfigValueSummaryController();

		Test.startTest();

		CVSC.getPTConfigKeys();

		Test.stopTest();
	}
}