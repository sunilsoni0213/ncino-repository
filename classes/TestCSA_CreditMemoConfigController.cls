@isTest
public class TestCSA_CreditMemoConfigController {
	@isTest
	public static void initialize() {
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();
	}

	@isTest
	public static void back() {
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.back();

		Test.stopTest();
	}

	@isTest
	public static void backSecondary() {
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.backSecondary();

		Test.stopTest();
	}

	@isTest
	public static void creditMemoNew() {
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoNew();

		Test.stopTest();
	}

	@isTest
	public static void creditMemoSaveNewError() {
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoSaveNew();

		Test.stopTest();
	}

	@isTest
	public static void creditMemoSaveNewSuccess() {
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemo = new LLC_BI__Credit_Memo__c(
			Name = 'Test',
			LLC_BI__Object_API_Name__c = 'LLC_BI__Loan__c');
		CMCC.creditMemoSaveNew();

		Test.stopTest();
	}

	@isTest
	public static void creditMemoDelete() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__View__c testView = createView();
		nFORCE__Widget__c testWidget = createWidget();
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, testView.Id, testWidget.Id);
		nFORCE__Screen_Section__c testScreenSection1 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 20, null, null);
		nFORCE__Screen_Section__c testScreenSection2 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 30, null, null);
		nFORCE__Layout__c testlayout = createLayout();
		nFORCE__Section_Configuration__c testSectionConfiguration = createSectionConfiguration(testScreenSection.Id, testlayout.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoDelete();

		Test.stopTest();
	}

	@isTest
	public static void creditMemoViewEdit() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();

		Test.stopTest();
	}

	@isTest
	public static void creditMemoEdit() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.creditMemoEdit();

		Test.stopTest();
	}

	@isTest
	public static void creditMemoEditSave() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.creditMemoEdit();
		CMCC.creditMemoSaveEdit();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionEdit() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, null, null);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.screenSectionId = testScreenSection.Id;
		CMCC.screenSectionEdit();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionNewFirst() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.isHeadless = false;
		CMCC.displayOrder = null;
		CMCC.screenSectionNew();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionNewHeadless() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, null, null);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.isHeadless = true;
		CMCC.displayOrder = testScreenSection.nFORCE__Display_Order__c;
		CMCC.screenSectionNew();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionNewSecond() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, null, null);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.isHeadless = false;
		CMCC.displayOrder = testScreenSection.nFORCE__Display_Order__c;
		CMCC.screenSectionNew();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionSaveNewNonHeadless() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__View__c testView = createView();
		nFORCE__Widget__c testWidget = createWidget();
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, testView.Id, testWidget.Id);
		nFORCE__Screen_Section__c testScreenSection1 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 20, null, null);
		nFORCE__Screen_Section__c testScreenSection2 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 30, null, null);
		nFORCE__Layout__c testlayout = createLayout();
		nFORCE__Section_Configuration__c testSectionConfiguration = createSectionConfiguration(testScreenSection.Id, testlayout.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.displayOrder = testScreenSection1.nFORCE__Display_Order__c;
		CMCC.isHeadless = false;
		CMCC.screenSection = new nFORCE__Screen_Section__c(
			Name = 'Test',
			nFORCE__sObject_Type__c = testCreditMemo.LLC_BI__Object_API_Name__c,
			nFORCE__Display_Order__c = testScreenSection1.nFORCE__Display_Order__c + 10,
			nFORCE__Section_Resource__c = 'MappedSObjectScreenResource',
			nFORCE__Screen__c = testScreen.Id);
		CMCC.screenSectionSaveNew();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionSaveNewHeadless() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__View__c testView = createView();
		nFORCE__Widget__c testWidget = createWidget();
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, testView.Id, testWidget.Id);
		nFORCE__Screen_Section__c testScreenSection1 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 11, null, null);
		nFORCE__Screen_Section__c testScreenSection2 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 12, null, null);
		nFORCE__Layout__c testlayout = createLayout();
		nFORCE__Section_Configuration__c testSectionConfiguration = createSectionConfiguration(testScreenSection.Id, testlayout.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.displayOrder = testScreenSection1.nFORCE__Display_Order__c;
		CMCC.isHeadless = false;
		CMCC.screenSection = new nFORCE__Screen_Section__c(
			Name = 'Test',
			nFORCE__sObject_Type__c = testCreditMemo.LLC_BI__Object_API_Name__c,
			nFORCE__Display_Order__c = testScreenSection1.nFORCE__Display_Order__c + 10,
			nFORCE__Section_Resource__c = 'MappedSObjectScreenResource',
			nFORCE__Screen__c = testScreen.Id,
			nFORCE__Headless__c = true);
		CMCC.screenSectionSaveNew();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionSaveNewWidgetNarrative() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__View__c testView = createView();
		nFORCE__Widget__c testWidget = createWidget();
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, testView.Id, testWidget.Id);
		nFORCE__Screen_Section__c testScreenSection1 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 11, null, null);
		nFORCE__Screen_Section__c testScreenSection2 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 12, null, null);
		nFORCE__Layout__c testlayout = createLayout();
		nFORCE__Section_Configuration__c testSectionConfiguration = createSectionConfiguration(testScreenSection.Id, testlayout.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.displayOrder = testScreenSection1.nFORCE__Display_Order__c;
		CMCC.isHeadless = false;
		CMCC.widgetType = 'Narrative';
		CMCC.screenSection = new nFORCE__Screen_Section__c(
			Name = 'Test',
			nFORCE__sObject_Type__c = testCreditMemo.LLC_BI__Object_API_Name__c,
			nFORCE__Display_Order__c = testScreenSection1.nFORCE__Display_Order__c + 10,
			nFORCE__Section_Resource__c = 'MappedSObjectScreenResource',
			nFORCE__Screen__c = testScreen.Id,
			nFORCE__Headless__c = true);
		CMCC.screenSectionSaveNew();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionSaveNewWidgetSpreads() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__View__c testView = createView();
		nFORCE__Widget__c testWidget = createWidget();
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, testView.Id, testWidget.Id);
		nFORCE__Screen_Section__c testScreenSection1 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 11, null, null);
		nFORCE__Screen_Section__c testScreenSection2 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 12, null, null);
		nFORCE__Layout__c testlayout = createLayout();
		nFORCE__Section_Configuration__c testSectionConfiguration = createSectionConfiguration(testScreenSection.Id, testlayout.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.displayOrder = testScreenSection1.nFORCE__Display_Order__c;
		CMCC.isHeadless = false;
		CMCC.widgetType = 'Spreads_Appendix';
		CMCC.screenSection = new nFORCE__Screen_Section__c(
			Name = 'Test',
			nFORCE__sObject_Type__c = testCreditMemo.LLC_BI__Object_API_Name__c,
			nFORCE__Display_Order__c = testScreenSection1.nFORCE__Display_Order__c + 10,
			nFORCE__Section_Resource__c = 'MappedSObjectScreenResource',
			nFORCE__Screen__c = testScreen.Id,
			nFORCE__Headless__c = true);
		CMCC.screenSectionSaveNew();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionSaveNewWidgetApproval() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__View__c testView = createView();
		nFORCE__Widget__c testWidget = createWidget();
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, testView.Id, testWidget.Id);
		nFORCE__Screen_Section__c testScreenSection1 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 11, null, null);
		nFORCE__Screen_Section__c testScreenSection2 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 12, null, null);
		nFORCE__Layout__c testlayout = createLayout();
		nFORCE__Section_Configuration__c testSectionConfiguration = createSectionConfiguration(testScreenSection.Id, testlayout.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.displayOrder = testScreenSection1.nFORCE__Display_Order__c;
		CMCC.isHeadless = false;
		CMCC.widgetType = 'Approval_Process';
		CMCC.screenSection = new nFORCE__Screen_Section__c(
			Name = 'Test',
			nFORCE__sObject_Type__c = testCreditMemo.LLC_BI__Object_API_Name__c,
			nFORCE__Display_Order__c = testScreenSection1.nFORCE__Display_Order__c + 10,
			nFORCE__Section_Resource__c = 'MappedSObjectScreenResource',
			nFORCE__Screen__c = testScreen.Id,
			nFORCE__Headless__c = true);
		CMCC.screenSectionSaveNew();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionSaveNewWidgetGlobal() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__View__c testView = createView();
		nFORCE__Widget__c testWidget = createWidget();
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, testView.Id, testWidget.Id);
		nFORCE__Screen_Section__c testScreenSection1 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 20, null, null);
		nFORCE__Screen_Section__c testScreenSection2 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 30, null, null);
		nFORCE__Layout__c testlayout = createLayout();
		nFORCE__Section_Configuration__c testSectionConfiguration = createSectionConfiguration(testScreenSection.Id, testlayout.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.displayOrder = testScreenSection1.nFORCE__Display_Order__c;
		CMCC.isHeadless = false;
		CMCC.widgetType = 'Global_Analysis';
		CMCC.screenSection = new nFORCE__Screen_Section__c(
			Name = 'Test',
			nFORCE__sObject_Type__c = testCreditMemo.LLC_BI__Object_API_Name__c,
			nFORCE__Display_Order__c = testScreenSection1.nFORCE__Display_Order__c + 10,
			nFORCE__Section_Resource__c = 'MappedSObjectScreenResource',
			nFORCE__Screen__c = testScreen.Id,
			nFORCE__Headless__c = true);
		CMCC.screenSectionSaveNew();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionSaveNewWidgetDebt() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__View__c testView = createView();
		nFORCE__Widget__c testWidget = createWidget();
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, testView.Id, testWidget.Id);
		nFORCE__Screen_Section__c testScreenSection1 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 11, null, null);
		nFORCE__Screen_Section__c testScreenSection2 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 12, null, null);
		nFORCE__Layout__c testlayout = createLayout();
		nFORCE__Section_Configuration__c testSectionConfiguration = createSectionConfiguration(testScreenSection.Id, testlayout.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.displayOrder = testScreenSection1.nFORCE__Display_Order__c;
		CMCC.isHeadless = false;
		CMCC.widgetType = 'Debt_Schedule';
		CMCC.screenSection = new nFORCE__Screen_Section__c(
			Name = 'Test',
			nFORCE__sObject_Type__c = testCreditMemo.LLC_BI__Object_API_Name__c,
			nFORCE__Display_Order__c = testScreenSection1.nFORCE__Display_Order__c + 10,
			nFORCE__Section_Resource__c = 'MappedSObjectScreenResource',
			nFORCE__Screen__c = testScreen.Id,
			nFORCE__Headless__c = true);
		CMCC.screenSectionSaveNew();

		Test.stopTest();
	}

	@isTest
	public static void buildLayouLink() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, null, null);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.screenSectionId = testScreenSection.Id;
		CMCC.buildLayoutLink();

		Test.stopTest();
	}

	@isTest
	public static void widgetPicklist() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10,  null, null);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.getWidgetOptions();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionDelete() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__View__c testView = createView();
		nFORCE__Widget__c testWidget = createWidget();
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, testView.Id, testWidget.Id);
		nFORCE__Screen_Section__c testScreenSection1 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 20, null, null);
		nFORCE__Screen_Section__c testScreenSection2 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 30, null, null);
		nFORCE__Layout__c testlayout = createLayout();
		nFORCE__Section_Configuration__c testSectionConfiguration = createSectionConfiguration(testScreenSection.Id, testlayout.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.screenSectionId = testScreenSection.Id;
		CMCC.isHeadless = false;
		CMCC.displayOrder = testScreenSection.nFORCE__Display_Order__c;
		CMCC.screenSectionDelete();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionDeleteHeadless() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__View__c testView = createView();
		nFORCE__Widget__c testWidget = createWidget();
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, null, null);
		nFORCE__Screen_Section__c testScreenSection1 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 11, testView.Id, testWidget.Id);
		nFORCE__Screen_Section__c testScreenSection2 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 12, null, null);
		nFORCE__Layout__c testlayout = createLayout();
		nFORCE__Section_Configuration__c testSectionConfiguration = createSectionConfiguration(testScreenSection.Id, testlayout.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.screenSectionId = testScreenSection1.Id;
		CMCC.isHeadless = true;
		CMCC.displayOrder = testScreenSection1.nFORCE__Display_Order__c;
		CMCC.screenSectionDelete();

		Test.stopTest();
	}

	@isTest
	public static void screenSectionSaveEdit() {
		nFORCE__Screen__c testScreen = createScreen();
		LLC_BI__Credit_Memo__c testCreditMemo = createCreditMemo(testScreen.Id);
		nFORCE__View__c testView = createView();
		nFORCE__Widget__c testWidget = createWidget();
		nFORCE__Screen_Section__c testScreenSection = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 10, null, null);
		nFORCE__Screen_Section__c testScreenSection1 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 11, testView.Id, testWidget.Id);
		nFORCE__Screen_Section__c testScreenSection2 = createScreenSection(testScreen.Id, testCreditMemo.LLC_BI__Object_API_Name__c, 12, null, null);
		nFORCE__Layout__c testlayout = createLayout();
		nFORCE__Section_Configuration__c testSectionConfiguration = createSectionConfiguration(testScreenSection.Id, testlayout.Id);
		CSA_CreditMemoConfigController CMCC = new CSA_CreditMemoConfigController();

		Test.startTest();

		CMCC.creditMemoId = testCreditMemo.Id;
		CMCC.creditMemoViewEdit();
		CMCC.screenSection = testScreenSection1;
		CMCC.screenSectionSaveEdit();

		Test.stopTest();
	}

	private static nFORCE__Screen__c createScreen() {
		nFORCE__Screen__c newS = new nFORCE__Screen__c(
			Name = 'Test',
			nFORCE__Disable_Print__c = true);

		Database.insert(newS);
		return newS;
	}

	private static LLC_BI__Credit_Memo__c createCreditMemo(Id screenId) {
		LLC_BI__Credit_Memo__c newC = new LLC_BI__Credit_Memo__c(
			Name = 'Test',
			LLC_BI__FScreen__c = screenId,
			LLC_BI__Object_API_Name__c = 'LLC_BI__Loan__c',
			LLC_BI__Is_Template__c = true,
			LLC_BI__Description__c = 'Test Description');

		Database.insert(newC);
		return newC;
	}

	private static nFORCE__Screen_Section__c createScreenSection(Id screenId, String objectAPI, Decimal display, Id viewId, Id widgetId) {
		nFORCE__Screen_Section__c newSS = new nFORCE__Screen_Section__c(
			Name = 'Test',
			nFORCE__sObject_Type__c = objectAPI,
			nFORCE__Display_Order__c = display,
			nFORCE__Section_Resource__c = 'MappedSObjectScreenResource',
			nFORCE__Screen__c = screenId,
			nFORCE__Screen_View__c = viewId,
			nFORCE__Widget__c = widgetId);

		Database.insert(newSS);
		return newSS;
	}

	private static nFORCE__View__c createView() {
		nFORCE__View__c newV = new nFORCE__View__c(
			nFORCE__Read_Only__c = 'Test');

		Database.insert(newV);
		return newV;
	}

	private static nFORCE__Widget__c createWidget() {
		nFORCE__Widget__c newW = new nFORCE__Widget__c(
			Name = 'Test');

		Database.insert(newW);
		return newW;
	}

	private static nFORCE__Section_Configuration__c createSectionConfiguration(Id screenSectionId, Id layoutId) {
		nFORCE__Section_Configuration__c newSC = new nFORCE__Section_Configuration__c(
			nFORCE__Screen_Section__c = screenSectionId,
			nFORCE__Layout__c = layoutId,
			nFORCE__sObject_Type__c = 'LLC_BI__Loan__c',
			nFORCE__Display_Order__c = 1.00,
			nFORCE__lookupKey__c = '12345678765432');

		Database.insert(newSC);
		return newSC;
	}

	private static nFORCE__Layout__c createLayout() {
		nFORCE__Layout__c newL = new nFORCE__Layout__c(
			Name = 'Test');

		Database.insert(newL);
		return newL;
	}
}