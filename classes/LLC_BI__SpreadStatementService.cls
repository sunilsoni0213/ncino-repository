/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SpreadStatementService {
    global SpreadStatementService() {

    }
    global static void addSpreadStatementRecord(Id statementId, Id spreadRecordTotalId, String spreadRecordName, Boolean isDebit) {

    }
    global static void addSpreadStatementRecord(Id statementId, Id spreadRecordTotalId, String spreadRecordName, String recordType, Boolean isDebit) {

    }
    @RemoteAction
    global static void addSpreadStatementRecord(Id statementId, Id spreadRecordTotalId, String spreadRecordName, String recordType, Boolean isDebit, String displayType) {

    }
    global static void addSpreadStatementRecordTotal(Id statementId, String spreadTotalName, String spreadTotalTitle, Boolean isDebitTotal, Integer spreadTotalRow, String spreadRecordName, Boolean isDebitRecord, Boolean isRatio) {

    }
    global static void addSpreadStatementRecordTotal(Id statementId, String spreadTotalName, String spreadTotalTitle, Boolean isDebitTotal, Integer spreadTotalRow, String spreadRecordName, Boolean isDebitRecord, String groupType) {

    }
    global static void addSpreadStatementRecordTotal(Id statementId, String spreadTotalName, String spreadTotalTitle, Boolean isDebitTotal, Integer spreadTotalRow, String spreadRecordName, Boolean isDebitRecord, String groupType, String globalAnalysisType) {

    }
    global static void addSpreadStatementRecordTotal(Id statementId, String spreadTotalName, String spreadTotalTitle, Boolean isDebitTotal, Integer spreadTotalRow, String spreadRecordName, String chartRecordType, Boolean isDebitRecord, String groupType, String globalAnalysisType) {

    }
    @RemoteAction
    global static void addSpreadStatementRecordTotal(Id statementId, String spreadTotalName, String spreadTotalTitle, Boolean isDebitTotal, Integer spreadTotalRow, String spreadRecordName, String chartRecordType, Boolean isDebitRecord, String groupType, String globalAnalysisType, Boolean hideColumnTotals) {

    }
    global static void cloneBundledLinkedFields(LLC_BI.ILifeCycleStatementBundle clonedBundle, LLC_BI.ILifeCycleStatementBundle newBundle) {

    }
    @RemoteAction
    global static void cloneBundledLinkedFields(Id clonedBundleId, Id newBundleId) {

    }
    @RemoteAction
    global static Map<String,Object> createGlobalAnalysisSpreadStatement(LLC_BI.ILifeCycleLoan loan) {
        return null;
    }
    @RemoteAction
    global static Id createSpread(Id spreadId, Id collateralMgmtId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Set<Id>> getAllIdsForContext(Id contextId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Set<Id>> getAllIdsForGlobalAnalysis(Id loanId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Set<Id>> getAllIdsForSpread(Id spreadId, Boolean includeGlobalAnalysis) {
        return null;
    }
    @RemoteAction
    global static Map<String,Set<Id>> getAllIdsForStatement(Id statementId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Set<Id>> getAllIdsForStatements(List<Id> statementIdList) {
        return null;
    }
    @RemoteAction
    global static Set<Id> getBundleIdsForContextId(Id contextId) {
        return null;
    }
    @RemoteAction
    global static Set<Id> getBundleIdsForContextIds(List<Id> contextIds) {
        return null;
    }
    @RemoteAction
    global static Map<String,Set<Id>> getContextAndBundleIdsForContext(Id contextId) {
        return null;
    }
    @RemoteAction
    global static Map<String,Set<Id>> getContextAndBundleIdsForContexts(List<Id> contextIds) {
        return null;
    }
    @RemoteAction
    global static Map<Id,List<LLC_BI__Spread_Statement_Record_Group__c>> getLinkedRecordGroups(Id statementId, Boolean totalOnly, List<Integer> years) {
        return null;
    }
    @RemoteAction
    global static Map<Id,List<LLC_BI__Spread_Statement_Record_Value__c>> getLinkedRecordValues(Id statementId, Boolean totalOnly, List<Integer> years) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI__Spread_Statement_Record_Group__c> getRecordGroups(Id statementId, Boolean totalOnly, List<Integer> years) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI__Spread_Statement_Record_Total__c> getRecordTotals(Id statementId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI__Spread_Statement_Record_Value__c> getRecordValues(Id statementId, Boolean totalOnly, List<Integer> years) {
        return null;
    }
    @RemoteAction
    global static Map<String,Object> getShmorgishborg(Id contextId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI__Spread_Statement_Record__c> getSpreadStatementRecords(Id statementId, Id recordTotalId) {
        return null;
    }
    @RemoteAction
    global static Boolean isCalculatingRatios() {
        return null;
    }
    global static void linkSpreadRecord(Id statementId, Id recordToLinkId, Id targetLinkId) {

    }
    global static void linkSpreadRecord(Id statementId, Id recordToLinkId, Id targetLinkId, Boolean periodOverPeriodCalc) {

    }
    @RemoteAction
    global static void linkSpreadRecord(Id statementId, Id recordToLinkId, Id targetLinkId, Boolean periodOverPeriodCalc, Boolean priorFiscalYear) {

    }
    @RemoteAction
    global static List<LLC_BI.LifeCycleUnderwritingBundle> loadAllBundles(Id contextId) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.LifeCycleUnderwritingBundle loadBundle(Id bundleId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.LifeCycleUnderwritingBundle> loadBundles(List<Id> bundleIds) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.IForce> loadContextAndBundles(Id contextId) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.DebtAnalysis loadDebtSchedule(Id spreadId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.IForce> loadEntireContext(Id contextId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.IForce> loadEntireSpreadWithGlobalAnalysis(Id spreadId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.IForce> loadEntireSpreadWithoutGlobalAnalysis(Id spreadId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.IForce> loadEntireSpread(Id spreadId, Boolean includeGlobalAnalysis) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.IForce> loadEntireStatement(Id statementId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.LifeCycleSpreadStatementPeriodTotal> loadPeriodTotalsForRecordTotalId(Id recordTotalId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.LifeCycleSpreadStatementPeriodTotal> loadPeriodTotals(List<Id> periodTotalIds) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.LifeCycleSpreadStatementRecord> loadRecordsForRecordTotalId(Id recordTotalId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.LifeCycleSpreadStatementRecord> loadRecordsForStatementId(Id statementId) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.LifeCycleSpreadStatementRecord> loadRecords(List<Id> recordIds) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.RentRollContainer loadRentRollContainer(Id collateralId, String subType) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.SpreadSensitivityAnalysisContainer loadSensitivityAnalysisContainer(Id parentId) {
        return null;
    }
    @RemoteAction
    global static void loadTotals(Id statementId, List<Integer> years) {

    }
    @RemoteAction
    global static String readSpreadMetaData(Id statementId) {
        return null;
    }
    @RemoteAction
    global static void recalculateRatios() {

    }
    @RemoteAction
    global static List<LLC_BI.ILifeCycleStatement> retrieveSpreadStatements(LLC_BI.ILifeCycleStatementBundle bundle) {
        return null;
    }
    @RemoteAction
    global static List<LLC_BI.ILifeCycleSpread> retrieveSpreads(LLC_BI.ILifeCycleLoan loan) {
        return null;
    }
    @RemoteAction
    global static Id saveAttachment(String fileName, String body, Id parentId, String contentType) {
        return null;
    }
    @RemoteAction
    global static LLC_BI.DebtSchedule saveDebtSchedule(LLC_BI.DebtSchedule debtSchedule) {
        return null;
    }
    @RemoteAction
    global static void saveSpreadMetaData(Id statementId, String jsonSettings) {

    }
    @RemoteAction
    global static void updateIncludeInTotal(Id statementId, Id spreadRecordId, Boolean includeInTotal) {

    }
    @RemoteAction
    global static void updateRecords(LLC_BI.SpreadStatementCellUpdate obj) {

    }
    @RemoteAction
    global static void updateSpreadLegalEntityRatio(Id underwritingSummaryId, Id entityId, Boolean includeInRatios) {

    }
    @RemoteAction
    global static void updateSpreadOperation(Id statementId, Id spreadRecordId, String operation) {

    }
}
