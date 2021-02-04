<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>LLC_BI__AP_Stress_Index_Actual</fullName>
        <field>LLC_BI__AP_Stress_Index_actual__c</field>
        <formula>LLC_BI__Account__r.LLC_BI__AP_Stress_Index__c</formula>
        <name>AP Stress Index - Actual</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__AP_Stress_Index_RG</fullName>
        <field>LLC_BI__AP_Stress_Index_RG__c</field>
        <formula>IF(AND( LLC_BI__AP_Stress_Index_actual__c &lt;= 8, LLC_BI__AP_Stress_Index_actual__c &gt;=0),1, 
IF(AND( LLC_BI__AP_Stress_Index_actual__c &lt;= 10, LLC_BI__AP_Stress_Index_actual__c &gt;=8.01),2, 
IF(AND( LLC_BI__AP_Stress_Index_actual__c &lt;= 13, LLC_BI__AP_Stress_Index_actual__c &gt;=10.01),3, 
IF(AND( LLC_BI__AP_Stress_Index_actual__c &lt;= 15, LLC_BI__AP_Stress_Index_actual__c &gt;=13.01),5, 
IF(AND( LLC_BI__AP_Stress_Index_actual__c &lt;= 17, LLC_BI__AP_Stress_Index_actual__c &gt;=15.01),6, 
IF(LLC_BI__AP_Stress_Index_actual__c &gt;=17.01,7,0))))))</formula>
        <name>AP Stress Index RG</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Date</fullName>
        <description>Updates Approval date to todat</description>
        <field>Review_Date__c</field>
        <formula>Today()</formula>
        <name>Update Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Approved</fullName>
        <field>LLC_BI__Date_Decisioned__c</field>
        <formula>TODAY()</formula>
        <name>Update Date Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Approved</fullName>
        <field>LLC_BI__Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Approval Date Field</fullName>
        <actions>
            <name>Update_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LLC_BI__Annual_Review__c.LLC_BI__Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>This WF rule updates the Approval Date field on the Risk Rating Review.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>