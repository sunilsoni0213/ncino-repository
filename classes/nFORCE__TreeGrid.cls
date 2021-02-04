/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TreeGrid {
    global static String CELL_TYPE_CHECKBOX;
    global static String CELL_TYPE_DROPDOWN;
    global static String CELL_TYPE_DROPDOWNGROUP;
    global static String CELL_TYPE_STANDARD_CHECKBOX;
    global List<nFORCE.TreeGrid.Column> columns;
    global nFORCE.TreeGrid.GlobalOption globalOptions;
    global List<nFORCE.TreeGrid.Row> rows;
    global static String SELECTOR_COLUMN_IDENTIFIER;
    global TreeGrid() {

    }
    global nFORCE.TreeGrid addColumn(String label, nFORCE.TreeGrid.CellFactory cellFactory) {
        return null;
    }
    global nFORCE.TreeGrid addColumn(String label, Schema.DisplayType fieldDisplayType, String fieldPath, nFORCE.TreeGrid.CellFactory cellFactory) {
        return null;
    }
    global nFORCE.TreeGrid addColumns(List<nFORCE.TreeGrid.Column> columns) {
        return null;
    }
    global nFORCE.TreeGrid addFieldSetColumns(List<Schema.FieldSetMember> fields) {
        return null;
    }
    global nFORCE.TreeGrid addGlobalOption(String label, Boolean Enabled, String userData, Boolean selected) {
        return null;
    }
    global nFORCE.TreeGrid buildFilterTree(nFORCE.TreeGrid.RowFactory rowFactory, List<SObject> records, String idFieldName, List<String> filterByFields, Boolean makeFirstColumnSelectable) {
        return null;
    }
    global nFORCE.TreeGrid buildTree(nFORCE.TreeGrid.RowFactory rowFactory, List<SObject> records, String idFieldName, String parentIdFieldName) {
        return null;
    }
    global nFORCE.TreeGrid buildTree(nFORCE.TreeGrid.RowFactory rowFactory, List<SObject> records, String idFieldName, String parentIdFieldName, Boolean makeFirstColumnSelectable) {
        return null;
    }
    global static String createActionResponseMessage(String text, String type) {
        return null;
    }
    global static String createActionResponseModal(Map<String,Object> modal, Map<String,Object> cancelButton, Map<String,Object> continueButton) {
        return null;
    }
    global static String createActionResponseModal(Map<String,Object> modal, Map<String,Object> cancelButton, Map<String,Object> continueButton, Map<String,Object> saveButton) {
        return null;
    }
    global static String createActionResponseModal(String title, String bodyTemplateUrl, Map<String,String> params, Map<String,String> continueButton, Map<String,String> cancelButton) {
        return null;
    }
    global static String createActionResponseParentUrl(String url) {
        return null;
    }
    global static String createActionResponseTree(nFORCE.TreeGrid tree) {
        return null;
    }
    global static String createActionResponseUrl(String url) {
        return null;
    }
    global static String createTreeResponse(nFORCE.TreeGrid tree) {
        return null;
    }
    global static nFORCE.TreeGrid.Option parseJsonOption(String jsonInput) {
        return null;
    }
    global static nFORCE.TreeGrid parseJsonTree(String jsonInput) {
        return null;
    }
global class Cell {
    global String cellName;
    global Boolean excludeFromDisabledStyle;
    global List<nFORCE.TreeGrid.Option> options;
    global Boolean selected;
    global String type;
    global String userData;
    global nFORCE.TreeGrid.Option value;
    global Cell() {

    }
}
global interface CellFactory {
    void initializeCell(nFORCE.TreeGrid param0, nFORCE.TreeGrid.Column param1, nFORCE.TreeGrid.Row param2, nFORCE.TreeGrid.Cell param3);
}
global class CheckboxCellFactory implements nFORCE.TreeGrid.CellFactory {
    global CheckboxCellFactory() {

    }
    global void initializeCell(nFORCE.TreeGrid treeGrid, nFORCE.TreeGrid.Column column, nFORCE.TreeGrid.Row row, nFORCE.TreeGrid.Cell cell) {

    }
}
global class Column {
    global nFORCE.TreeGrid.CellFactory cellFactory;
    global Object data;
    global Schema.DisplayType fieldDisplayType;
    global String fieldPath;
    global String label;
    global Map<String,String> picklistValueToLabel;
    global Boolean selected;
    global String userData;
    global Column() {

    }
}
global class DefaultCellFactory implements nFORCE.TreeGrid.CellFactory {
    global DefaultCellFactory() {

    }
    global void initializeCell(nFORCE.TreeGrid treeGrid, nFORCE.TreeGrid.Column column, nFORCE.TreeGrid.Row row, nFORCE.TreeGrid.Cell cell) {

    }
}
global class GlobalOption {
    global Boolean enabled;
    global List<nFORCE.TreeGrid.Option> options;
    global nFORCE.TreeGrid.Option value;
    global GlobalOption() {

    }
    global GlobalOption(Boolean enabled) {

    }
}
global class Option {
    global Decimal decimalValue;
    global Boolean enabled;
    global String formatCode;
    global String groupBy;
    global String isocode;
    global String label;
    global String style;
    global String userData;
    global Option(String label) {

    }
    global Option(String label, Boolean enabled) {

    }
    global Option(String label, String groupBy) {

    }
    global Option(Decimal dec, String fCode) {

    }
}
global class Row {
    global Map<String,nFORCE.TreeGrid.Cell> cellMap;
    global List<nFORCE.TreeGrid.Cell> cells;
    global List<nFORCE.TreeGrid.Row> children;
    global SObject data;
    global Integer depth;
    global Boolean expanded;
    global String filterName;
    global Id id;
    global Boolean isDisabled;
    global nFORCE.TreeGrid.Row parent;
    global String userData;
    global Row() {

    }
}
global interface RowFactory {
    void initializeRow(nFORCE.TreeGrid param0, nFORCE.TreeGrid.Row param1);
}
}
