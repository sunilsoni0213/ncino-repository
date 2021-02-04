/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ACreditReportService {
    global ACreditReportService() {

    }
    global abstract String getCreditPlugin();
    global abstract void processCreditReports(List<nFUSE__Credit_Report__c> param0, Id param1);
    global abstract String requestCreditReport(String param0);
    global abstract List<String> requestCreditReports(List<String> param0);
    global virtual List<String> requestCreditReports(List<String> accts, Boolean forceRefresh) {
        return null;
    }
}
