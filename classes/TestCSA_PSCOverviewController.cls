@isTest
public class TestCSA_PSCOverviewController {
	@isTest
	public static void NumProductTypes() {
		CSA_PSCOverviewController POC = new CSA_PSCOverviewController();

		Test.startTest();

		POC.getNumProductTypes();

		Test.stopTest();
	}

	@isTest
	public static void NumBooked() {
		CSA_PSCOverviewController POC = new CSA_PSCOverviewController();

		Test.startTest();

		POC.getNumBookedConfig();

		Test.stopTest();
	}

	@isTest
	public static void NumClosed() {
		CSA_PSCOverviewController POC = new CSA_PSCOverviewController();

		Test.startTest();

		POC.getNumClosedConfig();

		Test.stopTest();
	}

	@isTest
	public static void NumExcluded() {
		CSA_PSCOverviewController POC = new CSA_PSCOverviewController();

		Test.startTest();

		POC.getNumExcludedConfig();

		Test.stopTest();
	}

	@isTest
	public static void NumTransmit() {
		CSA_PSCOverviewController POC = new CSA_PSCOverviewController();

		Test.startTest();

		POC.getNumTransmitConfig();

		Test.stopTest();
	}

	@isTest
	public static void productTypes() {
		CSA_PSCOverviewController POC = new CSA_PSCOverviewController();

		Test.startTest();

		POC.getProductTypes();

		Test.stopTest();
	}

	@isTest
	public static void callfieldSet() {
		CSA_PSCOverviewController POC = new CSA_PSCOverviewController();

		Test.startTest();

		POC.getProductTypeFieldSetList();

		Test.stopTest();
	}
}