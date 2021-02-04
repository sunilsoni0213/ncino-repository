@isTest
public class TestCSA_PSCConfigurationController {
	@isTest
	public static void initialize() {
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();
	}

	@isTest
	public static void clear() {
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.clear();

		Test.stopTest();
	}

	@isTest
	public static void saveNoStage() {
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.productStateConfigSave();

		Test.stopTest();
	}

	@isTest
	public static void saveNoStatus() {
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.selectedStages = new List<String>{'Qualification'};
		PCC.productStateConfigSave();

		Test.stopTest();
	}

	@isTest
	public static void saveNoProductType() {
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.selectedStages = new List<String>{'Qualification'};
		PCC.selectedStatus = new List<String>{'Open'};
		PCC.productStateConfigSave();

		Test.stopTest();
	}

	@isTest
	public static void saveNoUsage() {
		LLC_BI__Product_Line__c testProductLine = createProductLine();
		LLC_BI__Product_Type__c testProductType = createProductType(testProductLine.Id);
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.selectedStages = new List<String>{'Qualification'};
		PCC.selectedStatus = new List<String>{'Open'};
		PCC.selectedProductTypes = new List<String>{testProductType.Id};
		PCC.productStateConfigSave();

		Test.stopTest();
	}

	@isTest
	public static void saveNoData() {
		LLC_BI__Product_Line__c testProductLine = createProductLine();
		LLC_BI__Product_Type__c testProductType = createProductType(testProductLine.Id);
		LLC_BI__Product_State_Config__c testPSC = createProductStateConfig(testProductType.Id,
																		   'Qualification',
																		   'Open',
																		   True,
																		   false,
																		   false,
																		   false,
																		   '',
																		   null);
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.selectedStages = new List<String>{'Qualification'};
		PCC.selectedStatus = new List<String>{'Open'};
		PCC.selectedProductTypes = new List<String>{testProductType.Id};
		PCC.isBooked = true;
		PCC.productStateConfigSave();

		Test.stopTest();
	}
	
	@isTest
	public static void saveSuccessfulBooked() {
		LLC_BI__Product_Line__c testProductLine = createProductLine();
		LLC_BI__Product_Type__c testProductType = createProductType(testProductLine.Id);
		LLC_BI__Product_State_Config__c testPSC = createProductStateConfig(testProductType.Id,
																		   'Qualification',
																		   'Open',
																		   True,
																		   false,
																		   false,
																		   false,
																		   '',
																		   null);
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.selectedStages = new List<String>{'Qualification', 'Proposal'};
		PCC.selectedStatus = new List<String>{'Open'};
		PCC.selectedProductTypes = new List<String>{testProductType.Id};
		PCC.isBooked = true;
		PCC.productStateConfigSave();

		Test.stopTest();
	}

	@isTest
	public static void saveSuccessfulClosed() {
		LLC_BI__Product_Line__c testProductLine = createProductLine();
		LLC_BI__Product_Type__c testProductType = createProductType(testProductLine.Id);
		LLC_BI__Product_State_Config__c testPSC = createProductStateConfig(testProductType.Id,
																		   'Qualification',
																		   'Open',
																		   false,
																		   True,
																		   false,
																		   false,
																		   '',
																		   null);
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.selectedStages = new List<String>{'Qualification', 'Proposal'};
		PCC.selectedStatus = new List<String>{'Open'};
		PCC.selectedProductTypes = new List<String>{testProductType.Id};
		PCC.isClosed = true;
		PCC.productStateConfigSave();

		Test.stopTest();
	}

	@isTest
	public static void saveSuccessfulExcluded() {
		LLC_BI__Product_Line__c testProductLine = createProductLine();
		LLC_BI__Product_Type__c testProductType = createProductType(testProductLine.Id);
		LLC_BI__Product_State_Config__c testPSC = createProductStateConfig(testProductType.Id,
																		   'Qualification',
																		   'Open',
																		   false,
																		   false,
																		   true,
																		   false,
																		   '',
																		   null);
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.selectedStages = new List<String>{'Qualification', 'Proposal'};
		PCC.selectedStatus = new List<String>{'Open'};
		PCC.selectedProductTypes = new List<String>{testProductType.Id};
		PCC.isExcluded = true;
		PCC.productStateConfigSave();

		Test.stopTest();
	}

	@isTest
	public static void saveSuccessfulTransmit() {
		LLC_BI__Product_Line__c testProductLine = createProductLine();
		LLC_BI__Product_Type__c testProductType = createProductType(testProductLine.Id);
		LLC_BI__Product_State_Config__c testPSC = createProductStateConfig(testProductType.Id,
																		   'Qualification',
																		   'Open',
																		   false,
																		   false,
																		   false,
																		   true,
																		   '',
																		   null);
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.selectedStages = new List<String>{'Qualification', 'Proposal'};
		PCC.selectedStatus = new List<String>{'Open'};
		PCC.selectedProductTypes = new List<String>{testProductType.Id};
		PCC.isReadyToTransmit = true;
		PCC.productStateConfigSave();

		Test.stopTest();
	}

