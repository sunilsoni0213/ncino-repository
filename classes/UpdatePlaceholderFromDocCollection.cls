public class UpdatePlaceholderFromDocCollection {
    
    public static void docusignUpdatePlaceholder(List<contentDocumentLink> cdlList){
        
        ID DS = [SELECT LLC_BI__Document_Store__c
                 FROM LLC_BI__Document_Collection_Index__c
                 WHERE LLC_BI__Document_Collection_Reference__c = :cdlList[0].LinkedEntityId LIMIT 1].LLC_BI__Document_Store__c;
        
        ID DSI = [SELECT Id
                  FROM LLC_BI__Document_Store_Index__c
                  WHERE LLC_BI__Document_Store__c = :DS LIMIT 1].Id;
        
        ID placeholderId = [SELECT Id
                            FROM LLC_BI__LLC_LoanDocument__c
                            WHERE LLC_BI__Document_Store_Index__c = :DSI LIMIT 1].Id;
        
        ID contentVersionId = [SELECT contentdocument.LatestPublishedVersionId
                               FROM ContentDocumentLink 
                               WHERE Id = :cdlList[0].id LIMIT 1].contentdocument.LatestPublishedVersionId;
        
        nDOC.DocmanService dms = new nDOC.DocmanService();
        dms.linkContentWithPlaceholder(contentVersionId, placeholderId);
        
        LLC_BI__LLC_LoanDocument__c ld = new LLC_BI__LLC_LoanDocument__c();
        ld.Id = placeholderId;
        ld.LLC_BI__reviewStatus__c = 'Signed';
        update ld;
        
        LLC_BI__LLC_LoanDocComment__c ldCommentSUCCESS = new LLC_BI__LLC_LoanDocComment__c();
        ldCommentSUCCESS.LLC_BI__LLC_LoanDocument__c = placeholderId;
        ldCommentSUCCESS.LLC_BI__comment__c = 'Docusign Completed';
        insert ldCommentSUCCESS;

        
    }
    
}