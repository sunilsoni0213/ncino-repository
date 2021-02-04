trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    
    List<ContentDocumentLink> cdLinksToProcess = new List<ContentDocumentLink>();
    
    for(ContentDocumentLink cdl : trigger.new){
        ID linkedEntity = cdl.LinkedEntityId;
        String sObjectTypeString = string.valueof(linkedEntity.getsobjecttype());
                
        if(sObjectTypeString == 'LLC_BI__Document_Collection__c'){
            cdLinksToProcess.add(cdl);
        }
    }
    
    if(cdLinksToProcess.size()>0){
          UpdatePlaceholderFromDocCollection.docusignUpdatePlaceholder(cdLinksToProcess);
    }
}