global virtual class ApprovalHistoryScreenResource
  extends nDESIGN.SObjectScreenResource{
  
  global virtual override void load(){
     Id objId = getSObject().Id;
     
    LLC_BI__Loan__c loan = [
      SELECT
        Id,
        Name,
        (
          SELECT
            TargetObjectId, 
            SystemModstamp, 
            StepStatus, 
            RemindersSent, 
            ProcessInstanceId, 
            OriginalActorId, 
            IsPending, 
            IsDeleted, 
            Id, 
            CreatedDate, 
            CreatedById, 
            Comments, 
            ActorId,
            Actor.Name
          FROM 
            ProcessSteps
          ORDER BY 
            SystemModstamp desc
        )
      FROM
        LLC_BI__Loan__c
       WHERE
        Id = :objId];
    
    setSObject(loan);
    super.load();
    
    for(ProcessInstanceHistory ps: ((LLC_BI__Loan__c) getSObject()).ProcessSteps){
      nDESIGN.IScreenResource r = new nDESIGN.SObjectScreenResource();
      r.setSObject(ps);
      r.load();
      getChildren().add(r);
    }
  }
  global virtual override String getUniqueResourceIdentifier(){
    return ApprovalHistoryScreenResource.class.toString()
        + '_' + getSObjectType().getDescribe().getName();
  }
  global override Type getType(){
    return ApprovalHistoryScreenResource.class;
  }
}