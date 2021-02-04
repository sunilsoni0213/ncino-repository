public with sharing class CopyAttachmentTriggerHandler {
    
    public static void updateFields(Id attachment) {
        
        Attachment a = [SELECT Id, ParentId, Parent.Name, Name, Body, ContentType FROM Attachment WHERE Id =: attachment];
        
        String sectionName = a.Parent.Name;
        String bodyString = EncodingUtil.base64Encode(a.body);
        Blob bodyBlob = EncodingUtil.base64Decode(bodyString);
        String copyString = bodyBlob.toString();
        
        copyString = copyString.stripHtmlTags();
        copyString = copyString.replaceAll('\\<.*?\\>', '');
        copyString = copyString.replaceAll('&nbsp;', '');
        copyString = copyString.replace('/&amp;/g', '&');
        copyString = copyString.replace('/&lt;/g', '<');
        copyString = copyString.replace('/&gt;/g', '>');
        copyString = copyString.replace('/&quot;/g', '\"');
        copyString = copyString.replace('/&#039;/g', '');

        nDESIGN__Screen_Section__c section = [SELECT
                Id,
                Name,
                nDESIGN__Screen__c
            FROM
                nDESIGN__Screen_Section__c
            WHERE
                Id =: a.ParentId];

        nDESIGN__Screen__c screen = [SELECT
                Id
            FROM
                nDESIGN__Screen__c
            WHERE
                Id =: section.nDESIGN__Screen__c];

        LLC_BI__Credit_Memo__c memo = [SELECT
                Id
            FROM
                LLC_BI__Credit_Memo__c
            WHERE
                LLC_BI__Screen__c =: screen.Id];

        String memoId = memo.Id;

        List<LLC_BI__Loan__c> loanList = [SELECT
                Id
            FROM
                LLC_BI__Loan__c
            WHERE
                LLC_BI__Credit_Memo__c =: memo.Id];

        List<LLC_BI__Product_Package__c> packageList = [SELECT
                Id
            FROM
                LLC_BI__Product_Package__c
            WHERE
                LLC_BI__Credit_Memo__c =: memo.Id];

        List<Credit_Memo_to_Forms_Copy__mdt> settingsList = [SELECT
                DeveloperName,
                Field_API_Name__c,
                Object_API_Name__c,
                Screen_Section_Name__c,
                Active__c
            FROM
                Credit_Memo_to_Forms_Copy__mdt
            WHERE
                Active__c = true
            AND
                Screen_Section_Name__c =: sectionName];

        Set<String> loanStringSet = new Set<String>();
        Set<String> packageStringSet = new Set<String>();
        String loanSOQL = 'SELECT ';
        String packageSOQL = 'SELECT ';
        Integer loanFieldCount = 0;
        Integer packageFieldCount = 0;
        
        for (Credit_Memo_to_Forms_Copy__mdt s : settingsList) {
            if (s.Object_API_Name__c == LOAN) {
                loanSOQL += s.Field_API_Name__c + ',';
                loanFieldCount += 1;
                loanStringSet.add(s.Field_API_Name__c);
            } else if (s.Object_API_Name__c == PRODUCT_PACKAGE) {
                packageSOQL += s.Field_API_Name__c + ',';
                packageFieldCount += 1;
                packageStringSet.add(s.Field_API_Name__c);
            }
        }

        if (loanFieldCount > 0) {

            loanSOQL = loanSOQL.substring(0, loanSOQL.length() - 1);
            loanSOQL = loanSOQL + ' FROM LLC_BI__Loan__c WHERE LLC_BI__Credit_Memo__c =: memoId';

            try {

                List<sObject> results = database.query(loanSOQL);

                for (sObject l : results) {
                    for (String key : loanStringSet) {
                        l.put(key, copyString);
                    }
                }

                Database.update(results);

            } catch (DMLException e) {
                System.debug('The following exception has occurred with the loan update: ' + e.getMessage());
            }

        } else if (packageFieldCount > 0) {

            packageSOQL = packageSOQL.substring(0, packageSOQL.length() - 1);
            packageSOQL = packageSOQL + ' FROM LLC_BI__Product_Package__c WHERE LLC_BI__Credit_Memo__c =: memoId';

            try {

                List<sObject> results = database.query(packageSOQL);

                for (sObject l : results) {
                    for (String key : packageStringSet) {
                        l.put(key, copyString);
                    }
                }

                Database.update(results);

            } catch (DMLException e) {
                System.debug('The following exception has occurred with the package update: ' + e.getMessage());
            }
        }
    }

    private static final String LOAN = 'LLC_BI__Loan__c';
    private static final String PRODUCT_PACKAGE = 'LLC_BI__Product_Package__c';
}