/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IApprovalStep extends LLC_BI.IForce {
    LLC_BI.ILifeCycleUser getAssignedActor();
    String getComments();
    Datetime getDate();
    LLC_BI.ILifeCycleUser getOriginalActor();
    String getStatus();
    void mapFromDb(SObject param0);
    void setAssignedActor(LLC_BI.LifeCycleUser param0);
    void setComments(String param0);
    void setDate(Datetime param0);
    void setOriginalActor(LLC_BI.LifeCycleUser param0);
    void setStatus(String param0);
}
