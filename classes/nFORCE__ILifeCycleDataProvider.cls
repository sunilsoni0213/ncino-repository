/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface ILifeCycleDataProvider {
    void addAllDelete(List<SObject> param0);
    void addAllInsert(List<SObject> param0);
    void addAllUpdate(List<SObject> param0);
    void addDelete(SObject param0);
    void addInsert(SObject param0);
    void addInsert(SObject param0, Boolean param1);
    void addUpdate(SObject param0);
    void clear();
    String generateLookupKey();
    Map<String,List<SObject>> getToDeleteChunks();
    List<String> getToDeleteKeys();
    List<SObject> getToDelete();
    Map<String,List<SObject>> getToInsertChunks();
    List<String> getToInsertKeys();
    List<SObject> getToInsert();
    Map<String,List<SObject>> getToUpdateChunks();
    List<String> getToUpdateKeys();
    List<SObject> getToUpdate();
}
