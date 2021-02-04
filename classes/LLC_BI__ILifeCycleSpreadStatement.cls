/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface ILifeCycleSpreadStatement extends LLC_BI.ILifeCycleStatement {
    LLC_BI.ILifeCycleSpreadStatementTotal getGrandTotal();
    List<LLC_BI.ILifeCycleSpread> getSpreads();
    String getStatementType();
    List<LLC_BI.ILifeCycleSpreadStatementTotal> getTotals();
    Boolean isBalanceSheet();
    Boolean isBudget();
    Boolean isCashFlowStatement();
    Boolean isIncomeStatement();
    Boolean isPFS();
    void setStatementType(String param0);
}
