trigger RemoteDepositTrigger on LLC_BI__Remote_Deposit_Capture_Service__c (before update, after delete) {
    String beanName = 'nFORCE.EnqueueSnapshot';
    nFORCE.BeanFactory beanFactory = nFORCE.BeanFactory.getInstance();
    nFORCE.ACrossPackageService service = (nFORCE.ACrossPackageService) beanFactory.getBeanByUniqueName(beanName);
    
    List<SObject> sObjects = new List<SObject>();
    Set<Id> contextIds = new Set<Id>();
    
    for(Integer i = 0; i < trigger.old.size(); i++) {
        sObjects.add(trigger.old[i]);
        contextIds.add(trigger.old[i].Id);
    }
    
    service.setInputParameter('sObjects', sObjects);
    service.setInputParameter('contextIds', contextIds);
    service.execute();
    }