@isTest
public class TestCSA_PSCMgmtConfigController {
	@isTest
	public static void removeAll() {
		CSA_PSCMgmtConfigController PMCC = new CSA_PSCMgmtConfigController();

		Test.startTest();

		PMCC.remove();

		Test.stopTest();
	}
	
	@isTest
	public static void finish() {
		CSA_PSCMgmtConfigController PMCC = new CSA_PSCMgmtConfigController();

		Test.startTest();

		PMCC.finish();

		Test.stopTest();
	}
}