<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>LLC_BI__X3rd_Party_Report_Late_MTK</fullName>
        <description>3rd party report is now late</description>
        <field>LLC_BI__MailerTeamKey__c</field>
        <formula>&quot;TPRLate&quot;</formula>
        <name>3rd Party Report Late MTK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>LLC_BI__Loan__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__X3rd_Party_Report_MTK</fullName>
        <description>TMK Update to notify 10 days left on report</description>
        <field>LLC_BI__MailerTeamKey__c</field>
        <formula>&quot;TPR10&quot;</formula>
        <name>3rd Party Report MTK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>LLC_BI__Loan__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>LLC_BI__Third Party Report Notification</fullName>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__third_party_report__c.LLC_BI__Report_Rcvd__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>If report is not received 10 days prior to due date (timed; 10 days before notify, 1 day before = notify late)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>