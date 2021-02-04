@isTest
public class TestCSA_OverviewReportUpdateController {
	
	@isTest(SeeAllData=True)
	public static void overviewUpdates() {
		CSA_OverviewReportUpdateController ORUC = new CSA_OverviewReportUpdateController();

		Test.startTest();

		ORUC.overviewUpdate();

		Test.stopTest();
	}
}