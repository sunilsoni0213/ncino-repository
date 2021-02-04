public with sharing class DemoOverviewUpdateController {

    public DemoOverviewUpdateController() {

    }

    public String getProfileName() {
        User user = [SELECT Id, Name FROM User WHERE Id =: userInfo.getUserId()];
        String userName = user.Name;
        return userName;
    }

    public PageReference updateOverview() {

        Map<String, Process_Overview_Configuration__c> processMap = new Map<String, Process_Overview_Configuration__c>();
        List<Process_Overview_Configuration__c> processList = [SELECT Id, Name, Stage__c, Link_URL__c, Active__c, Display_Order__c, Report_Name__c FROM Process_Overview_Configuration__c WHERE Active__c = true AND Report_Name__c != null ORDER BY Active__c, Display_Order__c];
        
        for (Process_Overview_Configuration__c p : processList) {
            processMap.put(p.Report_Name__c, p);
        }

        List<Report> reportList = [SELECT Id, Name FROM Report WHERE Name IN : processMap.keySet()];

        for (Report r : reportList) {
            Process_Overview_Configuration__c config = processMap.get(r.Name);
            if (config != null) {
                config.Link_URL__c = '/' + r.Id;    
            }
        }

        PageReference p = updateUrlField();

        update processList;
        return p;
    }

    public PageReference updateUrlField() {

        String communityName = System.Label.Community_Name;
        String communityEndUrl = System.Label.Community_End_Url;

        Network n = [SELECT 
                Id, 
                Name
            FROM 
                Network 
            WHERE 
                Name =: communityName];

        String startCommunityUrl = String.ValueOf(Network.getLoginUrl(n.Id));
        String endCommunityUrl = startCommunityUrl.remove(communityEndUrl);
        String startReturnUrl = URL.getSalesforceBaseUrl().toExternalForm();
        String endReturnUrl = startReturnUrl + RETURN_URL;

        Customer_Portal__c s = [SELECT 
                Community_Url__c 
            FROM 
                Customer_Portal__c 
            WHERE
                Active__c = true];

        s.Community_Url__c = endCommunityUrl;

        update s;
        return new PageReference(endReturnUrl);
    }

    private static final String RETURN_URL = '/home/home.jsp';
    private static final String PORTAL = 'portal';
}