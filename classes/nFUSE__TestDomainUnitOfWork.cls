/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TestDomainUnitOfWork {
    global TestDomainUnitOfWork() {

    }
global virtual class Mock extends nFUSE.DomainUnitOfWork {
    global Integer registerDeletedCallCount {
        get;
    }
    global Integer registerDirtyCallCount {
        get;
    }
    global Integer registerNewCallCount {
        get;
    }
    global Mock(List<Schema.SObjectType> sObjectTypes) {

    }
    global virtual void commitLogic() {

    }
    global Boolean hasCommitBeenPerformed() {
        return null;
    }
    global nFUSE.TestDomainUnitOfWork.Mock performDmlOnCommit() {
        return null;
    }
    global virtual void registerDeleted(SObject record) {

    }
    global override virtual void registerDirty(SObject record) {

    }
    global override virtual void registerNew(SObject record) {

    }
    global nFUSE.TestDomainUnitOfWork.Mock setException(Exception ex) {
        return null;
    }
}
}
