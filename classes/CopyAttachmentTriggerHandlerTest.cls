@isTest
private class CopyAttachmentTriggerHandlerTest {
    
    @isTest(SeeAllData=true)
    private static void runTest() {
    
        List<Credit_Memo_to_Forms_Copy__mdt> settingsList = [SELECT
                Id,
                Screen_Section_Name__c
            FROM
                Credit_Memo_to_Forms_Copy__mdt
            WHERE
                Active__c = true];
        
        String sectionName = settingsList[0].Screen_Section_Name__c;

        nDESIGN__Screen__c screen = new nDESIGN__Screen__c(
            Name = NAME);
        insert screen;

        System.assertNotEquals(null, screen.Id);
        System.assertEquals('Test', screen.Name);

        LLC_BI__Credit_Memo__c memo = new LLC_BI__Credit_Memo__c(
            Name = NAME,
            LLC_BI__Screen__c = screen.Id,
            LLC_BI__Is_Template__c = false);
        insert memo;

        System.assertNotEquals(null, memo.Id);
        System.assertEquals('Test', memo.Name);
        System.assertEquals(screen.Id, memo.LLC_BI__Screen__c);

        nDESIGN__Screen_Section__c section = new nDESIGN__Screen_Section__c(
            //Name = SECTION_NAME_1,
            Name = sectionName,
            nDESIGN__Screen__c = screen.Id,
            nDESIGN__Section_Resource__c = RESOURCE);
        insert section;

        System.assertNotEquals(null, section.Id);
        System.assertEquals(sectionName, section.Name);
        System.assertEquals(screen.Id, section.nDESIGN__Screen__c);
        System.assertEquals('MappedSObjectHierarchyScreenResource', section.nDESIGN__Section_Resource__c);

        Account account = new Account(
            Name = NAME);
        insert account;

        System.assertNotEquals(null, account.Id);
        System.assertEquals('Test', account.Name);

        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(
            Name = NAME,
            LLC_BI__Account__c = account.Id,
            LLC_BI__Credit_Memo__c = memo.Id);
        insert loan;

        System.assertNotEquals(null, loan.Id);
        System.assertEquals('Test', loan.Name);
        System.assertEquals(account.Id, loan.LLC_BI__Account__c);
        System.assertEquals(memo.Id, loan.LLC_BI__Credit_Memo__c);

        Attachment attach = new Attachment(
            Name = HTML,
            Body = Blob.ValueOf('Test Body'),
            ParentId = section.Id);
        insert attach;
        System.assertNotEquals(null, attach.Id);
        System.assertEquals('Rendered_View.html', attach.Name);
        System.assertEquals(section.Id, attach.ParentId);

        Test.startTest();
            attach.Body = Blob.ValueOf('New Body');
            update attach;
            //CopyAttachmentTriggerHandler.updateFields(attach.Id);
        Test.stopTest();
    }

    private static final String NAME = 'Test';
    private static final String HTML = 'Rendered_View.html';
    private static final String RESOURCE = 'MappedSObjectHierarchyScreenResource';
    private static final String SECTION_NAME_1 = 'Loan Pricing Narrative';
    private static final String SECTION_NAME_2 = 'Borrower Structure Narrative';
    private static final String FIELD_NAME_1 = 'Loan_Pricing_Narrative__c';
    private static final String FIELD_NAME_2 = 'Borrower_Structure_Narrative__c';
    private static final String LOAN = 'LLC_BI__Loan__c';
    private static final String PRODUCT_PACKAGE = 'LLC_BI__Product_Package__c';
}