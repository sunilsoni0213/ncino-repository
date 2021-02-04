@isTest
public with sharing class TestTreasuryToolDataInstaller {

	@isTest
    public static void testInstall() {
		Integer recordCount = countRecords();
		System.assertEquals(0, recordCount);
		
		TreasuryToolDataInstaller di = new TreasuryToolDataInstaller();
		di.onInstall(null);

		recordCount = countRecords();
		System.assertEquals(1, recordCount);
		
		di.onInstall(null);
		recordCount = countRecords();
		System.assertEquals(1, recordCount);
    }
    
    @isTest
    public static void testUnInstall() {
		TreasuryToolDataInstaller di = new TreasuryToolDataInstaller();
		di.onInstall(null);

		Integer recordCount = countRecords();
		System.assertEquals(1, recordCount);

		di.onUnInstall(null);    	
		recordCount = countRecords();
		System.assertEquals(0, recordCount);

		di.onUnInstall(null);    	
		recordCount = countRecords();
		System.assertEquals(0, recordCount);
    }
    
    @isTest
    public static void testPostInstallController() {
    	TreasuryToolPostInstallController dpic = new TreasuryToolPostInstallController();
    	PageReference pageRef = dpic.performInstall();
    	System.assertEquals(null, pageRef);
    	System.assertEquals(true, dpic.isInstalled);
    	
    	TreasuryToolPostInstallController dpic1 = new TreasuryToolPostInstallController();
    	pageRef = dpic1.performUninstall();
    	System.assertEquals(null, pageRef);
    	System.assertEquals(false, dpic1.isInstalled);

    	pageRef = dpic.finishInstallation();
    	System.assertEquals('/apex/llc_bi__admin?app=admin.ncinoadmin', pageRef.getUrl());
    }
    
    private static Integer countRecords() {
		Integer recordCount = 
		[
			SELECT
				count()
			FROM
				nFORCE__System_Configuration__c
			WHERE
				name =: TreasuryToolDataInstaller.TREASURY_TOOL
		];

		return recordCount;
    }
    
}