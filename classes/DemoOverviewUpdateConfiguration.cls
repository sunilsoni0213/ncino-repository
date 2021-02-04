global with sharing class DemoOverviewUpdateConfiguration extends nFORCE.ASystemConfigurable {
    public override PageReference configure(){
        PageReference r = Page.c__DemoOverviewUpdatePage;
        r.setRedirect(true);
        return r;
    }
    public override PageReference back(){
        return Page.LLC_BI__SystemAdministration;
    }
}