	@isTest
	public static void saveExternalError() {
		LLC_BI__Product_Line__c testProductLine = createProductLine();
		LLC_BI__Product_Type__c testProductType = createProductType(testProductLine.Id);
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.selectedStages = new List<String>{'Qualification', 'Proposal'};
		PCC.selectedStatus = new List<String>{'Open'};
		PCC.selectedProductTypes = new List<String>{testProductType.Id};
		PCC.selectedExternalStages = 'Qualification';
		PCC.externalStageOrder = 0;
		PCC.productStateConfigSave();

		Test.stopTest();
	}

	@isTest
	public static void saveSuccessfulExternal() {
		LLC_BI__Product_Line__c testProductLine = createProductLine();
		LLC_BI__Product_Type__c testProductType = createProductType(testProductLine.Id);
		LLC_BI__Product_State_Config__c testPSC = createProductStateConfig(testProductType.Id,
																		   'Qualification',
																		   'Open',
																		   false,
																		   false,
																		   false,
																		   false,
																		   'Qualification',
																		   1);
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.selectedStages = new List<String>{'Qualification', 'Proposal'};
		PCC.selectedStatus = new List<String>{'Open'};
		PCC.selectedProductTypes = new List<String>{testProductType.Id};
		PCC.selectedExternalStages = 'Qualification';
		PCC.externalStageOrder = 1;
		PCC.productStateConfigSave();

		Test.stopTest();
	}

	@isTest
	public static void saveSuccessfulNoData() {
		LLC_BI__Product_Line__c testProductLine = createProductLine();
		LLC_BI__Product_Type__c testProductType = createProductType(testProductLine.Id);
		LLC_BI__Product_State_Config__c testPSC = createProductStateConfig(testProductType.Id,
																		   'Qualification',
																		   'Open',
																		   false,
																		   false,
																		   false,
																		   false,
																		   'Qualification',
																		   1);
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.selectedStages = new List<String>{'Qualification', 'Proposal'};
		PCC.selectedStatus = new List<String>{'Open'};
		PCC.selectedProductTypes = new List<String>{testProductType.Id};
		PCC.selectedExternalStages = 'Qualification';
		PCC.externalStageOrder = 1;
		PCC.productStateConfigSave();
		PCC.productStateConfigSave();

		Test.stopTest();
	}

	@isTest
	public static void stagePicklist() {
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.getStagePicklist();

		Test.stopTest();
	}

	@isTest
	public static void statusPicklist() {
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.getStatusPicklist();

		Test.stopTest();
	}

	@isTest
	public static void externalPicklist() {
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.getExternalStagePicklist();

		Test.stopTest();
	}

	@isTest
	public static void productTypes() {
		LLC_BI__Product_Line__c testProductLine = createProductLine();
		LLC_BI__Product_Type__c testProductType = createProductType(testProductLine.Id);
		CSA_PSCConfigurationController PCC = new CSA_PSCConfigurationController();

		Test.startTest();

		PCC.getProductTypePicklist();

		Test.stopTest();
	}

	private static LLC_BI__Product_Line__c createProductLine() {
		LLC_BI__Product_Line__c newPL = new LLC_BI__Product_Line__c(
			Name = 'Product Line');

		Database.insert(newPL);
		return newPL;
	}

	private static LLC_BI__Product_Type__c createProductType(Id plId) {
		LLC_BI__Product_Type__c newPT = new LLC_BI__Product_Type__c(
			Name = 'Product Type',
			LLC_BI__Product_Line__c = plId);

		Database.insert(newPT);
		return newPT;
	}

	private static LLC_BI__Product_State_Config__c createProductStateConfig(Id ptId, 
																			String stage, 
																			String status, 
																			Boolean booked, 
																			Boolean closed, 
																			Boolean excluded, 
																			Boolean transmit, 
																			String externalStage, 
																			Decimal display) {
		LLC_BI__Product_State_Config__c newPSC = new LLC_BI__Product_State_Config__c(
			LLC_BI__External_Stage__c = externalStage,
			LLC_BI__External_Stage_Order__c = display,
			LLC_BI__Is_Booked__c = booked,
			LLC_BI__Is_Closed__c = closed,
			LLC_BI__Is_Excluded_From_Stage_Duration__c = excluded,
			LLC_BI__Is_Ready_To_Transmit__c = transmit,
			LLC_BI__Product_Type__c = ptId,
			LLC_BI__Stage__c = stage,
			LLC_BI__Status__c = status);
			
		Database.insert(newPSC);
		return newPSC;																	
	}
}