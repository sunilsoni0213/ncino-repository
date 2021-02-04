/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IRelatedListDataProvider {
    void applyOverrideSettings(Map<String,Object> param0);
    String getFieldSetName();
    List<Schema.FieldSetMember> getFields();
    Boolean getHasInitialized();
    Schema.SObjectType getObjType();
    List<SObject> getObjectList();
    Integer getPaginationSize();
    String getTableTitleLabelName();
    void initialize();
    List<SObject> initializeData();
    Boolean pagingSupported();
    Boolean renderDeleteLink();
    Boolean renderEditLink();
    Boolean renderItemLink();
    void setObjId(Id param0);
    void sortObjectList(String param0, String param1);
}
