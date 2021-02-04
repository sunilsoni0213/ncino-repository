@isTest
public with sharing class TestTreasuryToolPostInstallController {

    @isTest
    static void testControllerInitialization() {
    	Test.startTest();
    	
    	TreasuryToolPostInstallController ttpic = new TreasuryToolPostInstallController();
    	System.assertEquals(false, ttpic.isInstalled);
    	System.assertEquals(false, ttpic.isToolDataInstalled);
     	
    	Test.stopTest();    	
    }  
    
      
    @isTest
    static void testPerformInstall() {
    	Test.startTest();
    	
    	TreasuryToolPostInstallController ttpic = new TreasuryToolPostInstallController();
    	System.assertEquals(false, ttpic.isInstalled);
    	System.assertEquals(false, ttpic.isToolDataInstalled);
    	
    	PageReference pageRef = ttpic.performInstall();
    	System.assertEquals(true, ttpic.isInstalled);
    	System.assertEquals(true, ttpic.isToolDataInstalled);
    	
    	ApexPages.Message confirmMessage = ApexPages.getMessages()[0];
    	System.assertEquals(TreasuryToolPostInstallController.CONFIGURATION_INSTALLED_SUCCESSFULLY, confirmMessage.getDetail());
    	
    	Test.stopTest();    	
    }  
    
    @isTest
    static void testPerformAlreadyInstalled() {
    	
    	Test.startTest();
    	
    	TreasuryToolPostInstallController ttpic = new TreasuryToolPostInstallController();
    	System.assertEquals(false, ttpic.isInstalled);
    	System.assertEquals(false, ttpic.isToolDataInstalled);
    	
    	PageReference pageRef = ttpic.performInstall();
    	System.assertEquals(true, ttpic.isInstalled);
    	System.assertEquals(true, ttpic.isToolDataInstalled);
    	
    	ApexPages.Message confirmMessage = ApexPages.getMessages()[0];
    	System.assertEquals(TreasuryToolPostInstallController.CONFIGURATION_INSTALLED_SUCCESSFULLY, confirmMessage.getDetail());
    	
    	pageRef = ttpic.performInstall();
    	System.assertEquals(true, ttpic.isInstalled);
    	System.assertEquals(true, ttpic.isToolDataInstalled);
    	
    	confirmMessage = ApexPages.getMessages()[1];
    	System.assertEquals(TreasuryToolPostInstallController.CONFIGURATION_SYSTEM_ALREADY_INSTALLED, confirmMessage.getDetail());
    	
    	Test.stopTest();    	
    }  
    
    @isTest
    static void testPerformUninstalled() {
    	
    	TreasuryToolPostInstallController ttpic = new TreasuryToolPostInstallController();
    	System.assertEquals(false, ttpic.isInstalled);
    	System.assertEquals(false, ttpic.isToolDataInstalled);
    	
    	PageReference pageRef = ttpic.performInstall();
    	System.assertEquals(true, ttpic.isInstalled);
    	System.assertEquals(true, ttpic.isToolDataInstalled);
    	
    	ApexPages.Message confirmMessage = ApexPages.getMessages()[0];
    	System.assertEquals(TreasuryToolPostInstallController.CONFIGURATION_INSTALLED_SUCCESSFULLY, confirmMessage.getDetail());
    	
    	System.assertEquals(true, ttpic.isInstalled);
    	System.assertEquals(true, ttpic.isToolDataInstalled);
    	
    	Test.startTest();
    	ttpic = new TreasuryToolPostInstallController();
    	pageRef = ttpic.performUninstall();
    	System.assertEquals(false, ttpic.isInstalled);
    	System.assertEquals(false, ttpic.isToolDataInstalled);
    	
    	confirmMessage = ApexPages.getMessages()[1];
    	System.assertEquals(TreasuryToolPostInstallController.CONFIGURATION_REMOVED_SUCCESSFULLY, confirmMessage.getDetail());
    	
    	Test.stopTest();    	
    }  
    
    @isTest
    static void testPerformAlreadyUninstalled() {
    	
    	Test.startTest();
    	
    	TreasuryToolPostInstallController ttpic = new TreasuryToolPostInstallController();
    	System.assertEquals(false, ttpic.isInstalled);
    	System.assertEquals(false, ttpic.isToolDataInstalled);
    	
    	PageReference pageRef = ttpic.performInstall();
    	System.assertEquals(true, ttpic.isInstalled);
    	System.assertEquals(true, ttpic.isToolDataInstalled);
    	
    	ApexPages.Message confirmMessage = ApexPages.getMessages()[0];
    	System.assertEquals(TreasuryToolPostInstallController.CONFIGURATION_INSTALLED_SUCCESSFULLY, confirmMessage.getDetail());
    	
    	pageRef = ttpic.performUninstall();
    	System.assertEquals(false, ttpic.isInstalled);
    	System.assertEquals(false, ttpic.isToolDataInstalled);
    	
    	confirmMessage = ApexPages.getMessages()[1];
    	System.assertEquals(TreasuryToolPostInstallController.CONFIGURATION_REMOVED_SUCCESSFULLY, confirmMessage.getDetail());
    	
    	pageRef = ttpic.performUninstall();
    	System.assertEquals(false, ttpic.isInstalled);
    	System.assertEquals(false, ttpic.isToolDataInstalled);
    	
    	confirmMessage = ApexPages.getMessages()[2];
    	System.assertEquals(TreasuryToolPostInstallController.CONFIGURATION_SYSTEM_NOT_INSTALLED, confirmMessage.getDetail());
    	
    	Test.stopTest();    	
    }      
}