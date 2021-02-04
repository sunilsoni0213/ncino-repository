/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SpreadStatementCellUpdate {
    global List<LLC_BI.SpreadStatementCellUpdate.RecordGroupVal> groups;
    global List<LLC_BI.SpreadStatementCellUpdate.GroupTotal> groupTotal;
    global List<LLC_BI.SpreadStatementCellUpdate.PeriodTotal> periodTotal;
    global List<LLC_BI.SpreadStatementCellUpdate.RecordPeriodVal> recordPeriods;
    global SpreadStatementCellUpdate() {

    }
global class GroupTotal {
    global String name;
    global Integer quarter;
    global Id recordTotalId;
    global Decimal val;
    global Integer year;
    global GroupTotal() {

    }
}
global class PeriodTotal {
    global String col;
    global String id;
    global Integer month;
    global String name;
    global String periodGUID;
    global Id periodId;
    global Id recordTotalId;
    global Id statementTypeId;
    global Decimal val;
    global Integer year;
    global PeriodTotal() {

    }
}
global class RecordGroupVal {
    global Boolean accumulate;
    global String id;
    global Integer quarter;
    global Id recordId;
    global Decimal val;
    global Integer year;
    global RecordGroupVal() {

    }
}
global class RecordPeriodVal {
    global String formula;
    global String id;
    global String periodGUID;
    global Id recordId;
    global Decimal val;
    global RecordPeriodVal() {

    }
}
}
