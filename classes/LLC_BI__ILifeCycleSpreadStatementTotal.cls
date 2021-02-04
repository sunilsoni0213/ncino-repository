/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface ILifeCycleSpreadStatementTotal extends LLC_BI.IForce {
    List<LLC_BI.ILifeCycleSpreadStatementRecord> getRecords();
    Integer getRowNumber();
    LLC_BI.ILifeCycleSpreadStatement getStatement();
    String getTitle();
    Boolean includeInTotal();
    Boolean isDebit();
    Boolean isGrandTotal();
    Boolean isHideAllRecords();
    Boolean isHideCurrencySymbol();
}
